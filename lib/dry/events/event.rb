require 'dry/equalizer'
require 'dry/events/constants'

module Dry
  module Events
    # Event object
    #
    # @api public
    class Event
      include Dry::Equalizer(:id, :payload)

      # @!attribute [r] id
      #   @return [Symbol] The event identifier
      attr_reader :id

      # Initialize a new event
      #
      # @param [Symbol] id The event identifier
      # @param [Hash] payload Optional payload
      #
      # @return [Event]
      #
      # @api private
      def initialize(id, payload = EMPTY_HASH)
        @id = id
        @payload = payload
      end

      # Get data from the payload
      #
      # @param [String,Symbol] name
      #
      # @api public
      def [](name)
        @payload.fetch(name)
      end

      # Coerce an event to a hash
      #
      # @return [Hash]
      #
      # @api public
      def to_h
        @payload
      end
      alias_method :to_hash, :to_h

      # Get or set a payload
      #
      # @overload
      #   @return [Hash] payload
      #
      # @overload payload(data)
      #   @param [Hash] data A new payload
      #   @return [Event] A copy of the event with the provided payload
      #
      # @api public
      def payload(data = nil)
        if data
          self.class.new(id, @payload.merge(data))
        else
          @payload
        end
      end

      # @api private
      def trigger?(query)
        query.empty? || query.all? { |key, value| payload[key] == value }
      end
    end
  end
end

