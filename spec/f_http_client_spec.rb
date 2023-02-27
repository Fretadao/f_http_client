# frozen_string_literal: true

RSpec.describe FHTTPClient do
  describe 'versioning' do
    it 'has a version number' do
      expect(FHTTPClient::VERSION).not_to be_nil
    end
  end

  # describe 'configuration' do
  #   subject(:config) { described_class.config }
  #
  #   describe '#base_uri' do
  #     context 'when no base_uri is provided' do
  #       before { described_class.configure }
  #
  #       it { expect(config.base_uri).to be_nil }
  #     end
  #
  #     context 'when base_uri is provided' do
  #       before { described_class.configure { |conf| conf.base_uri = 'https://api.blog.com' } }
  #
  #       it 'sets that base_uri config' do
  #         expect(config.base_uri).to eq('https://api.blog.com')
  #       end
  #     end
  #   end
  #
  #   describe '#log_strategy' do
  #     context 'when no log_strategy is provided' do
  #       before { described_class.configure }
  #
  #       it { expect(config.log_strategy).to eq(:null) }
  #     end
  #
  #     context 'when log_strategy is provided' do
  #       before { described_class.configure { |conf| conf.log_strategy = :rails } }
  #
  #       it 'sets that log_strategy config' do
  #         expect(config.log_strategy).to eq(:rails)
  #       end
  #     end
  #   end
  #
  #   describe '#cache' do
  #     describe '#strategy' do
  #       context 'when no strategy is provided' do
  #         before { described_class.configure }
  #
  #         it { expect(config.cache.strategy).to eq(:null) }
  #       end
  #
  #       context 'when strategy is provided' do
  #         before { described_class.configure { |conf| conf.cache.strategy = :rails } }
  #
  #         it 'sets that strategy config' do
  #           expect(config.cache.strategy).to eq(:rails)
  #         end
  #       end
  #     end
  #
  #     describe '#expires_in' do
  #       context 'when no expires_in is provided' do
  #         before { described_class.configure }
  #
  #         it { expect(config.cache.expires_in).to be_zero }
  #       end
  #
  #       context 'when expires_in is provided' do
  #         before { described_class.configure { |conf| conf.cache.expires_in = 3_600 } }
  #
  #         it 'sets that expires_in config' do
  #           expect(config.cache.expires_in).to eq(3_600)
  #         end
  #       end
  #     end
  #   end
  # end
end
