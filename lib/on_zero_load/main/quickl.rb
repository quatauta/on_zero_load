require 'quickl'


module OnZeroLoad
  class Main
    # Execute a command if the system load drops below given thresholds.
    #
    # SYNOPSIS
    #
    #   #{program_name} [OPTION]... -- [COMMAND] [COMMAND OPTION]...
    #
    # OPTIONS
    # #{summarized_options}
    #
    # DESCRIPTION
    #
    #   Long description once I know what it really does
    class MainQuickl < Quickl::Command(__FILE__, __LINE__)
      # The Hash of commandline options
      attr_accessor :cmd_options

      # The predefined commands that can be set by command-line options instead of explicit
      # arguments.
      PREDEFINED_COMMANDS = {
        :reboot => {
          :desc  => "Reboot system",
          :short => :R,
          :cmd   => ["sudo", "shutdown", "-r", "now"],
        },
        :shutdown => {
          :desc  => "Halt system",
          :short => :S,
          :cmd   => ["sudo", "shutdown", "-h", "now"],
        },
        :hibernate => {
          :desc  => "Hibernate system",
          :short => :H,
          :cmd   => ["sudo", "pm-hibernate"],
        },
        :beep => {
          :desc  => "Let the system speaker beep",
          :short => :B,
          :cmd   => ["beep"],
        },
      }

      def self.define_standard_options(parser, options)
        parser.separator("")
        parser.separator("Standard options:")
        parser.separator("")
        parser.on("-h", "--help", "Show this message")         { raise Quickl::Help }
        parser.on("-v", "--version", "Print version and exit") {
          raise Quickl::Exit, "#{program_name} #{OnZeroLoad::VERSION}"
        }
        parser.on("-V", "--verbose", "Verbose output, print acual values and thresholds") {
          options[:verbose] = true
        }
        parser
      end

      def self.define_limit_options(parser, options)
        parser.separator("")
        parser.separator("Threshold options:")
        parser.separator("")
        parser.on("-l", "--load=LOADAVG", Float, "System load average") { |v| options[:load]  = v }
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

      options do |parser|
        @cmd_options ||= {}

        define_standard_options(parser, @cmd_options)
        define_limit_options(parser, @cmd_options)
        define_command_options(parser, PREDEFINED_COMMANDS, @cmd_options)
      end

      def execute(args)
        [:load, :cpu, :disk, :net, :input].each { |key|
          @cmd_options[key] = @cmd_options[key].last if @cmd_options[key].kind_of? Array
        }

        @cmd_options
      end

      def self.parse(args = ARGV)
        self.run(args)
      end
    end
  end
end
