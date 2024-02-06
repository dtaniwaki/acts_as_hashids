lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'acts_as_hashids/version'

Gem::Specification.new do |spec|
  spec.name          = 'acts_as_hashids'
  spec.version       = ActsAsHashids::VERSION
  spec.platform      = Gem::Platform::RUBY
  spec.authors       = ['dtaniwaki']
  spec.email         = ['daisuketaniwaki@gmail.com']

  spec.summary       = 'Use Youtube-Like ID in ActiveRecord seamlessly.'
  spec.description   = 'Use Youtube-Like ID in ActiveRecord seamlessly.'
  spec.homepage      = 'https://github.com/dtaniwaki/acts_as_hashids'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  spec.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = ['>= 2.3.0', '< 3.3']

  spec.add_runtime_dependency 'activerecord', '>= 4.0', '< 7.2'
  spec.add_runtime_dependency 'hashids', '~> 1.0'

  spec.add_development_dependency 'codeclimate-test-reporter', '~> 0.5'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.81.0'
  spec.add_development_dependency 'rubocop-rspec', '~> 1.24.0'
  spec.add_development_dependency 'simplecov', '~> 0.21.0'
  spec.add_development_dependency 'simplecov-lcov', '~> 0.8.0'
  spec.add_development_dependency 'sqlite3', '~> 1.3'
end
