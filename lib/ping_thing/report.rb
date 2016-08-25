module PingThing
  class Report
    def initialize
      @success_count = 0
      @failure = {}
    end

    def add(link, status)
      print "#{link}".colorize(:blue) + ' => '
      if status =~ /[23]\d{2}/
        puts status.colorize(:green)
        @success += 1
      else
        puts status.colorize(:red)
        @failure[link] = status
      end
    end

    def failure_count
      @failure.count
    end

    def number_of_requests
      @success_count + failure_count
    end

    def display
      puts
      puts "#{number_of_requests} total links hit"
      puts "+ #{@success_count} successful responses".colorize(:green)
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
