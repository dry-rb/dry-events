# coding: utf-8
require File.expand_path('../lib/dry/events/version', __FILE__)

Gem::Specification.new do |spec|
  spec.name          = 'dry-events'
  spec.version       = Dry::Events::VERSION
  spec.authors       = ['Piotr Solnica']
  spec.email         = ['piotr.solnica+oss@gmail.com']
  spec.summary       = 'Pub/sub system'
  spec.homepage      = 'https://github.com/dry-rb/dry-events'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'concurrent-ruby', '~> 1.0'
  spec.add_runtime_dependency 'dry-core', '~> 0.4'
  spec.add_runtime_dependency 'dry-equalizer', '~> 0.2'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
end
