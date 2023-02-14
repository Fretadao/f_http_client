# frozen_string_literal: true

RSpec.describe FHTTPClient::Logger::Rails do
  describe '#initialize' do
    context 'when there is no Rails' do
      it { expect { described_class.new }.to raise_error(NameError, /uninitialized constant Rails/) }
    end

    context 'when rails is defined' do
      let(:rails_class) { 'Rails' }

      before { stub_const('Rails', class_double(rails_class, logger: nil)) }

      it { expect(described_class.new).to be_an_instance_of(described_class) }
    end
  end

  describe '#tagged' do
    subject(:logger) { described_class.new }

    let(:rails_class) { 'Rails' }

    before { stub_const('Rails', class_double(rails_class, logger: nil)) }

    it { expect(logger).to respond_to(:tagged) }
  end

  describe '#debug' do
    subject(:logger) { described_class.new }

    let(:rails_class) { 'Rails' }

    before { stub_const('Rails', class_double(rails_class, logger: nil)) }

    it { expect(logger).to respond_to(:debug) }
  end

  describe '#info' do
    subject(:logger) { described_class.new }

    let(:rails_class) { 'Rails' }

    before { stub_const('Rails', class_double(rails_class, logger: nil)) }

    it { expect(logger).to respond_to(:info) }
  end

  describe '#warn' do
    subject(:logger) { described_class.new }

    let(:rails_class) { 'Rails' }

    before { stub_const('Rails', class_double(rails_class, logger: nil)) }

    it { expect(logger).to respond_to(:warn) }
  end

  describe '#error' do
    subject(:logger) { described_class.new }

    let(:rails_class) { 'Rails' }

    before { stub_const('Rails', class_double(rails_class, logger: nil)) }

    it { expect(logger).to respond_to(:error) }
  end

  describe '#fatal' do
    subject(:logger) { described_class.new }

    let(:rails_class) { 'Rails' }

    before { stub_const('Rails', class_double(rails_class, logger: nil)) }

    it { expect(logger).to respond_to(:fatal) }
  end

  describe '#unknown' do
    subject(:logger) { described_class.new }

    let(:rails_class) { 'Rails' }

    before { stub_const('Rails', class_double(rails_class, logger: nil)) }

    it { expect(logger).to respond_to(:unknown) }
  end
end
