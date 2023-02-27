# frozen_string_literal: true

RSpec.describe FHTTPClient do
  describe 'versioning' do
    it 'has a version number' do
      expect(FHTTPClient::VERSION).not_to be_nil
    end
  end
end
