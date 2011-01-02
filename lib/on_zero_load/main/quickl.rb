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

      # The commandline options to set the thresholds
      THRESHOLDS = {
        :load => {
          :desc  => "System load average",
          :short => :l,
          :value => "LOADAVG",
          :class => Float,
        },
        :cpu => {
          :desc  => "CPU usage",
          :short => :c,
          :value => "THROUGHPUT",
        },
        :disk => {
          :desc  => "Harddisk throughput",
          :short => :d,
          :value => "THROUGHPUT",
        },
        :net => {
          :desc  => "Network throughput",
          :short => :n,
          :value => "THROUGHPUT",
        },
        :input => {
          :desc  => "Time without user input",
          :short => :i,
          :value => "DURATION",
        }
      }

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

      # Adds standard commandline options to the +optparse+ OptionParser +parser+ that
      # store the supplied values in the +options+ hash or raise appropriate Quickl
      # errors.
      #
      # These options get build:
      #
      #  -h, --help:    raise Quickl:Help
      #  -v, --version: raise Quickl::Exit with version information
      #  -V, --verbose: options[:verbose] = true
      def self.define_standard_options(parser, options)
        parser.separator("")
        parser.separator("Standard options:")
        parser.separator("")

        parser.on("-h", "--help", "Show this message") {
          raise Quickl::Help
        }
        parser.on("-v", "--version", "Print version and exit") {
          raise Quickl::Exit, "#{program_name} #{OnZeroLoad::VERSION}"
        }
        parser.on("-V", "--verbose", "Verbose output, print acual values and thresholds") { |v|
          options[:verbose] = v
        }

        parser
      end

      # Adds commandline options to the +optparse+ OptionsParser +parser+ to define
      # thresholds when a command should be executed. The options are defined in Hash
      # +thresholds+ which should look like this:
      #
      #  { :load => { :desc  => "System load average",
      #               :short => :l, :value => "LOADAVG", :class => Float, },
      #    :cpu  => { :desc  => "CPU usage",
      #               :short => :c, :value => "THROUGHPUT" } }
      #
      # The key represents the long option name, the description is stored in subkey
      # +:desc+, the short option name in subkey +:short+, the value description in subkey
      # +:value+. The optional class for automatic type conversion (see +optparse+
      # OptionParser) is stored in subkey +:class+.
      #
      # Each option just stores the user-supplied value in the +options+ hash under its
      # long name.
      def self.define_threshold_options(parser, thresholds, options)
        parser.separator("")
        parser.separator("Threshold options:")
        parser.separator("")

        thresholds.sort { |a,b| a.to_s <=> b.to_s } .each do |long, more|
          params = [ "-#{more[:short]}",
                     "--#{long}=#{more[:value]}",
                     more[:desc] ]
          params << more[:class] if more[:class]
          parser.on(*params) { |v| options[long] = v }
        end

        parser
      end

      def self.define_command_options(parser, commands, options)
        parser.separator("")
        parser.separator("Predefined commands:")
        parser.separator("")

        commands.sort { |a,b| a.to_s <=> b.to_s } .each { |long, more|
          params = [ "-#{more[:short]}",
                     "--#{long}",
                     "%s, \"%s\"" % [ more[:desc], more[:cmd].join(" ") ] ]
          parser.on(*params) { |v| options[long] = v }
        }
      end

      options do |parser|
        @cmd_options ||= {}

        define_standard_options(parser, @cmd_options)
        define_threshold_options(parser, THRESHOLDS, @cmd_options)
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
