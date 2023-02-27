# frozen_string_literal: true

module FHTTPClient
  # Allow to log a message to system log
  #
  # Attributes:
  # - message: object containint the message to be logged;
  # - level (optional): level symbol to log the message (debug, info, warn error, fatal or unknown);
  # - tags (optional): list of tags to be added to log line.
  #
  # Example:
  #   FHTTPClient::Log.(message: { name: 'Bruno' }.to_json)
  #   FHTTPClient::Log.(message: { name: 'Bruno' }.to_json, stragegy: :rails)
  #   FHTTPClient::Log.(message: { name: 'Bruno' }.to_json, tags: ['Response'])
  #   FHTTPClient::Log.(message: { response: { name: 'Bruno' } }.to_json, level: :warn)
  class Log < FHTTPClient::Service
    LOGGERS = {
      rails: FHTTPClient::Logger::Rails,
      default: FHTTPClient::Logger::Default
    }.freeze
    private_constant :LOGGERS

    option :message
    option :strategy, default: -> { :null }
    option :level, default: -> { :info }
    option :tags, default: -> { [] }

    def run
      logger.tagged(*Array(tags)).public_send(level, message)

      Success(:logged)
    end

    def logger
      @logger ||= LOGGERS.fetch(strategy, FHTTPClient::Logger::Null).new
    end
  end
end
