# frozen_string_literal: true

RSpec.describe FHTTPClient::Processor::Response do
  describe '#run' do
    describe 'define log strategy' do
      let(:response) do
        HTTParty.get(
          '/test',
          base_uri: 'localhost:3000',
          query: { id: 1 },
          headers: { content_type: 'application/json' },
          parser: FHTTPClient::Parser::Response
        )
      end

      before do
        stub_get({ query: { id: 1 } }, to: 'http://localhost:3000/test', response_status: 200, response_body: {})
        allow(FHTTPClient::Log).to receive(:call).and_call_original
      end

      context 'when no log strategy is informed' do
        subject(:response_processor) { described_class.(response: response) }

        it 'logs the request using null strategy' do
          response_processor
          expect(FHTTPClient::Log).to have_received(:call)
            .with(
              a_hash_including(
                tags: 'EXTERNAL REQUEST',
                message: an_instance_of(String),
                strategy: :null
              )
            )
        end
      end

      context 'when some log strategy is informed' do
        subject(:response_processor) { described_class.(response: response, log_strategy: :default) }

        let(:ruby_logger) { instance_spy(Logger, :ruby_logger) }

        before { allow(Logger).to receive(:new).and_return(ruby_logger) }

        it 'logs the request using informed strategy' do
          response_processor
          expect(FHTTPClient::Log).to have_received(:call)
            .with(
              a_hash_including(
                tags: 'EXTERNAL REQUEST',
                message: an_instance_of(String),
                strategy: :default
              )
            )
        end
      end
    end

    describe 'result process' do
      subject(:response_processor) { described_class.(response: response) }

      let(:response) do
        HTTParty.get(
          '/test',
          base_uri: 'localhost:3000',
          query: { id: 1 },
          headers: { content_type: 'application/json' },
          parser: FHTTPClient::Parser::Response
        )
      end

      before do
        stub_get({ query: { id: 1 } }, to: 'http://localhost:3000/test', response_status: code, response_body: body)
        allow(FHTTPClient::Log).to receive(:call).and_call_original
      end

      context 'when the http response is an informational response' do
        let(:code) { 100 }
        let(:body) { {} }

        it 'logs the request' do
          response_processor
          expect(FHTTPClient::Log).to have_received(:call)
        end

        it 'returns a Fservice failure' do
          expect(response_processor)
            .to have_failed_with(:continue, :informational)
            .and_error(be_an_instance_of(HTTParty::Response))
        end
      end

      context 'when the http response get success' do
        let(:code) { 201 }
        let(:body) { { user: { name: 'Joe Silva', email: 'email@teste.com' } } }

        it 'logs the request' do
          response_processor
          expect(FHTTPClient::Log).to have_received(:call)
        end

        it 'returns a Fservice success' do
          expect(response_processor)
            .to have_succeed_with(:created, :successful)
            .and_value(be_an_instance_of(HTTParty::Response))
        end
      end

      context 'when the http response is an client error' do
        let(:code) { 404 }
        let(:body) { { errors: { user: 'not found' } } }

        it 'logs the request' do
          response_processor
          expect(FHTTPClient::Log).to have_received(:call)
        end

        it 'returns a Fservice failure' do
          expect(response_processor)
            .to have_failed_with(:not_found, :client_error)
            .and_error(be_an_instance_of(HTTParty::Response))
        end
      end

      context 'when the http response is an server error' do
        let(:code) { 502 }
        let(:body) { {} }

        it 'logs the request' do
          response_processor
          expect(FHTTPClient::Log).to have_received(:call)
        end

        it 'returns a Fservice failure' do
          expect(response_processor)
            .to have_failed_with(:bad_gateway, :server_error)
            .and_error(be_an_instance_of(HTTParty::Response))
        end
      end

      context 'when the http response is an unprocessable content' do
        let(:code) { 422 }
        let(:body) { { errors: { name: ["can't be blank"] } } }

        it 'returns a Fservice failure carrying both the canonical and the legacy type' do
          expect(response_processor)
            .to have_failed_with(:unprocessable_content, :unprocessable_entity, :client_error)
            .and_error(be_an_instance_of(HTTParty::Response))
        end

        it 'matches on_failure by the canonical type' do
          expect { |handler| response_processor.on_failure(:unprocessable_content, &handler) }
            .to yield_control
        end

        it 'matches on_failure by the legacy type' do
          expect { |handler| response_processor.on_failure(:unprocessable_entity, &handler) }
            .to yield_control
        end

        it 'yields the canonical type to an untyped on_failure' do
          expect { |handler| response_processor.on_failure(&handler) }
            .to yield_with_args(an_instance_of(HTTParty::Response), :unprocessable_content)
        end
      end

      context 'when the http response is a content too large' do
        let(:code) { 413 }
        let(:body) { { errors: { file: ['is too big'] } } }

        it 'returns a Fservice failure carrying both the canonical and the legacy type' do
          expect(response_processor)
            .to have_failed_with(:content_too_large, :payload_too_large, :client_error)
            .and_error(be_an_instance_of(HTTParty::Response))
        end

        it 'matches on_failure by the canonical type' do
          expect { |handler| response_processor.on_failure(:content_too_large, &handler) }
            .to yield_control
        end

        it 'matches on_failure by the legacy type' do
          expect { |handler| response_processor.on_failure(:payload_too_large, &handler) }
            .to yield_control
        end
      end

      context 'when the http response is unknown' do
        let(:code) { 99 }
        let(:body) { {} }

        it 'logs the request' do
          response_processor
          expect(FHTTPClient::Log).to have_received(:call)
        end

        it 'returns a Fservice failure' do
          expect(response_processor)
            .to have_failed_with(:unknown_type, :unknown_family)
            .and_error(be_an_instance_of(HTTParty::Response))
        end
      end
    end
  end
end
