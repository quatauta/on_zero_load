require 'optparse'


module OnZeroLoad
  class Main
    class MainOptParse < OnZeroLoad::Main
      def self.define_standard_options(parser, options)
        parser.separator("")
        parser.separator("Standard options:")
        parser.separator("")
        parser.on("-h", "--help", "Show this message")         { options[:help]    = true }
        parser.on("-v", "--version", "Print version and exit") { options[:version] = true }
        parser.on("-V", "--verbose",
                  "Verbose output, print acual values and thresholds") { options[:verbose] = true }
        parser
      end

      def self.define_limit_options(parser, options)
        parser.separator("")
        parser.separator("Threshold options:")
        parser.separator("")
        parser.on("-l", "--load=LOADAVG",    "System load average")     { |v| options[:load]  = v.to_f }
        parser.on("-c", "--cpu=THROUGHPUT",  "CPU usage")               { |v| options[:cpu]   = v }
        parser.on("-d", "--disk=THROUGHPUT", "Harddisk throughput")     { |v| options[:disk]  = v }
        parser.on("-n", "--net=THROUGHPUT",  "Network throughput")      { |v| options[:net]   = v }
        parser.on("-i", "--input=DURATION",  "Time without user input") { |v| options[:input] = v }
        parser
      end

      def self.define_command_options(parser, commands, options)
        parser.separator("")
        parser.separator("Predefined commands:")
        parser.separator("")

        commands.each { |long, more|
          parser.on("-#{more[:short]}",
                    "--#{long}",
                    "%s, \"%s\"" % [ more[:desc], more[:cmd].join(" ") ]) { |v|
            options[long] = v
          }
        }
      end

      def self.option_parser(options, thresholds, commands)
        OptionParser.new { |parser|
          base = File.basename($0)

          # stop_on_unknown

          parser.version = "%s %s" % [ base, OnZeroLoad::VERSION ]
          parser.banner  = "Usage: %s [OPTION]... -- [COMMAND] [COMMAND OPTION]..." % [ base ]
          parser.separator("")
          parser.separator("Execute a command if the system load drops below given thresholds.")

          self.define_standard_options(parser, options)
          self.define_limit_options(parser, options)
          self.define_command_options(parser, commands, options)
        }
      end

      def self.parse(args = ARGV, thresholds, commands)
        options = {}
        parser  = self.option_parser(options, thresholds, commands)

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
