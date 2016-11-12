# -*- coding: utf-8; -*-
# frozen_string_literal: true
# vim:set fileencoding=utf-8:

require 'ruby-units'

module OnZeroLoad
  class CLI
    autoload :CliOptParse, 'on_zero_load/cli/optparse'

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
        :unit  => Unit.new("seconds"),
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
      CliOptParse.parse(args, standards, thresholds, commands)
    end

    def self.run(args = ARGV.clone)
      puts parse(args)
    end

    def self.threshold_option_description(more)
      desc    = more[:desc].clone
      unit    = more[:unit].units unless more[:unit].units.empty?
      default = more[:unit]       unless more[:unit].scalar == 1

      desc += " ("                 if unit || default
      desc += "in #{unit}"         if unit
      desc += ", "                 if unit && default
      desc += "default #{default}" if default
      desc += ")"                  if unit || default
    end

    def self.threshold_option_value_to_unit(value, unit)
      begin
        value = Unit.new(value)
      rescue ArgumentError => first_error
        begin
          value_unit = value.to_s.gsub(/^[0-9]*/, "")
          value      = Unit.new(value + unit.units.sub(value_unit, ""))
        rescue ArgumentError => second_error
          raise first_error
        end
      end


      unless value.compatible?(unit)
        unit_numerator = Unit.new(unit.numerator.join)

        if value.compatible?(unit_numerator)
          unit_denominator = Unit.new(unit.denominator.join)
          value = value / unit_denominator
        elsif value.unitless?
          value = Unit.new(value, unit.units)
        end
      end

      unless value.compatible?(unit)
        raise IncompatibleUnit.new("#{value} is not compatible to #{unit}")
      end

      value = value / 100.0 if unit.units == '%' && value.unitless? && value > 1

      value.convert_to(unit)
    end
  end
end
