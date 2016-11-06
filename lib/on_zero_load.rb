# -*- coding: utf-8; -*-
# frozen_string_literal: true
# vim:set fileencoding=utf-8:

module OnZeroLoad
  autoload :CPU,     'on_zero_load/cpu'
  autoload :Disk,    'on_zero_load/disk'
  autoload :Idle,    'on_zero_load/idle'
  autoload :LoadAvg, 'on_zero_load/loadavg'
  autoload :CLI,     'on_zero_load/cli'
  autoload :Net,     'on_zero_load/net'

  # The authors of this library and their email addresses.
  AUTHORS = [ { :name => 'Daniel Schömer', :email => 'daniel.schoemer@gmx.net' } ]

  # The very version of this library.
  VERSION = '0.0.1'
end
