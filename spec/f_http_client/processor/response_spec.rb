# frozen_string_literal: true

RSpec.describe FHTTPClient::Processor::Response do
  describe '#run' do
    subject(:response_processor) { described_class.(response: response) }

    let(:response) do
      HTTParty.get(
        '/test',
        base_uri: 'localhost:3000',
        query: { id: 1 },
        headers: { content_type: 'application/json' }
      )
    end

    before do
      stub_get({ query: { id: 1 } }, to: 'http://localhost:3000/test', response_status: code, response_body: body)
    end

    context 'when the http response is an informational response' do
      let(:code) { 100 }
      let(:body) { {} }

      it 'returns a Fservice failure' do
        expect(response_processor)
          .to have_failed_with(:continue, :informational)
          .and_error({ headers: { 'content-type' => ['application/json'] }, body: {} })
      end
    end

    context 'when the http response get success' do
      let(:code) { 201 }
      let(:body) { { user: { name: 'Joe Silva', email: 'email@teste.com' } } }

      it 'returns a Fservice success' do
        expect(response_processor)
          .to have_succeed_with(:created, :successful)
          .and_value(
            {
              headers: { 'content-type' => ['application/json'] },
              body: { 'user' => { 'name' => 'Joe Silva', 'email' => 'email@teste.com' } }
            }
          )
      end
    end

    context 'when the http response is an client error' do
      let(:code) { 404 }
      let(:body) { { errors: { user: 'not found' } } }

      it 'returns a Fservice failure' do
        expect(response_processor)
          .to have_failed_with(:not_found, :client_error)
          .and_error(
            {
              headers: { 'content-type' => ['application/json'] },
              body: { 'errors' => { 'user' => 'not found' } }
            }
          )
      end
    end

    context 'when the http response is an server error' do
      let(:code) { 502 }
      let(:body) { {} }

      it 'returns a Fservice failure' do
        expect(response_processor)
          .to have_failed_with(:bad_gateway, :server_error)
          .and_error({ headers: { 'content-type' => ['application/json'] }, body: {} })
      end
    end

    context 'when the http response is unknown' do
      let(:code) { 99 }
      let(:body) { {} }

      it 'returns a Fservice failure' do
        expect(response_processor)
          .to have_failed_with(:unknown_type, :unknown_family)
          .and_error({ headers: { 'content-type' => ['application/json'] }, body: {} })
      end
    end
  end
end
