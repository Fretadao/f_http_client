# frozen_string_literal: true

module FHTTPClient
  # Allow to log a message to system log
  #
  # Attributes:
  # - strategy: symbol representing cache stragegy to be used (null or rails);
  # - block: the lambda to have its result cached;
  # - key: the cache key to be used to store the result;
  # - expires_in (optional): seconds to keep the result in cache;
  # - skip_if (optional): a block to run over the block result and decide if result caching must be persisted or skiped.
  #
  # Example:
  #   FHTTPClient::Cache.(strategy: :rails, key: 'users/list?name=bruno', block: -> { make_request })
  #   FHTTPClient::Cache.(strategy: :rails, key: 'users/list?name=bruno', block: -> { make_request }, expires_in: 15.minutes)
  #   FHTTPClient::Cache.(strategy: :rails, key: 'users/list?name=bruno', block: -> { make_request }, skip_if: ->(response) { response.status != 200 })
  class Store < FHTTPClient::Service
    option :strategy
    option :key
    option :block
    option :expires_in, default: -> {}
    option :skip_if, default: -> {}

    def run
      Success(
        :done,
        data: cache.fetch(key, { expires_in: expires_in, skip_if: skip_if }.compact_blank, &block)
      )
    end

    private

    def cache
      @cache ||= strategy == :rails ? FHTTPClient::Cache::Rails : FHTTPClient::Cache::Null
    end
  end
end
