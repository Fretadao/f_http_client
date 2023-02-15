# frozen_string_literal: true

module FHTTPClient
  # Allow defining keyword args for a class
  #
  # @example
  #   class User::Create < FHTTPClient::Service
  #     option :name
  #     option :age
  #     option :email, default: -> { 'guest@user.com' }
  #
  #     def run
  #       Success(:created, data: "Hello #{name}! Your email is: #{email}")
  #     end
  #   end
  #
  #   User.(name: 'Matheus', age: 22)
  #   => #<FService::Result::Success:0x0000557fae615ea8 @handled=false, @matching_types=[], @types=[:created], @value="Hello Bruno! Your email is: guest@user.com">
  class Service < FService::Base
    extend Dry::Initializer
  end
end
