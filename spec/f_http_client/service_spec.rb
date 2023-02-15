# frozen_string_literal: true

RSpec.describe FHTTPClient::Service do
  describe '.initialize' do
    subject(:service_class) do
      Class.new(described_class) do
        attributes :name, :age, email: 'guest@user.com'
      end
    end

    context 'when a required argument is missing' do
      it 'requires this argument' do
        expect { service_class.new(name: 'Bruno') }.to raise_error(ArgumentError, 'missing keyword: :age')
      end
    end

    context 'when all required attributes are informed' do
      context 'and an unknown attribute is informed' do
        it 'points this argument' do
          expect { service_class.new(name: 'Bruno', surname: 'Vicenzo', age: 25) }
            .to raise_error(ArgumentError, 'unknown keyword: :surname')
        end
      end

      context 'and all informed attributes are known' do
        context 'and an optional argument is missing' do
          it 'fills required attributes and optionals with default values', :aggregate_failures do
            service = service_class.new(name: 'Bruno', age: 25)

            expect(service.name).to eq('Bruno')
            expect(service.age).to eq(25)
            expect(service.email).to eq('guest@user.com')
          end
        end

        context 'and optional attribute is informed' do
          it 'fills required attributes and optionals with values', :aggregate_failures do
            service = service_class.new(name: 'Bruno', age: 25, email: 'bruno@user.com')

            expect(service.name).to eq('Bruno')
            expect(service.age).to eq(25)
            expect(service.email).to eq('bruno@user.com')
          end
        end
      end
    end
  end
end
