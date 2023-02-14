# frozen_string_literal: true

RSpec.describe FHTTPClient::Logger::Default do
  describe '#initialize' do
    context 'when no args are given' do
      it { expect(described_class.new).to be_an_instance_of(described_class) }
    end

    context 'when tags are given' do
      it { expect(described_class.new(tags: ['FHTTPClient'])).to be_an_instance_of(described_class) }
    end
  end

  describe '#tagged' do
    subject(:logger) { described_class.new }

    context 'when no args are given' do
      context 'and no block is given' do
        it { expect(logger.tagged).to be_an_instance_of(described_class) }
      end

      context 'and block is given' do
        it { expect { |block| logger.tagged(&block) }.to yield_with_args(an_instance_of(described_class)) }
      end
    end

    context 'and args are given' do
      context 'and no block is given' do
        it { expect(logger.tagged('FHTTPClient')).to be_an_instance_of(described_class) }
      end

      context 'and block is given' do
        it do
          expect { |block| logger.tagged('FHTTPClient', &block) }.to yield_with_args(an_instance_of(described_class))
        end
      end
    end
  end

  describe '#debug' do
    subject(:logger) { described_class.new }

    let(:logging) { instance_double(Logger) }

    before do
      allow(Logger).to receive(:new).and_return(logging)
      allow(logging).to receive(:add)
    end

    context 'when no tags are given' do
      it 'logs without tags' do
        logger.debug('Something happened.')
        expect(logging).to have_received(:add).with(Logger::DEBUG, 'Something happened.')
      end
    end

    context 'when tags are given' do
      context 'and tag are set before logging' do
        it 'logs with tags' do
          tagged_log = logger.tagged('Inspect', 'Error')
          tagged_log.debug('Something happened.')

          expect(logging)
            .to have_received(:add)
            .with(Logger::DEBUG, '[Inspect] [Error] - Something happened.')
        end
      end

      context 'and tag are given in a block' do
        it 'logs with tags' do
          logger.tagged('Inspect', 'Error') { |tagged_log| tagged_log.debug('Something happened.') }

          expect(logging)
            .to have_received(:add)
            .with(Logger::DEBUG, '[Inspect] [Error] - Something happened.')
        end
      end
    end
  end

  describe '#info' do
    subject(:logger) { described_class.new }

    let(:logging) { instance_double(Logger) }

    before do
      allow(Logger).to receive(:new).and_return(logging)
      allow(logging).to receive(:add)
    end

    context 'when no tags are given' do
      it 'logs without tags' do
        logger.info('Something happened.')
        expect(logging).to have_received(:add).with(Logger::INFO, 'Something happened.')
      end
    end

    context 'when tags are given' do
      context 'and tag are set before logging' do
        it 'logs with tags' do
          tagged_log = logger.tagged('Inspect', 'Error')
          tagged_log.info('Something happened.')

          expect(logging)
            .to have_received(:add)
            .with(Logger::INFO, '[Inspect] [Error] - Something happened.')
        end
      end

      context 'and tag are given in a block' do
        it 'logs with tags' do
          logger.tagged('Inspect', 'Error') { |tagged_log| tagged_log.info('Something happened.') }

          expect(logging)
            .to have_received(:add)
            .with(Logger::INFO, '[Inspect] [Error] - Something happened.')
        end
      end
    end
  end

  describe '#warn' do
    subject(:logger) { described_class.new }

    let(:logging) { instance_double(Logger) }

    before do
      allow(Logger).to receive(:new).and_return(logging)
      allow(logging).to receive(:add)
    end

    context 'when no tags are given' do
      it 'logs without tags' do
        logger.warn('Something happened.')
        expect(logging).to have_received(:add).with(Logger::WARN, 'Something happened.')
      end
    end

    context 'when tags are given' do
      context 'and tag are set before logging' do
        it 'logs with tags' do
          tagged_log = logger.tagged('Inspect', 'Error')
          tagged_log.warn('Something happened.')

          expect(logging)
            .to have_received(:add)
            .with(Logger::WARN, '[Inspect] [Error] - Something happened.')
        end
      end

      context 'and tag are given in a block' do
        it 'logs with tags' do
          logger.tagged('Inspect', 'Error') { |tagged_log| tagged_log.warn('Something happened.') }

          expect(logging)
            .to have_received(:add)
            .with(Logger::WARN, '[Inspect] [Error] - Something happened.')
        end
      end
    end
  end

  describe '#error' do
    subject(:logger) { described_class.new }

    let(:logging) { instance_double(Logger) }

    before do
      allow(Logger).to receive(:new).and_return(logging)
      allow(logging).to receive(:add)
    end

    context 'when no tags are given' do
      it 'logs without tags' do
        logger.error('Something happened.')
        expect(logging).to have_received(:add).with(Logger::ERROR, 'Something happened.')
      end
    end

    context 'when tags are given' do
      context 'and tag are set before logging' do
        it 'logs with tags' do
          tagged_log = logger.tagged('Inspect', 'Error')
          tagged_log.error('Something happened.')

          expect(logging)
            .to have_received(:add)
            .with(Logger::ERROR, '[Inspect] [Error] - Something happened.')
        end
      end

      context 'and tag are given in a block' do
        it 'logs with tags' do
          logger.tagged('Inspect', 'Error') { |tagged_log| tagged_log.error('Something happened.') }

          expect(logging)
            .to have_received(:add)
            .with(Logger::ERROR, '[Inspect] [Error] - Something happened.')
        end
      end
    end
  end

  describe '#fatal' do
    subject(:logger) { described_class.new }

    let(:logging) { instance_double(Logger) }

    before do
      allow(Logger).to receive(:new).and_return(logging)
      allow(logging).to receive(:add)
    end

    context 'when no tags are given' do
      it 'logs without tags' do
        logger.fatal('Something happened.')
        expect(logging).to have_received(:add).with(Logger::FATAL, 'Something happened.')
      end
    end

    context 'when tags are given' do
      context 'and tag are set before logging' do
        it 'logs with tags' do
          tagged_log = logger.tagged('Inspect', 'fatal')
          tagged_log.fatal('Something happened.')

          expect(logging)
            .to have_received(:add)
            .with(Logger::FATAL, '[Inspect] [fatal] - Something happened.')
        end
      end

      context 'and tag are given in a block' do
        it 'logs with tags' do
          logger.tagged('Inspect', 'fatal') { |tagged_log| tagged_log.fatal('Something happened.') }

          expect(logging)
            .to have_received(:add)
            .with(Logger::FATAL, '[Inspect] [fatal] - Something happened.')
        end
      end
    end
  end

  describe '#unknown' do
    subject(:logger) { described_class.new }

    let(:logging) { instance_double(Logger) }

    before do
      allow(Logger).to receive(:new).and_return(logging)
      allow(logging).to receive(:add)
    end

    context 'when no tags are given' do
      it 'logs without tags' do
        logger.unknown('Something happened.')
        expect(logging).to have_received(:add).with(Logger::UNKNOWN, 'Something happened.')
      end
    end

    context 'when tags are given' do
      context 'and tag are set before logging' do
        it 'logs with tags' do
          tagged_log = logger.tagged('Inspect', 'unknown')
          tagged_log.unknown('Something happened.')

          expect(logging)
            .to have_received(:add)
            .with(Logger::UNKNOWN, '[Inspect] [unknown] - Something happened.')
        end
      end

      context 'and tag are given in a block' do
        it 'logs with tags' do
          logger.tagged('Inspect', 'unknown') { |tagged_log| tagged_log.unknown('Something happened.') }

          expect(logging)
            .to have_received(:add)
            .with(Logger::UNKNOWN, '[Inspect] [unknown] - Something happened.')
        end
      end
    end
  end
end
