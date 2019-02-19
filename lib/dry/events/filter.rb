require 'set'

module Dry
  module Events
    class Filter
      NO_MATCH = Object.new.freeze

      attr_reader :checks

      def initialize(filter)
        @checks = build_checks(filter)
      end

      def call(payload = EMPTY_HASH)
        checks.all? { |check| check.(payload) }
      end

      def build_checks(filter, checks = EMPTY_ARRAY, keys = EMPTY_ARRAY)
        if filter.is_a?(Hash)
          filter.reduce(checks) do |cs, (key, value)|
            build_checks(value, cs, [*keys, key])
          end
        else
          [*checks, method(:compare).curry.(keys, predicate(filter))]
        end
      end

      def compare(path, predicate, payload)
        value = path.reduce(payload) do |acc, key|
          if acc.is_a?(Hash) && acc.key?(key)
            acc[key]
          else
            break NO_MATCH
          end
        end

        predicate.(value)
      end

      def predicate(value)
        case value
        when Proc then value
        when Array then value.method(:include?)
        else value.method(:==)
        end
      end
    end
  end
end
