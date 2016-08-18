# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ping_thing/version'

Gem::Specification.new do |spec|
  spec.name          = "ping_thing"
  spec.version       = PingThing::VERSION
  spec.authors       = ["Nick Palaniuk"]
  spec.email         = ["npalaniuk@gmail.com"]

  spec.summary       = "Simple ping for all the links in your app"
  spec.description   = "Ping all the links in your app"
  spec.homepage      = "https://github.com/nikkypx/ping_thing"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  spec.executables   = "pingthing"
  spec.require_paths = ["lib"]

  spec.add_dependency "faraday", "~> 0.9.2"
  spec.add_dependency "spidr", "~> 0.6.0"
  spec.add_dependency "colorize", "~> 0.7.7"

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
