# frozen_string_literal: true

module FHTTPClient
  module Cache
    RailsNotDefined = Class.new(StandardError)

    class Rails
      class << self
        def fetch(name, options = {})
          raise RailsNotDefined unless defined?(::Rails)

          cache_entry = cache.read(name)

          return cache_entry if cache_entry.present?
          return unless block_given?

          result = yield

          cache.write(name, result, options) unless options[:skip_if]&.(result)

          result
        end

        private

        def cache
          ::Rails.cache
        end
      end
    end
  end
end
