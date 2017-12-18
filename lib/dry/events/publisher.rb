require 'concurrent/map'

require 'dry/core/class_attributes'

require 'dry/events/constants'
require 'dry/events/event'
require 'dry/events/bus'

module Dry
  module Events
    # Extension used for classes that can trigger events
    #
    # @api public
    class Publisher < Module
      include Dry::Equalizer(:id)

      # @api private
      def self.registry
        @__registry__ ||= Concurrent::Map.new
      end

      # @api private
      def self.included(klass)
        klass.include(new(klass.name))
        super
      end

      attr_reader :id

      def self.[](id)
        new(id)
      end

      def initialize(id)
        @id = id
      end

      # @api private
      def included(klass)
        klass.extend(ClassMethods)
        klass.include(InstanceMethods)

        self.class.registry[id] = klass

        super
      end

      module ClassMethods
        # Register an event
        #
        # @param [String] id A unique event key
        # @param [Hash] info
        #
        # @api public
        def register_event(id, info = EMPTY_HASH)
          events[id] = Event.new(id, info)
          self
        end

        # @api public
        def subscribe(event_id, query = EMPTY_HASH, &block)
          listeners[event_id] << [block, query]
          self
        end

        # @api private
        def new_bus
          Bus.new(name, events: events.dup, listeners: listeners.dup)
        end

        # @api private
        def events
          @__events__ ||= Concurrent::Map.new
        end

        # @api private
        def listeners
          @__listeners__ ||= LISTENERS_HASH.dup
        end
      end

      module InstanceMethods
        # @api private
        def __bus__
          @__bus__ ||= self.class.new_bus
        end

        # Publish an event
        #
        # @param [String] event_id The event key
        # @param [Hash] payload An optional payload
        #
        # @api public
        def publish(event_id, payload = EMPTY_HASH)
          __bus__.publish(event_id, payload)
          self
        end
        alias_method :trigger, :publish

        # Subscribe to events.
        # If the query parameter is provided, filters events by payload.
        #
        # @param [String] event_id The event key
        # @param [Hash] query An optional event filter
        # @yield [block] The callback
        # @return [Object] self
        #
        # @api public
        def subscribe(event_id, query = EMPTY_HASH, &block)
          __bus__.subscribe(event_id, query, &block)
          self
        end

        # Return true if a given listener has been subscribed to any event
        #
        # @api public
        def subscribed?(listener)
          __bus__.subscribed?(listener)
        end

        # @api public
        def process(event_id, payload = EMPTY_HASH, &block)
          __bus__.process(event_id, payload, &block)
        end
      end
    end
  end
end
