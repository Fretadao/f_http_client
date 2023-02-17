# frozen_string_literal: true

require_relative 'f_http_client/version'
require 'active_support/core_ext/array'
require 'active_support/core_ext/enumerable'
require 'active_support/core_ext/string'
require 'addressable'
require 'dry-configurable'
require 'dry-initializer'
require 'forwardable'
require 'httparty'
require 'f_service'

require 'f_http_client/service'
require 'f_http_client/log'
require 'f_http_client/store'
require 'f_http_client/cache/http_response_analizer'
require 'f_http_client/cache/key'
require 'f_http_client/cache/null'
require 'f_http_client/cache/rails'

require 'f_http_client/logger/default'
require 'f_http_client/logger/null'
require 'f_http_client/logger/rails'

require 'f_http_client/parser/response'
require 'f_http_client/processor/exception'
require 'f_http_client/processor/response'

module FHTTPClient
  extend Dry::Configurable

  setting :base_uri
  setting :log_strategy, default: :null
  setting :cache do
    setting :strategy, default: :null
    setting :expires_in, default: 0
  end

  def self.logger
    @logger ||= case config.log_strategy
                when :rails
                  FHTTPClient::Logger::Rails.new
                when :null
                  FHTTPClient::Logger::Null.new
                else
                  FHTTPClient::Logger::Default.new
                end
  end
end

require 'f_http_client/base'
