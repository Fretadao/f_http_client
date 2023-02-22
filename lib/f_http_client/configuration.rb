# frozen_string_literal: true

module FHTTPClient
  class Configuration
    extend Dry::Configurable

    setting :base_uri
    setting :log_strategy, default: :null
    setting :cache do
      setting :strategy, default: :null
      setting :expires_in, default: 0
    end
  end
end
