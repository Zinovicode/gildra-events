# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('ruby/lib', __dir__)
require 'gildra_events/version'

Gem::Specification.new do |spec|
  spec.name          = 'gildra-events'
  spec.version       = GildraEvents::VERSION
  spec.authors       = ['Gildra']
  spec.email         = ['justin@zinovi.xyz']
  spec.summary       = 'Shared Gildra event envelope and push-action types'
  spec.description   = 'Canonical event envelope shape and PushAction discriminated union used across Gildra services.'
  spec.homepage      = 'https://github.com/Zinovicode/gildra-events'
  spec.license       = 'UNLICENSED'
  spec.required_ruby_version = '>= 3.0'

  spec.files         = Dir['ruby/lib/**/*.rb'] + ['README.md', 'gildra-events.gemspec']
  spec.require_paths = ['ruby/lib']
end
