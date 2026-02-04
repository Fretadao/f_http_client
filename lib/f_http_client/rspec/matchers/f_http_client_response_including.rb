# frozen_string_literal: true

RSpec::Matchers.define :f_http_client_response_including do |expected_hash|
  match do |actual|
    return false unless actual.respond_to?(:parsed_response)

    @actual_parsed = actual.parsed_response

    # Check if all expected key-value pairs are present in actual
    expected_hash.all? do |expected_key, expected_value|
      actual_value = @actual_parsed[expected_key]
      # Use values_match? to support nested matchers
      values_match?(expected_value, actual_value)
    end
  end

  failure_message do |actual|
    if actual.respond_to?(:parsed_response)
      "expected HTTParty::Response parsed_response to include #{expected_hash.inspect}, " \
        "but got #{@actual_parsed.inspect}"
    else
      "expected an HTTParty::Response, but got #{actual.class}"
    end
  end

  diffable
end
