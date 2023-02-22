# frozen_string_literal: true

# Mor info at: https://dry-rb.org/gems/dry-configurable/0.11/testing/

require 'dry/configurable/test_interface'

FHTTPClient.configuration.enable_test_interface

RSpec.configure do |config|
  config.before { FHTTPClient.configuration.reset_config }
end
