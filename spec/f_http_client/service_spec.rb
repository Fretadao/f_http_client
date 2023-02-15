# frozen_string_literal: true

RSpec.describe FHTTPClient::Service do
  describe '.initialize' do
    subject(:service_class) do
      Class.new(described_class) do
        option :name
        option :age
        option :email, default: -> { 'guest@user.com' }
      end
    end

    context 'when a required argument is missing' do
      it 'requires this argument' do
        expect { service_class.new(name: 'Bruno') }
          .to raise_error(KeyError, a_string_ending_with("option 'age' is required"))
      end
    end

    context 'when all required attributes are informed' do
      context 'and an unknown attribute is informed' do
        it 'ignores this unknown attribute', :aggregate_failures do # See: https://dry-rb.org/gems/dry-initializer/3.0/tolerance-to-unknown-arguments/
          service = service_class.new(name: 'Bruno', surname: 'Vicenzo', age: 25)

          expect(service.name).to eq('Bruno')
          expect(service.age).to eq(25)
          expect(service).not_to respond_to(:surname)
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
