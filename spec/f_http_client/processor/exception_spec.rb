# frozen_string_literal: true

RSpec.describe FHTTPClient::Processor::Exception do
  describe '#run' do
    describe 'define log strategy' do
      let(:error) { Errno::ECONNREFUSED.new('Failed to open TCP connection') }

      before do
        allow(FHTTPClient::Log).to receive(:call).and_call_original
        error.set_backtrace(caller)
      end

      context 'when no log strategy is informed' do
        subject(:exception_processor) { described_class.(error: error) }

        it 'logs the request using null strategy' do
          exception_processor
          expect(FHTTPClient::Log).to have_received(:call)
            .with(
              a_hash_including(
                tags: 'EXTERNAL REQUEST',
                message: an_instance_of(String),
                level: :error,
                strategy: :null
              )
            )
        end
      end

      context 'when some log strategy is informed' do
        subject(:exception_processor) { described_class.(error: error, log_strategy: :default) }

        let(:ruby_logger) { instance_spy(Logger, :ruby_logger) }

        before { allow(Logger).to receive(:new).and_return(ruby_logger) }

        it 'logs the request using informed strategy' do
          exception_processor
          expect(FHTTPClient::Log).to have_received(:call)
            .with(
              a_hash_including(
                tags: 'EXTERNAL REQUEST',
                message: an_instance_of(String),
                level: :error,
                strategy: :default
              )
            )
        end
      end
    end

    describe 'result process' do
      subject(:exception_processor) { described_class.(error: error) }

      before do
        allow(FHTTPClient::Log).to receive(:call).and_call_original
        error.set_backtrace(caller)
      end

      context 'when the connection has been refused' do
        let(:error) { Errno::ECONNREFUSED.new('Failed to open TCP connection') }

        it 'logs the request' do
          exception_processor
          expect(FHTTPClient::Log).to have_received(:call)
        end

        it 'fails with connection refused error' do
          expect(exception_processor).to have_failed_with(:connection_refused, :exception).and_error(error)
        end
      end

      context 'when the connection could not happen' do
        let(:error) { SocketError.new('Failed to open TCP connection to...') }

        it 'logs the request' do
          exception_processor
          expect(FHTTPClient::Log).to have_received(:call)
        end

        it 'fails with connection refused error' do
          expect(exception_processor).to have_failed_with(:connection_error, :exception).and_error(error)
        end
      end

      context 'when the connection gets a timeout' do
        let(:error) { Net::ReadTimeout.new('a timeout happened') }

        it 'logs the request' do
          exception_processor
          expect(FHTTPClient::Log).to have_received(:call)
        end

        it 'fails with timeout error' do
          expect(exception_processor).to have_failed_with(:timeout, :exception).and_error(error)
        end
      end

      context 'when some unexpected thing happened' do
        let(:error) { Exception.new('An unknow error') }

        it 'logs the request' do
          exception_processor
          expect(FHTTPClient::Log).to have_received(:call)
        end

        it 'fails with uncaught error' do
          expect(exception_processor).to have_failed_with(:uncaught_error, :exception).and_error(error)
        end
      end
    end
  end
end
