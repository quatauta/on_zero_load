require 'trollop'


module OnZeroLoad
  class Main
    class MainTrollop < OnZeroLoad::Main
      def self.define_standard_options(parser)
        parser.text("")
        parser.text("Standard options:")
        parser.text("")
        parser.opt(:help,    "Show this message")
        parser.opt(:version, "Print version and exit")
        parser.opt(:verbose, "Verbose output, print acual values and thresholds",
                   :short => :V, :multi => true)
        parser
      end

      def self.define_limit_options(parser, thresholds)
        parser.text("")
        parser.text("Threshold options:")
        parser.text("")
        parser.opt(:load,  "System load average",     :multi => true, :type => :float)
        parser.opt(:cpu,   "CPU usage",               :multi => true, :type => :string)
        parser.opt(:disk,  "Harddisk throughput",     :multi => true, :type => :string)
        parser.opt(:net,   "Network throughput",      :multi => true, :type => :string)
        parser.opt(:input, "Time without user input", :multi => true, :type => :string)
        parser
      end

      def self.define_command_options(parser, commands)
        parser.text("")
        parser.text("Predefined commands:")
        parser.text("")

        commands.each { |long, more|
          parser.opt(long, "%s, \"%s\"" % [ more[:desc], more[:cmd].join(" ") ],
                     :short => more[:short])
        }
      end

      def self.option_parser(thresholds, commands)
        Trollop::Parser.new {
          base = File.basename($0)

          stop_on_unknown

          version("%s %s" % [ base, OnZeroLoad::VERSION ])
          text("Usage: %s [OPTION]... -- [COMMAND] [COMMAND OPTION]..." % [ base ])
          text("")
          text("Execute a command if the system load drops below given thresholds.")

          MainTrollop.define_standard_options(self)
          MainTrollop.define_limit_options(self, thresholds)
          MainTrollop.define_command_options(self, commands)
        }
      end

      def self.parse(args = ARGV, thresholds, commands)
        parser  = self.option_parser(thresholds, commands)
        options = {}

        begin
          options = parser.parse(args)
        rescue Trollop::CommandlineError => error
          $stderr.puts "Error: #{error.message}."
          $stderr.puts "Try --help for help."
        rescue Trollop::HelpNeeded
          parser.educate
        rescue Trollop::VersionNeeded
          puts parser.version
        end

        [:load, :cpu, :disk, :net, :input].each { |key|
          options[key] = options[key].last if options[key].kind_of? Array
        }

        options[:args] = parser.leftovers

        options
      end
    end
  end
end
