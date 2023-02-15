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
  #   FHTTPClient::Log.(message: { name: 'Bruno' }.to_json, tags: ['Response'])
  #   FHTTPClient::Log.(message: { response: { name: 'Bruno' } }.to_json, level: :warn)
  class Log < FHTTPClient::Service
    attributes :message, level: :info, tags: []

    def run
      FHTTPClient.logger.tagged(*Array(tags)).public_send(level, message)

      Success(:logged)
    end
  end
end
