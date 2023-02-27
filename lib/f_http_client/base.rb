# frozen_string_literal: true

module FHTTPClient
  # Allows to have an http client to build a service
  # @abstract
  class Base < FHTTPClient::Service
    include HTTParty

    DEFAULT_SKIP_CACHE_IF = ->(response) { FHTTPClient::Cache::HTTPResponseAnalyzer.not_cacheable?(response) }

    option :headers, default: -> { {} }
    option :query, default: -> { {} }
    option :body, default: -> { {} }
    option :options, default: -> { {} }
    option :path_params, default: -> { {} }

    parser FHTTPClient::Parser::Response

    def run
      configure_base_uri.and_then do
        response = make_cached_request.value!

        FHTTPClient::Processor::Response.(response: response, log_strategy: log_strategy)
      end
    rescue StandardError => e
      FHTTPClient::Processor::Exception.(error: e, log_strategy: log_strategy)
        .on_failure(:uncaught_error) { raise e }
    end

    def self.config
      raise NotImplementedError, 'Clients must implement .config'
    end

    def self.cache_strategy(strategy = nil)
      default_options[:cache_strategy] = config.cache.strategy if default_options[:cache_strategy].nil?
      return default_options[:cache_strategy] unless strategy

      default_options[:cache_strategy] = strategy
    end

    def self.cache_expires_in(expires_in = nil)
      default_options[:cache_expires_in] = config.cache.expires_in if default_options[:cache_expires_in].nil?

      return default_options[:cache_expires_in] unless expires_in

      default_options[:cache_expires_in] = expires_in
    end

    private

    def configure_base_uri
      return Success(:uri_already_configured) if self.class.base_uri.present?

      return Failure(:no_base_uri_configured) if config.base_uri.blank?

      self.class.base_uri(config.base_uri)

      Success(:base_uri_configured)
    end

    def make_cached_request
      FHTTPClient::Store.(
        key: cache_key,
        strategy: cache_strategy,
        block: -> { make_request },
        expires_in: cache_expires_in,
        skip_if: skip_cache_if
      )
    end

    def make_request
      raise NotImplementedError, 'Clients must implement #make_request'
    end

    def path_template
      raise NotImplementedError, 'Clients must implement #path_template'
    end

    def formatted_path
      @formatted_path ||= format(path_template, path_params)
    end

    def cache_key
      FHTTPClient::Cache::Key.generate(
        self.class,
        path: formatted_path,
        headers: headers,
        query: query,
        body: body,
        options: options
      )
    end

    def config
      self.class.config
    end

    def log_strategy
      config.log_strategy
    end

    def cache_strategy
      self.class.default_options[:cache_strategy] || config.cache.strategy
    end

    def cache_expires_in
      self.class.default_options[:cache_expires_in] || config.cache.expires_in
    end

    def skip_cache_if
      DEFAULT_SKIP_CACHE_IF
    end
  end
end
