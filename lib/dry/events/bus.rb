require 'dry/events/constants'

module Dry
  module Events
    # Event bus
    #
    # An event bus stores listeners (callbacks) and events
    #
    # @api private
    class Bus
      # @!attribute [r] events
      #   @return [Hash] A hash with events registered within a bus
      attr_reader :events

      # @!attribute [r] listeners
      #   @return [Hash] A hash with event listeners registered within a bus
      attr_reader :listeners

      # Initialize a new event bus
      #
      # @param [Hash] events A hash with events
      # @param [Hash] listeners A hash with listeners
      #
      # @api private
      def initialize(events: EMPTY_HASH, listeners: LISTENERS_HASH.dup)
        @listeners = listeners
        @events = events
      end

      # @api private
      def process(event_id, payload)
        listeners[event_id].each do |(listener, query)|
          event = events[event_id].payload(payload)

          if event.trigger?(query)
            yield(event, listener)
          end
        end
      end

      # @api private
      def publish(event_id, payload)
        process(event_id, payload) do |event, listener|
          listener.(event)
        end
      end

      # @api private
      def attach(listener, query)
        events.each do |id, event|
          meth = event.listener_method

          if listener.respond_to?(meth)
            listeners[id] << [listener.method(meth), query]
          end
        end
      end

      # @api private
      def detach(listener)
        listeners.each do |id, memo|
          memo.each do |tuple|
            current_listener, _ = tuple
            listeners[id].delete(tuple) if current_listener.receiver.equal?(listener)
          end
        end
      end

      # @api private
      def subscribe(event_id, query, &block)
        listeners[event_id] << [block, query]
        self
      end

      # @api private
      def subscribed?(listener)
        listeners.values.any? { |value| value.any? { |(block, _)| block.equal?(listener) } }
      end

      # @api private
      def event_registered?(event_id)
        !events[event_id].nil?
      end
    end
  end
end
