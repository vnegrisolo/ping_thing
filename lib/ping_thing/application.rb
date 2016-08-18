module PingThing
  class Application
    LIMIT = 1000
    attr_reader :success, :failure

    def self.run(args)
      new(args).run
    end

    def initialize(argv)
      @failure = {}
      @success = {}
      @options = parse_options(argv)
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
      @options[:limit] || LIMIT
    end

    def parse_options(argv)
      {}.tap do |options|
        OptionParser.new do |opts|
          opts.banner = 'Usage: pingthing [options]'

          opts.on('-u', '-url') { |u| options[:url] = u }
          opts.on('-l', '-limit') { |l| options[:limit] }
        end.parse!
      end
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
