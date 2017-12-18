require 'concurrent/map'
require 'dry/core/constants'

module Dry
  module Events
    include Dry::Core::Constants

    LISTENERS_HASH = Concurrent::Map.new { |h, k| h[k] = [] }
  end
end
