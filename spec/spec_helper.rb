# frozen_string_literal: true

require 'simplecov'

SimpleCov.start do
  add_filter 'spec'
  add_filter 'vendor'

  enable_coverage :branch
end

require 'bundler/setup'
require 'webmock/rspec'
require 'f_service/rspec'
require 'f_http_client/rspec'

require 'f_http_client'

Dir[File.join(File.expand_path(__dir__), 'support/**/*.rb')].each { |file| require file }

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
