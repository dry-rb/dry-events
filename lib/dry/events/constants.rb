# frozen_string_literal: true

require "concurrent/map"

module Dry
  module Events
    include Dry::Core::Constants

    LISTENERS_HASH = Concurrent::Map.new { |h, k| h[k] = [] }
  end
end
