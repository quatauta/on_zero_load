# -*- coding: utf-8; -*-
# frozen_string_literal: true
# vim:set fileencoding=utf-8:

Gem::Specification.new do |spec|
  spec.name          = 'on_zero_load'
  spec.version       = '0.0.1'
  spec.authors       = 'Daniel Schömer'
  spec.email         = 'daniel.schoemer@gmx.net'

  spec.summary       = 'Execute a command after the system load dropped below a certain threshold'
  spec.description   = 'Execute a command after the system load dropped below a certain threshold. It can monitor the loadavg, harddisk and network activity. Support for keyboard and mouse usage monitoring in X11 (like a screensaver) is planned.'
  spec.homepage      = "https://github.com/quatauta/#{spec.name}"
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.3.0'

  spec.add_runtime_dependency 'RubyInline', '>= 3.8'
  spec.add_runtime_dependency 'ruby-units', '>= 2.0.1'
  # spec.add_runtime_dependency 'cap2', '>=0.0.2'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'bundler-audit'
  spec.add_development_dependency 'flog', '<4.4.0' # flog 4.4.0 is causing metric_fu to fail
  spec.add_development_dependency 'cucumber', '>= 0.1.8'
  spec.add_development_dependency 'did_you_mean'
  spec.add_development_dependency 'fuubar'
  spec.add_development_dependency 'metric_fu', '>= 1.5'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rake', '>= 0.8.3'
  spec.add_development_dependency 'rdoc', '>= 2.4'
  spec.add_development_dependency 'rspec', '>= 3'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'rubinjam'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'yard', '>= 0.9.5'
end
