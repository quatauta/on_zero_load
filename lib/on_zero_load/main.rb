# -*- coding: utf-8; -*-
# frozen_string_literal: true
# vim:set fileencoding=utf-8:

require 'ruby-units'

module OnZeroLoad
  class Main
    autoload :MainOptParse, 'on_zero_load/main/optparse'

    # Standard options
    STANDARD_OPTIONS = {
      :help => {
        :desc  => "Show this message",
        :short => :h,
      },
      :version => {
        :desc  => "Print version and exit",
        :short => :v,
      },
      :verbose => {
        :desc  => "Verbose output, print acual values and thresholds",
        :short => :V,
      }
    }

    # The commandline options to set the thresholds
    THRESHOLDS = {
      :load => {
        :desc  => "System load average",
        :short => :l,
        :value => "<number>",
        :unit  => Unit.new("0.1"),
      },
      :cpu => {
        :desc  => "CPU usage",
        :short => :c,
        :value => "<percents>",
        :unit  => Unit.new("5 %"),
      },
      :disk => {
        :desc  => "Harddisk throughput",
        :short => :d,
        :value => "<byte>[/<sec>]",
        :unit => Unit.new("KiB/s"),
      },
      :net => {
        :desc  => "Network throughput",
        :short => :n,
        :value => "<bit>[/<sec>]",
        :unit => Unit.new("Kib/s"),
      },
      :idle => {
        :desc  => "Idle time without user input",
        :short => :i,
        :value => "<time>",
        :unit  => Unit.new("minutes"),
      }
    }

    # The predefined commands that can be set by command-line options instead of explicit
    # arguments.
    COMMANDS = {
      :reboot => {
        :desc  => "Reboot system",
        :short => :R,
        :cmd   => ["sudo", "systemctl", "reboot"],
      },
      :shutdown => {
        :desc  => "Halt system",
        :short => :S,
        :cmd   => ["sudo", "systemctl", "poweroff"],
      },
      :hibernate => {
        :desc  => "Hibernate/suspend system",
        :short => :H,
        :cmd   => ["sudo", "systemctl", "hybrid-sleep"],
      },
      :beep => {
        :desc  => "Let the system speaker beep",
        :short => :B,
        :cmd   => ["beep"],
      },
    }

    def self.parse(args = ARGV.clone, standards = STANDARD_OPTIONS, thresholds = THRESHOLDS, commands = COMMANDS)
      MainOptParse.parse(args, standards, thresholds, commands)
    end

    def self.run(args = ARGV.clone)
      puts parse(args)
    end
  end
end
