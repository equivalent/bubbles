require "bundler/setup"
require "bubbles"
require 'support/test_helpers'
require 'irb' # for binding.irb debugging

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
