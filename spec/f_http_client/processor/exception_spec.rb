# frozen_string_literal: true

RSpec.describe FHTTPClient::Processor::Exception do
  describe '#run' do
    subject(:exception_processor) { described_class.(error: error) }

    context 'when the connection has been refused' do
      let(:error) { Errno::ECONNREFUSED.new('Failed to open TCP connection') }

      it 'fails with connection refused error' do
        expect(exception_processor).to have_failed_with(:connection_refused, :exception).and_error(error)
      end
    end

    context 'when the connection gets a timeout' do
      let(:error) { Net::ReadTimeout.new('a timeout happened') }

      it 'fails with timeout error' do
        expect(exception_processor).to have_failed_with(:timeout, :exception).and_error(error)
      end
    end

    context 'when some unexpected thing happened' do
      let(:error) { Exception.new('An unknow error') }

      it 'fails with uncaught error' do
        expect(exception_processor).to have_failed_with(:uncaught_error, :exception).and_error(error)
      end
    end
  end
end
