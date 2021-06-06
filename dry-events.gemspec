# frozen_string_literal: true

# this file is synced from dry-rb/template-gem project

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "dry/events/version"

Gem::Specification.new do |spec|
  spec.name          = "dry-events"
  spec.authors       = ["Piotr Solnica"]
  spec.email         = ["piotr.solnica+oss@gmail.com"]
  spec.license       = "MIT"
  spec.version       = Dry::Events::VERSION.dup

  spec.summary       = "Pub/sub system"
  spec.description   = spec.summary
  spec.homepage      = "https://dry-rb.org/gems/dry-events"
  spec.files         = Dir["CHANGELOG.md", "LICENSE", "README.md", "dry-events.gemspec", "lib/**/*"]
  spec.bindir        = "bin"
  spec.executables   = []
  spec.require_paths = ["lib"]

  spec.metadata["allowed_push_host"] = "https://rubygems.org"
  spec.metadata["changelog_uri"]     = "https://github.com/dry-rb/dry-events/blob/master/CHANGELOG.md"
  spec.metadata["source_code_uri"]   = "https://github.com/dry-rb/dry-events"
  spec.metadata["bug_tracker_uri"]   = "https://github.com/dry-rb/dry-events/issues"

  if defined? JRUBY_VERSION
    spec.required_ruby_version = ">= 2.5.0"
  else
    spec.required_ruby_version = ">= 2.6.0"
  end

  # to update dependencies edit project.yml
  spec.add_runtime_dependency "concurrent-ruby", "~> 1.0"
  spec.add_runtime_dependency "dry-core", "~> 0.5", ">= 0.5"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
