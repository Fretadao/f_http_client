# frozen_string_literal: true

module FHttpClient
  class Cache
    module Key
      def self.generate(*args)
        params = args.extract_options!
        klass = args.first.to_s

        [klass.underscore, params.compact_blank.to_query].filter_map(&:presence).join('?')
      end
    end
  end
end
