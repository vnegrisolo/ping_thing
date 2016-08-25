module PingThing
  class Application
    def self.run(argv)
      new(argv).run
    end

    def initialize(argv)
      @options = Options.parse(argv)
      @report = Report.new
      exit_with_report
    end

    def url
      raise ArgumentError, 'URL not given' unless @options[:url]
      raise ArgumentError, 'Invalid URL given' unless URI.parse(@options[:url]).kind_of?(URI::HTTP)
      URI.parse(@options[:url])
    end

    def limit
      @options[:limit]
    end

    def host
      url.hostname =~ /(?:www)?\.?(\w+\.\w+)/; $1
    end

    def run
      count = 0
      Spidr.start_at(url) do |spider|
        spider.every_url do |link|
          count += 1
          exit if count == limit
          next unless link.host =~ /#{host}/

          status = Faraday.head(link).status.to_s
          @report.add(link, status)
          count = 0
        end
      end
    end

    def exit_with_report
      at_exit { @report.display }
    end
  end
end
