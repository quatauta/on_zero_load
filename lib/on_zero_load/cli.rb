# -*- coding: utf-8; -*-
# frozen_string_literal: true
# vim:set fileencoding=utf-8:

require 'optparse'
require 'ruby-units'

module OnZeroLoad
  class CLI
    autoload :Parser, 'on_zero_load/cli/parser'

    class IncompatibleUnit < OptionParser::InvalidArgument
      def initialize(reason, *args)
        super(args)
        @reason = reason
      end
    end

    # Standard options
    STANDARD_OPTIONS = {
      help: {
        desc:  'Show this message',
        short: :h
      },
      version: {
        desc:  'Print version and exit',
        short: :v
      },
      verbose: {
        desc:  'Verbose output, print acual values and thresholds',
        short: :V
      }
    }.freeze

    # The commandline options to set the thresholds
    THRESHOLDS = {
      load: {
        desc:  'System load average',
        short: :l,
        value: '<number>',
        unit:  Unit.new('0.1')
      },
      cpu: {
        desc:  'CPU usage',
        short: :c,
        value: '<percents>',
        unit:  Unit.new('5 %')
      },
      disk: {
        desc:  'Harddisk throughput',
        short: :d,
        value: '<byte>[/<sec>]',
        unit:  Unit.new('KiB/s')
      },
      net: {
        desc:  'Network throughput',
        short: :n,
        value: '<bit>[/<sec>]',
        unit:  Unit.new('Kib/s')
      },
      idle: {
        desc:  'Idle time without user input',
        short: :i,
        value: '<time>',
        unit:  Unit.new('seconds')
      }
    }.freeze

    # The predefined commands that can be set by command-line options instead of explicit
    # arguments.
    COMMANDS = {
      reboot: {
        desc:  'Reboot system',
        short: :R,
        cmd:   %w(sudo systemctl reboot)
      },
      shutdown: {
        desc:   'Halt system',
        short: :S,
        cmd:   %w(sudo systemctl poweroff)
      },
      hibernate: {
        desc:  'Hibernate/suspend system',
        short: :H,
        cmd:   %w(sudo systemctl hybrid-sleep)
      },
      beep: {
        desc:  'Let the system speaker beep',
        short: :B,
        cmd:   %w(beep)
      }
    }.freeze

    def self.run(args = ARGV.clone)
      puts parse(args)
    end

    def self.parse(args = ARGV.clone, standards = STANDARD_OPTIONS, thresholds = THRESHOLDS,
                   commands = COMMANDS)
      OnZeroLoad::CLI::Parser.parse(args, standards, thresholds, commands)
    end
  end
end
