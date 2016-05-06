$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

# Test Coverage
require 'codeclimate-test-reporter'
require 'coveralls'
require 'simplecov'
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([
  Coveralls::SimpleCov::Formatter,
  SimpleCov::Formatter::HTMLFormatter,
  CodeClimate::TestReporter::Formatter
])
SimpleCov.minimum_coverage 50
SimpleCov.start

require 'active_record'

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  host: 'localhost',
  database: 'test.db'
)

require 'acts_as_hashids'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.default_formatter = 'doc' if config.files_to_run.one?
  config.profile_examples = 10
  config.order = :random
  Kernel.srand config.seed
end
