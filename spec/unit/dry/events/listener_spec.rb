require 'dry/events/listener'

RSpec.describe Dry::Events::Listener do
  subject(:listener) do
    Class.new {
      include Dry::Events::Listener[:test_publisher]
    }
  end

  let!(:publisher) do
    Class.new {
      include Dry::Events::Publisher[:test_publisher]

      register_event :test_event
    }.new
  end


  describe '.subscribe' do
    let(:captured) { [] }

    it 'subscribes a listener at class level' do
      listener.subscribe(:test_event) do |event|
        captured << event.id
      end

      publisher.publish(:test_event)

      expect(captured).to eql([:test_event])
    end

    describe 'filters' do
      it 'filters events' do
        listener.subscribe(:test_event, level: :info) do |event|
          captured << event.payload
        end

        publisher.publish(:test_event)
        publisher.publish(:test_event, level: :debug)
        publisher.publish(:test_event, level: :info)

        expect(captured).to eql([level: :info])
      end

      it 'filters events using nested query' do
        listener = self.listener

        listener.subscribe(:test_event, logger: { level: :info }) do |event|
          captured << event.payload
        end

        publisher.publish(:test_event)
        publisher.publish(:test_event, logger: { level: :info, output: :stdin })
        publisher.publish(:test_event, logger: { level: :debug })
        publisher.publish(:test_event, logger: :debug)

        expect(captured).to eql([logger: { level: :info, output: :stdin }])
      end

      it 'filters events by inclusion' do
        listener = self.listener

        listener.subscribe(:test_event, logger: { level: %i(info warn error fatal) }) do |event|
          captured << event.payload
        end

        publisher.publish(:test_event)
        publisher.publish(:test_event, logger: { level: :info, output: :stdin })
        publisher.publish(:test_event, logger: { level: :fatal })
        publisher.publish(:test_event, logger: { level: :debug })
        publisher.publish(:test_event, logger: :debug)

        expect(captured).to eql([
          { logger: { level: :info, output: :stdin } },
          { logger: { level: :fatal } }
        ])
      end
    end
  end
end
