# frozen_string_literal: true

module FixtureHelper
  def load_fixture_file(path)
    full_path = File.expand_path(File.join(__dir__, '../fixtures', path))
    File.read(full_path)
  end

  def load_fixture_json(path)
    JSON.parse(load_fixture_file(path))
  end

  def load_fixture_json_symbolized(path)
    JSON.parse(load_fixture_file(path), symbolize_names: true)
  end
end

RSpec.configure do |config|
  config.include FixtureHelper
end
