# frozen_string_literal: true

RSpec.describe FHTTPClient::Base do
  describe 'not implemented methods' do
    describe '#path_template' do
      subject(:client) do
        Class.new(described_class) do
          base_uri 'localhost:3000'

          def make_request
            self.class.get(formatted_path)
          end
        end
      end

      it { expect { client.() }.to raise_error NotImplementedError, 'Clients must implement #path_template' }
    end

    describe '#make_request' do
      subject(:client) do
        Class.new(described_class) do
          base_uri 'localhost:3000'

          def self.config
            FHTTPClient::Configuration.config
          end

          def path_template
            '/users/'
          end
        end
      end

      it { expect { client.() }.to raise_error NotImplementedError, 'Clients must implement #make_request' }
    end
  end

  describe '.parser' do
    it { expect(described_class.parser).to eq(FHTTPClient::Parser::Response) }
  end

  describe '.base_uri' do
    context 'when client provides a base_uri' do
      subject(:client) do
        Class.new(described_class) do
          base_uri 'https://blog.com'
        end
      end

      it 'uses client base_uri' do
        expect(client.base_uri).to eq('https://blog.com')
      end
    end
  end

  describe '.cache_strategy' do
    context 'when a nil cache_strategy is informed' do
      subject(:client) do
        Class.new(described_class) do
          cache_strategy nil

          def self.config
            FHTTPClient::Configuration.config
          end
        end
      end

      it 'keeps the default cache_strategy' do
        expect(client.cache_strategy).to eq(:null)
      end
    end

    context 'when a blank cache_strategy is informed' do
      subject(:client) do
        Class.new(described_class) do
          cache_strategy ''
        end
      end

      it 'changes to an empty value' do
        expect(client.cache_strategy).to eq('')
      end
    end

    context 'when a cache_strategy is informed' do
      subject(:client) do
        Class.new(described_class) do
          cache_strategy :rails
        end
      end

      it 'changes to the new value' do
        expect(client.cache_strategy).to eq(:rails)
      end
    end
  end

  describe '.cache_expires_in' do
    context 'when a nil cache_expires_in is informed' do
      subject(:client) do
        Class.new(described_class) do
          cache_expires_in nil
        end
      end

      it 'keeps the default cache_expires_in' do
        expect(client.cache_expires_in).to be_zero
      end
    end

    context 'when a blank cache_expires_in is informed' do
      subject(:client) do
        Class.new(described_class) do
          cache_expires_in ''
        end
      end

      it 'changes to an empty value' do
        expect(client.cache_expires_in).to eq('')
      end
    end

    context 'when a cache_expires_in is informed' do
      subject(:client) do
        Class.new(described_class) do
          cache_expires_in 3_600
        end
      end

      it 'changes to the new value' do
        expect(client.cache_expires_in).to eq(3_600)
      end
    end
  end

  describe '#run' do
    context 'when base_uri is not provided' do
      subject(:find_post) do
        Class.new(described_class) do
          private

          def make_request
            self.class.get(formatted_path, headers: headers)
          end

          def path_template
            '/posts/%<id>s'
          end

          def headers
            {
              content_type: 'application/json'
            }.merge(@headers)
          end
        end
      end

      it { expect(find_post.()).to have_failed_with(:no_base_uri_configured) }
    end

    context 'when base_uri is provided from the configuration class' do
      subject(:find_post) do
        Class.new(described_class) do
          private

          def make_request
            self.class.get(formatted_path, headers: headers)
          end

          def path_template
            '/posts/%<id>s'
          end

          def headers
            {
              content_type: 'application/json'
            }.merge(@headers)
          end
        end
      end

      before do
        FHTTPClient::Configuration.configure do |config|
          config.base_uri = 'https://api.myblog.com'
        end
      end

      context 'but path_params is not informed' do
        it { expect { find_post.() }.to raise_error(KeyError, 'key<id> not found') }
      end

      context 'and path_params is informed' do
        let(:post_id) { 25 }

        context 'but an unknow error happens' do
          before do
            stub_get_error(to: "https://api.myblog.com/posts/#{post_id}", error: RuntimeError, message: 'strange error')
          end

          it { expect { find_post.(path_params: { id: post_id }) }.to raise_error(RuntimeError, 'strange error') }
        end

        context 'but a connection exception happens' do
          before { stub_get_timeout(to: "https://api.myblog.com/posts/#{post_id}") }

          it 'fails with info about exception', :aggregate_failures do
            result = find_post.(path_params: { id: post_id })
            expect(result).to have_failed_with(:timeout, :exception)
            expect(result.error).to be_an_instance_of(Net::OpenTimeout)
          end
        end

        context 'and request receives a response' do
          before do
            stub_get(
              to: "https://api.myblog.com/posts/#{post_id}",
              response_status: response_status,
              response_body: response_body
            )
          end

          context 'but response is an HTTP error' do
            let(:response_status) { 404 }
            let(:response_body) { {} }

            it 'fails with not found', :aggregate_failures do
              processed_response = find_post.(path_params: { id: post_id })
              expect(processed_response).to have_failed_with(:not_found, :client_error)
              expect(processed_response.error).to be_an_instance_of(HTTParty::Response)
            end
          end
        end
      end
    end

    context 'when base_uri is provided in current service class' do
      subject(:find_post) do
        Class.new(described_class) do
          base_uri 'https://api.myblog.com'

          private

          def make_request
            self.class.get(formatted_path, headers: headers)
          end

          def path_template
            '/posts/%<id>s'
          end

          def headers
            {
              content_type: 'application/json'
            }.merge(@headers)
          end
        end
      end

      context 'but path_params is not informed' do
        it { expect { find_post.() }.to raise_error(KeyError, 'key<id> not found') }
      end

      context 'and path_params is informed' do
        let(:post_id) { 25 }

        context 'but an unknow error happens' do
          before do
            stub_get_error(to: "https://api.myblog.com/posts/#{post_id}", error: RuntimeError, message: 'strange error')
          end

          it { expect { find_post.(path_params: { id: post_id }) }.to raise_error(RuntimeError, 'strange error') }
        end

        context 'but a connection exception happens' do
          before { stub_get_timeout(to: "https://api.myblog.com/posts/#{post_id}") }

          it 'fails with info about exception', :aggregate_failures do
            result = find_post.(path_params: { id: post_id })
            expect(result).to have_failed_with(:timeout, :exception)
            expect(result.error).to be_an_instance_of(Net::OpenTimeout)
          end
        end

        context 'and request receives a response' do
          before do
            stub_get(
              to: "https://api.myblog.com/posts/#{post_id}",
              response_status: response_status,
              response_body: response_body
            )
          end

          context 'but response is an HTTP error' do
            let(:response_status) { 404 }
            let(:response_body) { {} }

            it 'fails with not found', :aggregate_failures do
              processed_response = find_post.(path_params: { id: post_id })
              expect(processed_response).to have_failed_with(:not_found, :client_error)
              expect(processed_response.error).to be_an_instance_of(HTTParty::Response)
            end
          end
        end
      end
    end
  end
end
