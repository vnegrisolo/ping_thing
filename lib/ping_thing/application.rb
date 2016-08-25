module PingThing
  class Application
    attr_reader :success, :failure

    def self.run(argv)
      new(argv).run
    end

    def initialize(argv)
      @failure = {}
      @success = {}
      @options = Options.parse(argv)
      @url     = url
      @host    = host
      @limit   = limit
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
          exit if count == @limit
          next unless link.host =~ /#{host}/

          print "#{link}".colorize(:blue) + ' => '
          status = Faraday.head(link).status.to_s
          if status =~ /[23]\d{2}/
            puts status.colorize(:green)
            @success[link.to_s] = status
          else
            puts status.colorize(:red)
            @failure[link.to_s] = status
          end
          count = 0
        end
      end
    end

    def exit_with_report
      at_exit { PingThing::Report.new(@success, @failure).display }
    end
  end
end
