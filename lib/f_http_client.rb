# frozen_string_literal: true

require_relative 'f_http_client/version'
require 'active_support/core_ext/array'
require 'active_support/core_ext/enumerable'
require 'active_support/core_ext/string'
require 'httparty'

require 'f_http_client/cache/http_response_analizer'
require 'f_http_client/cache/key'
require 'f_http_client/cache/null'
require 'f_http_client/cache/rails'

module FHttpClient
  class Error < StandardError; end
  # Your code goes here...
end
