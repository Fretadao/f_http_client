# frozen_string_literal: true

module FHTTPClient
  module Logger
    # Logging with Rails logger
    class Rails
      extend Forwardable

      delegate %i[tagged debug info warn error fatal unknown] => :@logger

      def initialize
        @logger = ::Rails.logger
      end
    end
  end
end
