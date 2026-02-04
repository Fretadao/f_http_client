# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'RSpec::Matchers' do
  describe '#f_http_client_response_including' do
    context 'when actual is not an HTTParty::Response' do
      let(:not_a_response) { { status: 'ok' } }

      it 'does not match' do
        expect(not_a_response).not_to f_http_client_response_including(status: 'ok')
      end

      it 'shows helpful error message' do
        expect { expect(not_a_response).to f_http_client_response_including(status: 'ok') }
          .to raise_error(
            RSpec::Expectations::ExpectationNotMetError,
            /expected an HTTParty::Response, but got Hash/
          )
      end
    end

    context 'when actual is an HTTParty::Response' do
      let(:response) { instance_double(HTTParty::Response, parsed_response: parsed_response_data) }

      context 'and informed value is a simple object' do
        context 'but object is not equal to parsed_response' do
          let(:parsed_response_data) { { status: 'ok', code: 200 } }

          it 'does not match when value differs' do
            expect(response).not_to f_http_client_response_including(status: 'error')
          end

          it 'does not match when key is missing' do
            expect(response).not_to f_http_client_response_including(missing_key: 'value')
          end

          it 'shows expected vs actual in error message' do
            expect { expect(response).to f_http_client_response_including(status: 'error', code: 500) }
              .to raise_error(
                RSpec::Expectations::ExpectationNotMetError,
                /expected HTTParty::Response parsed_response to include/
              )
          end
        end

        context 'and object is equal to parsed_response' do
          let(:parsed_response_data) { { status: 'ok', code: 200 } }

          it 'matches when all expected key-value pairs are present' do
            expect(response).to f_http_client_response_including(status: 'ok', code: 200)
          end

          it 'matches when subset of keys match' do
            expect(response).to f_http_client_response_including(status: 'ok')
          end
        end
      end

      context 'and informed value is a matcher' do
        let(:parsed_response_data) do
          {
            products: [{ id: 1, name: 'Product A' }, { id: 2, name: 'Product B' }],
            page: 1,
            total: 2
          }
        end

        context 'but matcher does not match parsed_response' do
          it 'fails when nested matcher does not match' do
            expect(response).not_to f_http_client_response_including(products: have_attributes(size: 3))
          end
        end

        context 'and matcher matches parsed_response' do
          it 'supports have_attributes matcher' do
            expect(response).to f_http_client_response_including(products: have_attributes(size: 2))
          end

          it 'supports a_hash_including matcher' do
            expect(response).to f_http_client_response_including(
              products: a_collection_containing_exactly(a_hash_including(id: 1), a_hash_including(id: 2))
            )
          end

          it 'supports multiple nested matchers' do
            expect(response).to f_http_client_response_including(
              products: have_attributes(size: 2),
              page: be_a(Integer),
              total: be_positive
            )
          end
        end
      end
    end
  end
end
