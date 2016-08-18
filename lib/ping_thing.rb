require 'ping_thing/version'
require 'optparse'
require 'uri'

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
      @host    = host
      @limit   = limit
      exit_with_report
    end

    def url
      raise ArgumentError, 'URL not given' unless @options[:url]
      @url ||= @options[:url]
      URI.parse(@url)
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

  class Report
    def initialize(success, failure)
      @success = success
      @failure = failure
    end

    def success_count
      @success.keys.count
    end

    def failure_count
      @failure.keys.count
    end

    def number_of_requests
      success_count + failure_count
    end

    def display
      puts
      puts "#{number_of_requests} total links hit"
      puts "+ #{success_count} successful responses".colorize(:green)
      puts
      puts 'Failures:'
      puts
      puts "- #{failure_count} unsuccessful responses".colorize(:red)
      puts
      @failure.each_with_index do |(k, v), i|
        puts "#{i + 1})" + " #{k} => " + "#{v}".colorize(:red)
        puts
      end
    end
  end
end

