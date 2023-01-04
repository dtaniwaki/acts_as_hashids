$LOAD_PATH.unshift File.expand_path('../lib', __dir__)

# Test Coverage
require 'codeclimate-test-reporter'
require 'simplecov'

SimpleCov.start 'rails' do
  if ENV['CI']
    require 'simplecov-lcov'

    SimpleCov::Formatter::LcovFormatter.config do |c|
      c.report_with_single_file = true
      c.single_report_path = './coverage/lcov.info'
    end

    formatter SimpleCov::Formatter::MultiFormatter.new([
      SimpleCov::Formatter::LcovFormatter,
      CodeClimate::TestReporter::Formatter,
    ])
  else
    formatter SimpleCov::Formatter::HTMLFormatter
  end

  minimum_coverage 50
end

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
