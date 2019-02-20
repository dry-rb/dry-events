if RUBY_ENGINE == 'ruby' && ENV['COVERAGE'] == 'true'
  require 'simplecov'
  SimpleCov.start do
    add_filter '/spec/'
  end
end

begin
  require 'pry'
  require 'pry-byebug'
rescue LoadError; end

require 'dry-events'

SPEC_ROOT = Pathname(__dir__)

Dir[SPEC_ROOT.join('shared/**/*.rb')].each(&method(:require))
Dir[SPEC_ROOT.join('support/**/*.rb')].each(&method(:require))

RSpec.configure do |config|
  config.warnings = true
  config.disable_monkey_patching!
  config.filter_run_when_matching :focus

  config.after(:example) do
    Dry::Events::Publisher.instance_variable_set(:@__registry__, Concurrent::Map.new)
  end
end
