# frozen_string_literal: true

RSpec.describe FHTTPClient::Logger::Null do
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
        it { expect(logger.tagged('FHTTPCLient')).to be_an_instance_of(described_class) }
      end

      context 'and block is given' do
        it do
          expect { |block| logger.tagged('FHTTPCLient', &block) }.to yield_with_args(an_instance_of(described_class))
        end
      end
    end
  end

  describe '#debug' do
    subject(:logger) { described_class.new }

    it { expect(logger).to respond_to(:debug) }
  end

  describe '#info' do
    subject(:logger) { described_class.new }

    it { expect(logger).to respond_to(:info) }
  end

  describe '#warn' do
    subject(:logger) { described_class.new }

    it { expect(logger).to respond_to(:warn) }
  end

  describe '#error' do
    subject(:logger) { described_class.new }

    it { expect(logger).to respond_to(:error) }
  end

  describe '#fatal' do
    subject(:logger) { described_class.new }

    it { expect(logger).to respond_to(:fatal) }
  end

  describe '#unknown' do
    subject(:logger) { described_class.new }

    it { expect(logger).to respond_to(:unknown) }
  end
end
