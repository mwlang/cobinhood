lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "cobinhood/version"

Gem::Specification.new do |s|
  s.name        = "cobinhood"
  s.version     = Cobinhood::VERSION
  s.authors     = ["Michael Lang"]
  s.email       = ["mwlang@cybrains.net"]
  s.homepage    = "https://github.com/mwlang/cobinhood"
  s.summary     = "Implements Cobinhood API"
  s.description = s.summary
  s.license     = "MIT"

  s.files = Dir["{assets,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_development_dependency 'bundler', '~> 1.15'
  s.add_development_dependency 'rake', '~> 10.0'
  s.add_development_dependency 'rspec', '~> 3.0'

  s.add_runtime_dependency 'faraday', '~> 0.12'
  s.add_runtime_dependency 'faraday_middleware', '~> 0.12'
end
