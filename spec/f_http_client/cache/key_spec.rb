# frozen_string_literal: true

RSpec.describe FHttpClient::Cache::Key do
  describe '.generate' do
    context 'when no arg is provided' do
      it { expect(described_class.generate).to be_empty }
    end

    context 'when args are provided' do
      context 'and only class is provided' do
        it 'generates a cache key with class only' do
          expect(described_class.generate('Order::Item')).to eq('order/item')
        end
      end

      context 'and only params are provided' do
        it 'generates a cache key with params filled only' do
          expect(described_class.generate(product_id: 1, color: :green, quantity: '')).to eq('color=green&product_id=1')
        end
      end

      context 'and class and params are provided' do
        it 'generates a cache key with class and params filled' do
          expect(described_class.generate('Order::Item', product_id: 1, color: :green, quantity: ''))
            .to eq('order/item?color=green&product_id=1')
        end
      end
    end
  end
end
