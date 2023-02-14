# frozen_string_literal: true

RSpec.describe FHttpClient::Cache::Null do
  describe '.fetch' do
    subject(:cache) { described_class }

    let(:cache_name) { 'abc-123' }

    context 'when no block is given' do
      it 'returns nil' do
        expect(cache.fetch(cache_name)).to be_nil
      end
    end

    context 'when some block is given' do
      let(:block) { -> { 3 * 5 } }

      it 'returns the result of the block execution' do
        expect(cache.fetch(cache_name, &block)).to eq(15)
      end
    end
  end
end
