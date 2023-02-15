# frozen_string_literal: true

RSpec.describe FHTTPClient::Parser::Response do
  describe 'inheritance' do
    it { expect(described_class.ancestors).to include(HTTParty::Parser) }
  end

  describe '.call' do
    context 'when format is JSON' do
      let(:body) { '{"name":"Bruno","age":25,"birth_date":"1997-05-30"}' }
      let(:format) { :json }

      it 'parses the json using symbolized keys' do
        expect(described_class.(body, format)).to eq(
          {
            name: 'Bruno',
            age: 25,
            birth_date: '1997-05-30'
          }
        )
      end
    end
  end
end
