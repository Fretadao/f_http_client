# frozen_string_literal: true

module FHTTPClientFakeResponse
  def build_httparty_response(code: 200, parsed_response: {})
    request_object = HTTParty::Request.new Net::HTTP::Get, '/'
    response_object = Net::HTTPResponse::CODE_TO_OBJ[code.to_s].new('1.1', code, '')
    allow(response_object).to receive(:body)

    HTTParty::Response.new(request_object, response_object, -> { parsed_response })
  end
end

RSpec.configure do |config|
  config.include FHTTPClientFakeResponse
end
