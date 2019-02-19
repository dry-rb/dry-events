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
          values = Array(value).to_set

          if value.is_a?(Hash)
            checks.concat(build_checks(values, path))
          else
            checks << method(:compare).curry.(path, values)
          end
        end
      end

      def compare(path, values, payload)
        value = path.reduce(payload) do |acc, key|
          if acc.is_a?(Hash) && acc.key?(key)
            acc[key]
          else
            break NO_MATCH
          end
        end

        values.include?(value)
      end
    end
  end
end
