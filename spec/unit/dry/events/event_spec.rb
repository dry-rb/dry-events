require 'dry/events/event'

RSpec.describe Dry::Events::Event do
  subject(:event) do
    described_class.new(event_id, payload)
  end

  let(:payload) { {} }

  describe 'invalid event name' do
    let(:event_id) { nil }
    it 'raises InvalidEventNameError' do
      expect{ event }.to raise_error(Dry::Events::Event::InvalidEventNameError)
    end
  end

  describe '#[]' do
    let(:event_id) { :test }
    let(:payload) { {test: :foo} }

    it 'fetches payload key' do
      expect(event[:test]).to eq :foo
    end

    it 'raises KeyError when no key found' do
      expect { event[:fake] }.to raise_error(KeyError)
    end
  end

  describe '#payload' do
    let(:event_id) { :test }
    let(:payload) { {test: :foo} }

    it 'returns payload if no argument' do
      expect(event.payload).to eq payload
    end

    it 'returns new event with payload payload' do
      new_event = event.payload({ bar: :baz })
      expect(new_event).to_not eq event
      expect(new_event.payload).to eq ({test: :foo, bar: :baz})
    end
  end

  describe '#to_h' do
    let(:event_id) { :test }
    let(:payload) { {test: :foo} }

    it 'returns payload' do
      expect(event.to_h).to eq payload
    end
  end

  describe '#listener_method' do
    let(:event_id) { :test }

    it 'returns listener method name' do
      expect(event.listener_method).to eq :on_test
    end

    it 'replaces dots for underscores' do
      ev = Dry::Events::Event.new('hello.world')
      expect(ev.listener_method).to eq :on_hello_world
    end
  end
end
