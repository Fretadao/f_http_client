# frozen_string_literal: true

module FHTTPClient
  module Processor
    # This Service proccess a HTTP response, generating a success or failure result.
    #
    # Example:
    #
    # def process
    #   response = OpenStruct.new(success?: false, parsed_response: {}, headers: {}, message: 'Conflict')
    #   processor = FHTTPClient::Processor::Response.new(response: response)
    #   processor.()
    #     .on_success { |value| "Success! #{value.inspect}"}
    #     .on_failure(:conflict) { |value| return "A conflict happened! #{value.inspect}"}
    #     .on_failure(:client_error) { |value| return "An unexpected client error happened #{value.inspect}"}
    #     .on_failure { |value| return "Generic #{value}" }
    # end
    #
    # proccess
    # # => "A conflict happened! {}"
    class Response < FHTTPClient::Service
      extend Forwardable

      option :response
      option :log_strategy, default: -> { :null }

      STATUS_FAMILIES = {
        200..299 => :successful,
        400..499 => :client_error,
        500..599 => :server_error,
        300..399 => :redirection,
        100..199 => :informational
      }.freeze

      private_constant :STATUS_FAMILIES

      def run
        log_data.and_then { success? ? success_response : failure_response }
      end

      private

      def_delegators :@response, :headers, :success?, :parsed_response, :code

      def success_response
        Success(response_type, response_family, data: response)
      end

      def failure_response
        Failure(response_type, response_family, data: response)
      end

      # Private:
      # Transform HTTParty response  message in to a symbol
      # Ex: When the request returns a 400 (Bad Request)
      #
      # # => :bad_request
      def response_type
        message.empty? ? :unknown_type : message.downcase.tr(' ', '_').to_sym
      end

      # Private:
      # Transform HTTParty response code in to a symbol
      # Ex: When the request returns a 400 (Bad Request)
      #
      # # => :client_error
      def response_family
        STATUS_FAMILIES
          .find(-> { [code, :unknown_family] }) { |codes, _family| codes.cover?(code.to_i) }
          .last
      end

      # Private
      # Generates a HTTParty response message from a Net::HTTPRespoonse Class
      # Examples:
      #
      # response_type(Net::HTTPOK)
      # # => "OK"
      #
      # response_type(Net::HTTPUnprocessableEntity)
      # # => "Unprocessable Entity"
      def message
        @message ||= response_class
                     .to_s
                     .delete_prefix('Net::HTTP')
                     .gsub(/([A-Z]+)([A-Z][a-z])/, '\1 \2')
                     .gsub(/([a-z])([A-Z])/, '\1 \2')
      end

      # Private
      # Get an HTTP status error name for a status code
      #
      # Ex: 400
      # # => "Net:HTTPBadRequest"
      def response_class
        Net::HTTPResponse::CODE_TO_OBJ[code.to_s].to_s
      end

      def log_data
        FHTTPClient::Log.(
          message: { request: request_log_data, response: response_log_data }.to_json,
          strategy: log_strategy,
          tags: 'EXTERNAL REQUEST'
        )
      end

      def request_log_data
        request = response.request
        request_options = request.options

        {
          method: request.http_method.name.split('::').last.upcase,
          path: request.uri.path,
          querystring: Addressable::URI.parse(request.uri.query)&.query_values,
          body: request_options[:body]
        }.compact_blank
      end

      def response_log_data
        { code: code, human_code: message, headers: headers, body: parsed_response }.compact_blank
      end
    end
  end
end
