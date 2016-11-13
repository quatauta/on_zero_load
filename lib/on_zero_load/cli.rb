# -*- coding: utf-8; -*-
# frozen_string_literal: true
# vim:set fileencoding=utf-8:

require 'optparse'
require 'ruby-units'

module OnZeroLoad
  class CLI
    class IncompatibleUnit < OptionParser::InvalidArgument
      def initialize(reason, *args)
        super(args)
        @reason = reason
      end
    end

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
        :desc    => "System load average",
        :short   => :l,
        :value   => "<number>",
        :unit    => Unit.new("0.1"),
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

    def self.run(args = ARGV.clone)
      puts parse(args)
    end

    def self.parse(args = ARGV.clone, standards = STANDARD_OPTIONS, thresholds = THRESHOLDS, commands = COMMANDS)
      options = {}
      parser  = self.option_parser(options, standards, thresholds, commands)

      begin
        options[:args] = parser.parse(args)
      rescue OptionParser::ParseError => error
        $stderr.puts "Error: #{error.message}."
        $stderr.puts "Try --help for help."
      end

      if options[:help]
        $stdout.puts parser
      end

      if options[:version]
        $stdout.puts parser.version
      end

      [:load, :cpu, :disk, :net, :input].each { |key|
        options[key] = options[key].last if options[key].kind_of? Array
      }

      options
    end

    def self.option_parser(options, standards, thresholds, commands)
      OptionParser.new { |parser|
        base = File.basename($0)

        parser.version = "%s %s" % [ base, OnZeroLoad::VERSION ]
        parser.banner  = "Usage: %s [OPTION]... -- [COMMAND] [COMMAND OPTION]..." % [ base ]
        parser.separator("")
        parser.separator("Execute a command if the system load drops below given thresholds.")

        self.define_standard_options(parser, standards, options)
        self.define_threshold_options(parser, thresholds, options)
        self.define_command_options(parser, commands, options)
      }
    end

    def self.define_standard_options(parser, standards, options)
      parser.separator("")
      parser.separator("Standard options:")
      parser.separator("")

      standards.each do |long, more|
        parser.on("-#{more[:short]}", "--#{long}", more[:desc]) do |value|
          options[long] = value
        end
      end

      parser
    end

    def self.define_threshold_options(parser, thresholds, options)
      parser.separator("")
      parser.separator("Threshold options:")
      parser.separator("")

      thresholds.each do |long, more|
        desc = threshold_option_description(more)

        parser.on("-#{more[:short]}", "--#{long}=#{more[:value]}", desc) do |value|
          options[long] = threshold_option_value_to_unit(value, more[:unit])
        end
      end

      parser
    end

    def self.define_command_options(parser, commands, options)
      parser.separator("")
      parser.separator("Predefined commands:")
      parser.separator("")

      commands.each do |long, more|
        parser.on("-#{more[:short]}", "--#{long}",
                  "#{more[:desc]} ('#{more[:cmd].join(" ")}')") do |value|
          options[long] = value
        end
      end

      parser
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
          value_unit = value.to_s.gsub(/^[0-9]* */, "")
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
