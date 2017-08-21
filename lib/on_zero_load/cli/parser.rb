# -*- coding: utf-8; -*-
# frozen_string_literal: true
# vim:set fileencoding=utf-8:

require 'optparse'
require 'ruby-units'

module OnZeroLoad
  class CLI
    class Parser < OnZeroLoad::CLI
      class IncompatibleUnit < OptionParser::InvalidArgument
        def initialize(reason, *args)
          super(args)
          @reason = reason
        end
      end

      def self.parse(args = ARGV.clone, standards = STANDARD_OPTIONS, thresholds = THRESHOLDS,
                     commands = COMMANDS)
        options = {}
        parser  = option_parser(options, standards, thresholds, commands)

        begin
          options[:args] = parser.parse(args)
        rescue OptionParser::ParseError => error
          $stderr.puts "Error: #{error.message}."
          $stderr.puts 'Try --help for help.'
        end

        $stdout.puts parser if options[:help]

        $stdout.puts parser.version if options[:version]

        [:load, :cpu, :disk, :net, :input].each do |key|
          options[key] = options[key].last if options[key].is_a? Array
        end

        options
      end

      def self.option_parser(options, standards, thresholds, commands)
        OptionParser.new do |parser|
          base = File.basename($PROGRAM_NAME)

          parser.version = "#{base} #{OnZeroLoad::VERSION}"
          parser.banner  = "Usage: #{base} [OPTION...] -- [COMMAND] [COMMAND OPTION...]"
          parser.separator('')
          parser.separator('Execute a command if the system load drops below given thresholds.')

          define_standard_options(parser, standards, options)
          define_threshold_options(parser, thresholds, options)
          define_command_options(parser, commands, options)
        end
      end

      def self.define_standard_options(parser, standards, options)
        parser.separator('')
        parser.separator('Standard options:')
        parser.separator('')

        standards.each do |long, more|
          parser.on("-#{more[:short]}", "--#{long}", more[:desc]) do |value|
            options[long] = value
          end
        end

        parser
      end

      def self.define_threshold_options(parser, thresholds, options)
        parser.separator('')
        parser.separator('Threshold options:')
        parser.separator('')

        thresholds.each do |long, more|
          desc = threshold_option_description(more)

          parser.on("-#{more[:short]}", "--#{long}=#{more[:value]}", desc) do |value|
            options[long] = threshold_option_value_to_unit(value, more[:unit])
          end
        end

        parser
      end

      def self.define_command_options(parser, commands, options)
        parser.separator('')
        parser.separator('Predefined commands:')
        parser.separator('')

        commands.each do |long, more|
          parser.on("-#{more[:short]}", "--#{long}",
                    "#{more[:desc]} ('#{more[:cmd].join(' ')}')") do |value|
            options[long] = value
          end
        end

        parser
      end

      def self.threshold_option_description(more)
        desc    = more[:desc].clone
        unit    = more[:unit].units unless more[:unit].units.empty?
        default = more[:unit]       unless more[:unit].scalar == 1

        desc += ' ('                 if unit || default
        desc += "in #{unit}"         if unit
        desc += ', '                 if unit && default
        desc += "default #{default}" if default
        desc += ')'                  if unit || default
      end

      def self.threshold_option_value_to_unit(value, unit)
        begin
          value = Unit.new(value)
        rescue ArgumentError => first_error
          begin
            value = Unit.new(value + unit.units.sub(value.to_s.gsub(/^[0-9]* */, ''), ''))
          rescue ArgumentError
            raise first_error
          end
        end

        unless value.compatible?(unit)
          unit_numerator = Unit.new(unit.numerator.join)

          if value.compatible?(unit_numerator)
            unit_denominator = Unit.new(unit.denominator.join)
            value /= unit_denominator
          elsif value.unitless?
            value = Unit.new(value, unit.units)
          end
        end

        unless value.compatible?(unit)
          raise IncompatibleUnit, "#{value} is not compatible to #{unit}"
        end

        value /= 100.0 if unit.units == '%' && value.unitless? && value > 1

        value = value.convert_to(unit)
        value = Unit.new(value.scalar.numerator, value.units) if value.scalar.denominator == 1
        value
      end
    end
  end
end
