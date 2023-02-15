# frozen_string_literal: true

RSpec.describe FHTTPClient::Store do
  describe '#run' do
    context 'when strategy is rails' do
      context 'but rails is not defined' do
        it 'requires rails to be defined' do
          expect { described_class.(strategy: :rails, key: '/user/1', block: -> { 'get /users/1' }) }
            .to raise_error(FHTTPClient::Cache::RailsNotDefined)
        end
      end

      context 'and rails is defined' do
        let(:block_result) { { name: 'Eurico Júnior', age: 2 } }
        let(:block_to_proccess) { -> { 'get /users/1' } }

        before { allow(FHTTPClient::Cache::Rails).to receive(:fetch).and_return(block_result) }

        context 'and only required attributes are informed' do
          it 'calls only required attributes to service', :aggregate_failures do
            service_result = described_class.(strategy: :rails, key: '/user/1', block: block_to_proccess).value

            expect(service_result).to eq(block_result)
            expect(FHTTPClient::Cache::Rails)
              .to have_received(:fetch) { |&block| expect(block).to eq(block_to_proccess) }
              .with('/user/1', {})
          end
        end

        context 'and skip_if option is informed' do
          let(:skip_if) { ->(result) { result == 2 } }

          it 'calls only required attributes to service', :aggregate_failures do
            service_result = described_class.(
              strategy: :rails,
              key: '/user/1',
              block: block_to_proccess,
              skip_if: skip_if
            ).value

            expect(service_result).to eq(block_result)
            expect(FHTTPClient::Cache::Rails)
              .to have_received(:fetch) { |&block| expect(block).to eq(block_to_proccess) }
              .with('/user/1', { skip_if: skip_if })
          end
        end

        context 'and expires_in option is informed' do
          let(:expires_in) { 3600 }

          it 'calls only required attributes to service', :aggregate_failures do
            service_result = described_class.(
              strategy: :rails,
              key: '/user/1',
              block: block_to_proccess,
              expires_in: expires_in
            ).value

            expect(service_result).to eq(block_result)
            expect(FHTTPClient::Cache::Rails)
              .to have_received(:fetch) { |&block| expect(block).to eq(block_to_proccess) }
              .with('/user/1', { expires_in: expires_in })
          end
        end
      end
    end

    context 'when strategy is null' do
      let(:block_result) { { name: 'André Costa', age: 2 } }
      let(:block_to_proccess) { -> { 'get /users/1' } }

      before { allow(FHTTPClient::Cache::Null).to receive(:fetch).and_return(block_result) }

      context 'and only required attributes are informed' do
        it 'calls only required attributes to service', :aggregate_failures do
          service_result = described_class.(strategy: :null, key: '/user/1', block: block_to_proccess).value

          expect(service_result).to eq(block_result)
          expect(FHTTPClient::Cache::Null)
            .to have_received(:fetch) { |&block| expect(block).to eq(block_to_proccess) }
            .with('/user/1', {})
        end
      end

      context 'and skip_if option is informed' do
        let(:skip_if) { ->(result) { result == 2 } }

        it 'calls only required attributes to service', :aggregate_failures do
          service_result = described_class.(
            strategy: :null,
            key: '/user/1',
            block: block_to_proccess,
            skip_if: skip_if
          ).value

          expect(service_result).to eq(block_result)
          expect(FHTTPClient::Cache::Null)
            .to have_received(:fetch) { |&block| expect(block).to eq(block_to_proccess) }
            .with('/user/1', { skip_if: skip_if })
        end
      end

      context 'and expires_in option is informed' do
        let(:expires_in) { 3600 }

        it 'calls only required attributes to service', :aggregate_failures do
          service_result = described_class.(
            strategy: :null,
            key: '/user/1',
            block: block_to_proccess,
            expires_in: expires_in
          ).value

          expect(service_result).to eq(block_result)
          expect(FHTTPClient::Cache::Null)
            .to have_received(:fetch) { |&block| expect(block).to eq(block_to_proccess) }
            .with('/user/1', { expires_in: expires_in })
        end
      end
    end
  end
end
