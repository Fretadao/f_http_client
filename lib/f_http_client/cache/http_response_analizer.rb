# frozen_string_literal: true

module Routing
  module Cache
    module HTTPResponseAnalyzer
      attr_reader :response

      NOT_CACHEABLE_RESPONSES = %i[
        server_error?
        gateway_timeout?
        request_timeout?
        unauthorized?
        too_many_requests?
      ].freeze

      class << self
        def not_cacheable_responses
          NOT_CACHEABLE_RESPONSES
        end

        def not_cacheable?(response)
          not_cacheable_responses.any? do |not_cacheable_response|
            response.public_send(not_cacheable_response)
          end
        end
      end
    end
  end
end
