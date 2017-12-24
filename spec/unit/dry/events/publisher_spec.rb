require 'dry/events/publisher'

RSpec.describe Dry::Events::Publisher do
  subject(:publisher) do
    Class.new {
      include Dry::Events::Publisher[:test_publisher]

      register_event :test_event
    }.new
  end

  describe '.[]' do
    it 'creates a publisher extension with provided id' do
      publisher = Class.new do
        include Dry::Events::Publisher[:my_publisher]
      end

      expect(Dry::Events::Publisher.registry[:my_publisher]).to be(publisher)
    end

    it 'does not allow same id to be used for than once' do
      create_publisher = -> do
        Class.new do
          include Dry::Events::Publisher[:my_publisher]
        end
      end

      create_publisher.()

      expect { create_publisher.() }.to raise_error(Dry::Events::PublisherAlreadyRegisteredError, /my_publisher/)
    end
  end

  describe '.subscribe' do
    it 'subscribes a listener at class level' do
      listener = -> * { }

      publisher.class.subscribe(:test_event, &listener)

      expect(publisher.subscribed?(listener)).to be(true)
    end
  end

  describe '#subscribe' do
    it 'subscribes a listener' do
      listener = -> * { }

      publisher.subscribe(:test_event, &listener)

      expect(publisher.subscribed?(listener)).to be(true)
    end
  end

  describe '#publish' do
    it 'publishs an event' do
      result = []
      listener = -> event { result << event[:message] }

      publisher.subscribe(:test_event, &listener).publish(:test_event, message: 'it works')

      expect(result).to eql(['it works'])
    end

    it 'publishs an event filtered by a query' do
      result = []
      listener = -> test: { result << test }

      publisher.
        subscribe(:test_event, test: true, &listener).
        publish(:test_event, test: false).
        publish(:test_event, test: true)

      expect(result).to eql([true])
    end
  end

  describe '#process' do
    it 'yields event and its listeners' do
      result = []
      listener = -> event { result << event.id }

      publisher.subscribe(:test_event, &listener)

      publisher.process(:test_event) do |event, listener|
        listener.(event)
      end

      expect(result).to eql([:test_event])
    end
  end
end
