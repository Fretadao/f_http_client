# frozen_string_literal: true

# Mor info at: https://dry-rb.org/gems/dry-configurable/0.11/testing/

require 'dry/configurable/test_interface'

FHTTPClient::Configuration.enable_test_interface

RSpec.configure do |config|
  config.before { FHTTPClient::Configuration.reset_config }
end
