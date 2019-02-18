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
            checks << method(:compare).curry.(path, value)
          end
        end
      end

      def compare(path, value, payload)
        value == path.reduce(payload) do |acc, key|
          if acc.is_a?(Hash)
            acc.fetch(key, NO_MATCH)
          else
            NO_MATCH
          end
        end
      end
    end
  end
end
