# frozen_string_literal: true

require 'forwardable'

module FHTTPClient
  module Logger
    # Logs nothing
    class Null
      def tagged(...) = block_given? ? yield(self) : self
      def debug(...) = nil
      def info(...) = nil
      def warn(...) = nil
      def error(...) = nil
      def fatal(...) = nil
      def unknown(...) = nil
    end
  end
end
