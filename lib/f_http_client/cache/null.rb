# frozen_string_literal: true

module FHTTPClient
  module Cache
    class Null
      class << self
        def fetch(_name, _options = nil)
          yield if block_given?
        end
      end
    end
  end
end
