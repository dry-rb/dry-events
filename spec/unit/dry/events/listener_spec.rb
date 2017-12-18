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
    it 'subscribes a listener at class level' do
      result = []

      listener.subscribe(:test_event) do |event|
        result << event.id
      end

      publisher.publish(:test_event)

      expect(result).to eql([:test_event])
    end
  end
end
