# frozen_string_literal: true

require_relative "support/coverage"

begin
  require "pry"
  require "pry-byebug"
rescue LoadError;
end
require "dry-events"

SPEC_ROOT = Pathname(__dir__)

Dir[SPEC_ROOT.join("shared/**/*.rb")].each(&method(:require))
Dir[SPEC_ROOT.join("support/**/*.rb")].each(&method(:require))

RSpec.configure do |config|
  config.after(:example) do
    Dry::Events::Publisher.instance_variable_set(:@__registry__, Concurrent::Map.new)
  end
end
