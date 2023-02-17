# frozen_string_literal: true

module StubRequestsHelper
  def allow_get_request(options = {}, to:)
    options = {
      headers: options[:headers] || { 'Content-Type' => 'application/json' },
      query: options[:query]
    }

    stub_request(:get, to).with(options.compact)
  end

  def stub_get(options = {}, to:, response_status: 200, response_body: {})
    allow_get_request(options, to: to)
      .to_return(
        status: response_status,
        body: response_body.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )
  end

  def allow_post_request(options = {}, to:)
    options = {
      headers: options[:headers] || { 'Content-Type' => 'application/json' },
      body: options[:body],
      query: options[:query]
    }

    stub_request(:post, to).with(options.compact)
  end

  def stub_post(options = {}, to:, response_status: 200, response_body: {})
    allow_post_request(options, to: to)
      .to_return(
        status: response_status,
        body: response_body.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )
  end

  def allow_patch_request(options = {}, to:)
    options = {
      headers: options[:headers] || { 'Content-Type' => 'application/json' },
      body: options[:body],
      query: options[:query]
    }

    stub_request(:patch, to).with(options.compact)
  end

  def stub_patch(options = {}, to:, response_status: 200, response_body: {})
    allow_patch_request(options, to: to)
      .to_return(
        status: response_status,
        body: response_body.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )
  end

  def allow_delete_request(options = {}, to:)
    options = {
      headers: options[:headers] || { 'Content-Type' => 'application/json' },
      query: options[:query]
    }

    stub_request(:delete, to).with(options.compact)
  end

  def stub_delete(options = {}, to:, response_status: 200, response_body: {})
    allow_delete_request(options, to: to)
      .to_return(
        status: response_status,
        body: response_body.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )
  end

  def stub_get_timeout(options = {}, to:)
    allow_get_request(options, to: to).to_timeout
  end

  def stub_get_error(options = {}, to:, error:, message: '')
    allow_get_request(options, to: to).to_raise(error.new(message))
  end
end

RSpec.configure do |config|
  config.include StubRequestsHelper
end
