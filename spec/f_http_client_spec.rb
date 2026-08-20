# frozen_string_literal: true

RSpec.describe FHTTPClient do
  describe 'versioning' do
    # Kept in sync by release-please: this file is listed in extra-files, and the
    # marker below tells the generic updater which line to rewrite on release.
    it 'has a version number' do
      expect(FHTTPClient::VERSION).to eq('0.4.0') # x-release-please-version
    end
  end
end
