# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'kramdown-scholar/version'

Gem::Specification.new do |gem|
  gem.name          = "kramdown-scholar"
  gem.version       = Kramdown::Parser::KRAMDOWN_GIST_VERSION
  gem.platform      = Gem::Platform::RUBY
  gem.authors       = ["Matteo Panella"]
  gem.email         = ["andreas@teyrow.com"]
  gem.description   = %q{Kramdown syntax scholar}
  gem.summary       = %q{Extend Kramdown syntax to generate latex output for scholar}
  gem.homepage      = "https://github.com/rfc1459/kramdown-scholar"

  gem.add_dependency('kramdown', '~> 0.14.0')

  gem.add_development_dependency('yard', '~> 0.8.3')
  gem.add_development_dependency('bundler', '>= 1.0.0')
  gem.add_development_dependency('rspec', '~> 2.12.0')
  gem.add_development_dependency('redcarpet', '~> 2.0')
  gem.add_development_dependency('github-markup', '~> 0.7.4')

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
