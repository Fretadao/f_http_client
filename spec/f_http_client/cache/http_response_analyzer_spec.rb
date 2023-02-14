# frozen_string_literal: true

RSpec.describe FHttpClient::Cache::HttpResponseAnalyzer do
  describe '.not_cacheable_responses' do
    subject(:http_response_analyzer) { described_class }

    it 'returns the list of errors to analize' do
      expect(http_response_analyzer.not_cacheable_responses).to contain_exactly(
        :server_error?,
        :gateway_timeout?,
        :request_timeout?,
        :unauthorized?,
        :too_many_requests?
      )
    end
  end

  describe '.not_cacheable?' do
    subject(:http_response_analyzer) { described_class }

    let(:response) { instance_spy(HTTParty::Response, errors) }

    context 'when the response is a server error' do
      let(:errors) { { server_error?: true } }

      it 'is not cacheable' do
        expect(http_response_analyzer).to be_not_cacheable(response)
      end
    end

    context 'when the response out of not cacheable responses list' do
      let(:errors) do
        {
          server_error?: false,
          gateway_timeout?: false,
          request_timeout?: false,
          unauthorized?: false,
          too_many_requests?: false
        }
      end

      it 'is cacheable' do
        expect(http_response_analyzer).not_to be_not_cacheable(response)
      end
    end
  end
end
