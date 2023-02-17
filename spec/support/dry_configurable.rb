# frozen_string_literal: true

# Mor info at: https://dry-rb.org/gems/dry-configurable/0.11/testing/

require 'dry/configurable/test_interface'

module FHTTPClient
  enable_test_interface
end

RSpec.configure do |config|
  config.before { FHTTPClient.reset_config }
end
