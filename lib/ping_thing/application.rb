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
        spider.every_link do |origin, dest|
          count += 1
          exit if count == limit
          next unless origin.host =~ /#{host}/

          @report.add(origin.to_s, dest.to_s)
          count = 0
        end
      end
    end

    def exit_with_report
      at_exit { @report.display }
    end
  end
end
