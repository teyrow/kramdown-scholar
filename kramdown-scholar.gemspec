# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'kramdown-scholar/version'

Gem::Specification.new do |gem|
  gem.name          = "kramdown-scholar"
  gem.version       = Kramdown::Parser::KRAMDOWN_SCHOLAR_VERSION
  gem.platform      = Gem::Platform::RUBY
  gem.authors       = ["Andreas Josephson"]
  gem.email         = ["andreas@teyrow.com"]
  gem.description   = %q{Kramdown syntax scholar}
  gem.summary       = %q{Extend Kramdown syntax to generate latex output for scholar}
  gem.homepage      = "https://github.com/teyrow/kramdown-scholar"

  gem.add_dependency('kramdown', '~> 1.5.0')
  gem.add_dependency('rake')

  gem.add_development_dependency('yard', '~> 0.8')
  gem.add_development_dependency('bundler')
  gem.add_development_dependency('rspec', '~> 3.2')
  gem.add_development_dependency('redcarpet', '~> 3.2')
  gem.add_development_dependency('github-markup', '~> 1.3 ')
  gem.add_development_dependency('pry')
  gem.add_development_dependency('cucumber')

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
