# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'acts_as_hashids/version'

Gem::Specification.new do |spec|
  spec.name          = 'acts_as_hashids'
  spec.version       = ActsAsHashids::VERSION
  spec.authors       = ['dtaniwaki']
  spec.email         = ['daisuketaniwaki@gmail.com']

  spec.summary       = 'Hashids in ActiveRecord effectively.'
  spec.description   = 'Use Hashids in ActiveRecord effectively.'
  spec.homepage      = 'https://github.com/dtaniwaki/acts_as_hashids'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'hashids', '~> 1.0'
  spec.add_dependency 'activerecord', '>= 4.0'

  spec.add_development_dependency 'bundler', '~> 1.11'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'sqlite3', '~> 1.3'
  spec.add_development_dependency 'rubocop', '= 0.37.2'
  spec.add_development_dependency 'rubocop-rspec', '= 1.4.0'
  spec.add_development_dependency 'simplecov', '~> 0.11'
  spec.add_development_dependency 'coveralls', '~> 0.8'
  spec.add_development_dependency 'codeclimate-test-reporter', '~> 0.5'
end
