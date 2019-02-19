require 'set'

module Dry
  module Events
    class Filter
      NO_MATCH = Object.new.freeze

      attr_reader :checks

      def initialize(filter)
        @checks = build_checks(filter)
      end

      def call(payload)
        checks.all? { |check| check.(payload) }
      end

      def build_checks(hash, keys = [])
        hash.each_with_object([]) do |(key, value), checks|
          path = [*keys, key]

          if value.is_a?(Hash)
            checks.concat(build_checks(value, path))
          else
            predicate = predicate(value)
            checks << method(:compare).curry.(path, predicate)
          end
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
