# frozen_string_literal: true

module FHTTPClient
  module Parser
    # Parse a json response letting this as symbol hash
    # Following those examples: https://github.com/jnunemaker/httparty/blob/master/examples/custom_parsers.rb
    # And looking default formats: https://github.com/jnunemaker/httparty/blob/fb7c40303b7e6429196ef748754505768520407c/lib/httparty/parser.rb#L42
    class Response < HTTParty::Parser
      protected

      def json
        JSON.parse(body, quirks_mode: true, allow_nan: true, symbolize_names: true)
      end
    end
  end
end
