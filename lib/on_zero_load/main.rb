require 'main'
require 'on_zero_load/ext/main/cast'
require 'on_zero_load/ext/main/parameter-fix-15720'


module OnZeroLoad
  class Main
    def self.run(argv = ARGV)
      main(argv) do
        author      OnZeroLoad.authors(:name_email)
        version     OnZeroLoad.version
        description "Description goes here"

        usage["bugs"] = "What about bugs?"

        argument "command" do
          description "The command to execute after the values dropped " \
                      "below the defined limits. To supply a command with " \
                      "options, give #{File.basename($0)}'s options " \
                      "first and separate them from the command's name " \
                      "and options using two dashes (\"--\"), " \
                      "e.g. \"on-zero-load -l 0.2 -- beep -r 5\"."
          arity -1
        end

        option "cpu=[N]", "c" do
          description "CPU-usage limit in percents, 0 <= N <= 100."
          arity -1
          cast :number
          default 0
          validate { |n| 0 <= n && n <= 100 }
        end

        option "disk=[N]", "d" do
          description "Bytes/second read from or written to disk, 0 <= N."
          arity -1
          cast :byte_per_sec
          default "0 Kib/s"
          validate { |n| 0 <= n }
        end

        option "load=[N]", "l" do
          description "Loadavg of one, five or fifteen minutes. " \
                      "Format: <N>:[one*,five,fifteen], 0 <= N: " \
                      "0.32, 0.41:one, 0.1:five, 0.8:fifteen"
          arity -1
          cast :loadavg
          default "0.0:one"
        end

        option "net=[N]", "n" do
          description "Bytes/second received or tranmitted through "\
                      "net interface, 0 <= N."
          arity -1
          cast :byte_per_sec
          default "0 Kib/s"
          validate { |n| 0 <= n }
        end

        option "sleep=N", "s" do
          description "Seconds to sleep beween each sample, 0 < N."
          cast :number
          default 60.0
          validate { |n| 0 < n }
        end

        option "samples=N", "S" do
          description "Number of samples that must be below the limits, 1 <= N."
          cast :integer
          default 1
          validate { |n| 1 <= n }
        end

        option "dry-run", "D", "N" do
          description "Only print the command, do not execute it."
        end

        option "verbose", "V" do
          description "Print the samples each time they a taken."
        end

        option "version", "v" do
          description "Only print the version of the script and exit."
        end

        def run
          param[:command].values += ARGV

          if (params[:version].given? && params[:version].value)
            puts "This is #{File.basename($0)} version #{version()}."
            return
          end

          params.each do |p|
            puts(sprintf("  --%-9s %3s given: %s",
                         p.name,
                         p.given? ? "" : "not",
                         p.values.inspect))
          end
        end
      end
    end
  end
end
