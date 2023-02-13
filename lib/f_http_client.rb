# frozen_string_literal: true

require_relative 'f_http_client/version'
require 'active_support/core_ext/array'
require 'active_support/core_ext/enumerable'
require 'active_support/core_ext/string'
require 'httparty'

require 'f_http_client/cache/key'

module FHttpClient
  class Error < StandardError; end
  # Your code goes here...
end
