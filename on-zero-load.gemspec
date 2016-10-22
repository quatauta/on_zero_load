# -*- coding: utf-8; -*-
# frozen_string_literal: true
# vim:set fileencoding=utf-8:

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'on_zero_load'

Gem::Specification.new do |spec|
  spec.name          = 'on_zero_load'
  spec.version       = OnZeroLoad::VERSION
  spec.authors       = OnZeroLoad::AUTHORS.map { |a| a[:name]  }.compact
  spec.email         = OnZeroLoad::AUTHORS.map { |a| a[:email] }.compact.join(", ")

  spec.summary       = 'Execute a command after the system load dropped below a certain threshold'
  spec.description   = 'Execute a command after the system load dropped below a certain threshold. It can monitor the loadavg, harddisk and network activity. Support for keyboard and mouse usage monitoring in X11 (like a screensaver) is planned.'
  spec.homepage      = "https://github.com/quatauta/#{spec.name}"
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.3.0'

  spec.add_runtime_dependency 'RubyInline', '>= 3.8'
  spec.add_runtime_dependency 'quickl', '>= 0.1.1'
  spec.add_runtime_dependency 'ruby-units', '>= 2.0.1'
  spec.add_runtime_dependency 'trollop', '>= 1.10'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency 'cucumber', '>= 0.1.8'
  spec.add_development_dependency 'metric_fu', '>= 1.5'
  spec.add_development_dependency 'rake', '>= 0.8.3'
  spec.add_development_dependency 'rdoc', '>= 2.4'
  spec.add_development_dependency 'rspec', '>= 1.1.11'
  spec.add_development_dependency 'yard'
end