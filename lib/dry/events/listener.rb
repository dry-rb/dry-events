require 'dry/equalizer'
require 'dry/events/publisher'

module Dry
  module Events
    # Extension for objects that can listen to events
    #
    # @example
    #   class AppEvents
    #     include Dry::Events::Publisher[:app]
    #
    #     register_event("users.created")
    #   end

    #   class MyListener
    #     include Dry::Events::Listener[:app]
    #
    #     subscribe("users.created") do |event|
    #       # do something
    #     end
    #   end
    #
    # @api public
    class Listener < Module
      include Dry::Equalizer(:id, :publisher)

      # @!attribute [r] :id
      #   @return [Symbol,String] The publisher identifier
      #   @api private
      attr_reader :id

      # @!attribute [r] :publisher
      #   @return [Publisher] The publisher instance
      #   @api private
      attr_reader :publisher

      # Create a listener extension for a specific publisher
      #
      # @return [Module]
      #
      # @api public
      def self.[](id)
        new(id)
      end

      # @api private
      def initialize(id)
        @id = id
        @publisher = publisher = Publisher.registry[id]

        define_method(:subscribe) do |event_id, query = EMPTY_HASH, &block|
          publisher.subscribe(event_id, query, &block)
        end
      end

      # @api private
      def included(klass)
        klass.extend(self)
        super
      end
    end
  end
end
