module OnZeroLoad
  class Main
    autoload :MainOptParse, 'on_zero_load/main/optparse'
    autoload :MainQuickl,   'on_zero_load/main/quickl'
    autoload :MainTrollop,  'on_zero_load/main/trollop'

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
    COMMANDS = {
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

    def self.parse(args = ARGV.clone, parser = :trollop, thresholds = THRESHOLDS, commands = COMMANDS)
      case parser
      when :optparse
        self.parse_optparse(args, thresholds, commands)
      when :quickl
        self.parse_quickl(args, thresholds, commands)
      when :trollop
        self.parse_trollop(args, thresholds, commands)
      end
    end

    def self.parse_optparse(args = ARGV, thresholds, commands)
      MainOptParse.parse(args, thresholds, commands)
    end

    def self.parse_quickl(args = ARGV, thresholds, commands)
      MainQuickl.parse(args, thresholds, commands)
    end

    def self.parse_trollop(args = ARGV, thresholds, commands)
      MainTrollop.parse(args, thresholds, commands)
    end

    def self.run(args = ARGV.clone)
      puts parse(args)
    end
  end
end
