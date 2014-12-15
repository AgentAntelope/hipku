# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hipku/version'

Gem::Specification.new do |s|
  s.name          = 'hipku'
  s.version       = Hipku::VERSION
  s.summary       = "Encode any IP address as a haiku"
  s.description   = "A simple gem to encode IPv4 and IPv6 addresses as haiku. A port of http://gabrielmartin.net/projects/hipku/"
  s.authors       = ["Alex Sunderland"]
  s.email         = 'agentantelope+hipku@gmail.com'
  s.files         = `git ls-files`.split($/)
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ["lib"]
  s.homepage      = 'http://rubygems.org/gems/hipku'
  s.license       = 'MIT'

  s.add_development_dependency "rspec", "> 0"
  s.add_development_dependency "pry", "> 0"
end
