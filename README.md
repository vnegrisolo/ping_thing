# Ping Thing

CLI tool to check your app for broken links.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ping_thing'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ping_thing

## Usage

Use the `-u` or `-url` option to tell the spider where to start. It is also possible to pass an
`-l` or `-limit` option to set the maximum number of non-matching links to skip through before exiting since
the spider will run infinitely. You probably do not want to set this number really low otherwise the run might
exit early before thoroughly exercising your app. This limit defaults to 1000.

    $ pingthing [options]

    $ pingthing -u "http://localhost:3000/movies"

![Screenshot](examples/results.png)

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/nikkypx/ping_thing.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

