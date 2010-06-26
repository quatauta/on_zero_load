# -*- coding: utf-8 -*-

module OnZeroLoad
  autoload :CPU,     'on_zero_load/cpu'
  autoload :Disk,    'on_zero_load/disk'
  autoload :Idle,    'on_zero_load/idle'
  autoload :LoadAvg, 'on_zero_load/loadavg'
  autoload :Main,    'on_zero_load/main'
  autoload :Net,     'on_zero_load/net'

  # The very version of this library.
  VERSION = '0.0.1'
end
