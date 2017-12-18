require 'dry/equalizer'
require 'dry/events/bus'
require 'dry/events/publisher'

module Dry
  module Events
    # Extension for objects that can listen to events
    #
    # @api public
    class Listener < Module
      include Dry::Equalizer(:id, :publisher)

      attr_reader :id

      attr_reader :publisher

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
