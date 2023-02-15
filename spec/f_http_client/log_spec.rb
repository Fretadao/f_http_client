# frozen_string_literal: true

RSpec.describe FHTTPClient::Log do
  describe '.run' do
    let(:logger) { instance_spy(FHTTPClient::Logger::Null, :logger) }

    before { allow(FHTTPClient).to receive(:logger).and_return(logger) }

    context 'when only message is sent' do
      let(:message) { 'Hello log' }

      it 'logs an info level without tags', :aggregate_failures do
        expect(described_class.(message: message)).to have_succeed_with(:logged)

        expect(logger).to have_received(:tagged).with(no_args)
        expect(logger).to have_received(:info).with(message)
      end
    end

    context 'when tags are sent' do
      let(:message) { 'Hello log' }
      let(:tags) { ['Hello', 'Log'] }

      it 'logs an info level without tags', :aggregate_failures do
        expect(described_class.(message: message, tags: tags)).to have_succeed_with(:logged)

        expect(logger).to have_received(:tagged).with(*tags)
        expect(logger).to have_received(:info).with(message)
      end
    end

    context 'when level is sent' do
      let(:message) { 'Hello log' }

      context 'and it is not a valid level' do
        let(:level) { :warning }

        it 'raises undefined method error' do
          expect { described_class.(message: message, level: level) }
            .to raise_error('the FHTTPClient::Logger::Null class does not implement the instance method: warning')
        end
      end

      context 'and it is a valid level' do
        let(:level) { :error }

        it 'logs an error level without tags', :aggregate_failures do
          expect(described_class.(message: message, level: level)).to have_succeed_with(:logged)

          expect(logger).to have_received(:tagged).with(no_args)
          expect(logger).to have_received(level).with(message)
        end
      end
    end
  end
end
