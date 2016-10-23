require 'optparse'


module OnZeroLoad
  class Main
    class IncompatibleUnit < OptionParser::InvalidArgument
      def initialize(reason, *args)
        super(args)
        @reason = reason
      end
    end

    class MainOptParse < OnZeroLoad::Main
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

      def self.threshold_option_description(more)
        desc    = more[:desc]
        unit    = more[:unit].units unless more[:unit].units.empty?
        default = more[:unit]       unless more[:unit].scalar == 1

        desc << " ("                 if unit || default
        desc << "in #{unit}"         if unit
        desc << ", "                 if unit && default
        desc << "default #{default}" if default
        desc << ")"                  if unit || default
      end

      def self.threshold_option_value_to_unit(value, unit)
        value = Unit.new(value)

        unless value.compatible?(unit)
          unit_numerator = Unit.new(unit.numerator.join)

          if value.compatible?(unit_numerator)
            unit_denominator = Unit.new(unit.denominator.join)
            value = value / unit_denominator
          end
        end

        unless value.compatible?(unit)
          raise IncompatibleUnit.new("#{value} is not compatible to #{unit}")
        end

        value.convert_to(unit)
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

      def self.parse(args = ARGV, standards, thresholds, commands)
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
    end
  end
end
