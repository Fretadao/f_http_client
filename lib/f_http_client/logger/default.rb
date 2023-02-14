# frozen_string_literal: true

module FHTTPClient
  module Logger
    # A Basic logger to use when no logger is provided
    class Default
      def initialize(tags: [])
        @logger = ::Logger.new($stdout)
        @current_tags = tags
      end

      def tagged(*tags)
        tagged = self.class.new(tags: current_tags + tags)
        block_given? ? yield(tagged) : tagged
      end

      def debug(message) = add(::Logger::DEBUG, message)
      def info(message) = add(::Logger::INFO, message)
      def warn(message) = add(::Logger::WARN, message)
      def error(message) = add(::Logger::ERROR, message)
      def fatal(message) = add(::Logger::FATAL, message)
      def unknown(message) = add(::Logger::UNKNOWN, message)

      private

      attr_reader :logger, :current_tags

      def add(severity, message)
        formatted_tags = format_tags
        full_message = formatted_tags.empty? ? message : [format_tags, message].join(' - ')

        logger.add(severity, full_message)
      end

      def format_tags
        current_tags.map { |tag| "[#{tag}]" }.join(' ')
      end
    end
  end
end
