# frozen_string_literal: true

RSpec.describe FHTTPClient::Log do
  describe '#run' do
    context 'when only message is sent' do
      let(:logger) { instance_spy(FHTTPClient::Logger::Null, :logger) }
      let(:message) { 'Hello log' }

      before { allow(FHTTPClient::Logger::Null).to receive(:new).and_return(logger) }

      it 'logs an info level without tags', :aggregate_failures do
        logger
        expect(described_class.(message: message)).to have_succeed_with(:logged)

        expect(logger).to have_received(:tagged).with(no_args)
        expect(logger).to have_received(:info).with(message)
      end
    end

    context 'when tags are sent' do
      let(:message) { 'Hello log' }
      let(:tags) { ['Hello', 'Log'] }
      let(:logger) { instance_spy(FHTTPClient::Logger::Null, :logger) }

      before { allow(FHTTPClient::Logger::Null).to receive(:new).and_return(logger) }

      it 'logs an info level without tags', :aggregate_failures do
        expect(described_class.(message: message, tags: tags)).to have_succeed_with(:logged)

        expect(logger).to have_received(:tagged).with(*tags)
        expect(logger).to have_received(:info).with(message)
      end
    end

    context 'when level is sent' do
      let(:message) { 'Hello log' }
      let(:logger) { instance_spy(FHTTPClient::Logger::Null, :logger) }

      before { allow(FHTTPClient::Logger::Null).to receive(:new).and_return(logger) }

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

    context 'when strategy is sent' do
      let(:message) { 'Hello log' }

      context 'and strategy is unknown' do
        let(:logger) { instance_spy(FHTTPClient::Logger::Null, :logger) }
        let(:strategy) { :sinatra }

        before { allow(FHTTPClient::Logger::Null).to receive(:new).and_return(logger) }

        it 'uses the null logger', :aggregate_failures do
          logger
          expect(described_class.(message: message, strategy: strategy)).to have_succeed_with(:logged)

          expect(logger).to have_received(:tagged).with(no_args)
          expect(logger).to have_received(:info).with(message)
        end
      end

      context 'and strategy is default' do
        let(:logger) { instance_spy(FHTTPClient::Logger::Default, :logger) }
        let(:strategy) { :default }

        before { allow(FHTTPClient::Logger::Default).to receive(:new).and_return(logger) }

        it 'uses the default logger', :aggregate_failures do
          logger
          expect(described_class.(message: message, strategy: strategy)).to have_succeed_with(:logged)

          expect(logger).to have_received(:tagged).with(no_args)
          expect(logger).to have_received(:info).with(message)
        end
      end

      context 'and strategy is rails' do
        let(:logger) { instance_spy(FHTTPClient::Logger::Rails, :logger) }
        let(:strategy) { :rails }

        before { allow(FHTTPClient::Logger::Rails).to receive(:new).and_return(logger) }

        it 'uses the Rails logger', :aggregate_failures do
          logger
          expect(described_class.(message: message, strategy: strategy)).to have_succeed_with(:logged)

          expect(logger).to have_received(:tagged).with(no_args)
          expect(logger).to have_received(:info).with(message)
        end
      end
    end
  end
end
