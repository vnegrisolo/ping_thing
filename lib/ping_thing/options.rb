module PingThing
  module Options
    DEFAULT_OPTIONS = {
      limit: 1000
    }

    def self.parse(args)
      options = {}.tap do |options|
        OptionParser.new do |opts|
          opts.banner = 'Usage: pingthing [options]'

          opts.on('-u', '-url', 'The url to start the spider') { |u| options[:url] = u }
          opts.on('-l', '-limit', Integer, 'A limit for non-matching domains before exiting') { |l| options[:limit] = l }
        end.parse!(args)
      end

      DEFAULT_OPTIONS.merge(options)
    end
  end
end
