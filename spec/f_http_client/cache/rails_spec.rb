# frozen_string_literal: true

RSpec.describe FHTTPClient::Cache::Rails do
  describe '.fetch' do
    subject(:cache) { described_class }

    let(:cache_name) { 'abc-123' }

    context 'when rails is not defined' do
      let(:options) { { expires_in: 3600 } }
      let(:block) { -> { 10 * 10 } }

      it 'raises rails not defined exception' do
        expect { cache.fetch(cache_name, options, &block) }
          .to raise_error(FHTTPClient::Cache::RailsNotDefined)
      end
    end

    context 'when rails is defined' do
      let(:rails_class) { 'Rails' }
      let(:rails_cache_class) { 'Rails::Cache' }
      let(:rails_cache) { instance_spy(rails_cache_class) }
      let(:rails_spy) { class_spy(rails_class) }

      before do
        stub_const('Rails', rails_spy)
        allow(rails_spy).to receive(:cache).and_return(rails_cache)
        allow(rails_cache).to receive(:read).with(cache_name).and_return(cached_value)
      end

      context 'when result is cached' do
        let(:options) { { expires_in: 3600 } }
        let(:block) { -> { 10 * 10 } }
        let(:cached_value) { 'cached value' }

        it 'returns the cached value' do
          expect(cache.fetch(cache_name, options, &block)).to eq('cached value')
        end
      end

      context 'when result can be cached' do
        let(:cached_value) { nil }
        let(:is_odd) { ->(number) { number.odd? } }
        let(:options) { { expires_in: 3600, skip_if: is_odd } }
        let(:block) { -> { 10 * 10 } }

        it 'caches the value', :aggregate_failures do
          expect(cache.fetch(cache_name, options, &block)).to eq(100)
          expect(rails_cache).to have_received(:write).with(cache_name, 100, options)
        end
      end

      context 'when result can not be cached' do
        let(:cached_value) { nil }
        let(:is_odd) { ->(number) { number.odd? } }
        let(:options) { { expires_in: 3600, skip_if: is_odd } }
        let(:block) { -> { 3 * 5 } }

        it 'does not cache the value', :aggregate_failures do
          expect(cache.fetch(cache_name, options, &block)).to eq(15)
          expect(rails_cache).not_to have_received(:write)
        end
      end
    end
  end
end
