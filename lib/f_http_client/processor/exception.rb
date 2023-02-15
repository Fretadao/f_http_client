# frozen_string_literal: true

module FHTTPClient
  module Processor
    # This Service proccess a HTTP exception generating failure result.
    #
    # Example:
    #
    # def process
    #   error = Errno::ECONNREFUSED.new('Failed to open TCP connection to :80')
    #   FHTTPClient::Processor::ResponseProcessor.(error: error)
    #     .on_failure(:connection_refused) {  return 'The server has been refused the connection.' }
    #     .on_failure { |error_message| return "Generic #{error_message}" }
    # end
    #
    # proccess
    # # => 'The server has been refused the connection.'
    class Exception < FHTTPClient::Service
      attribute :error

      def run
        Failure(error_name, :exception, data: error)
      end

      private

      def error_name
        case error.class.to_s
        when 'Errno::ECONNREFUSED'
          :connection_refused
        when /timeout/i
          :timeout
        else
          :uncaught_error
        end
      end
    end
  end
end
