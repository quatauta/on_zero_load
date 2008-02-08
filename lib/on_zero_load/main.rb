#!/usr/bin/env ruby

require 'main'
require 'pp'


module OnZeroLoad
  class Main
    def self.run(args)
      Main do
        author OnZeroLoad::AUTHORS.map { |a|
          b = []
          b << a[:name]
          b << "<#{a[:mail]}>" if a[:mail]
          b.compact.join(" ")
        }.join(", ")
        version OnZeroLoad::VERSION[:string]
        description "Description goes here"

        usage["bugs"] = "What about bugs?"

        argument "command" do
          arity -1
          description "The command to execute after the values dropped " \
          "below the defined limits. To supply a command with " \
          "options, give #{File.basename($0)}'s options " \
          "first and separate them from the command's name " \
          "and options using two dashes (\"--\"), " \
          "e.g. \"on-zero-load -l 0.2 -- beep -r 5\"."
        end

        option "cpu=[N]", "c" do
          arity -1
          cast :number
          default 0
          description "CPU-usage limit in percents, 0 <= N <= 100."
          validate { |n| 0 <= n && n <= 100 }
        end

        option "disk=[N]", "d" do
          arity -1
          cast :byte_per_sec
          default "0 Kib/s"
          description "Bytes/second read from or written to disk, 0 <= N."
          validate { |n| 0 <= n }
        end

        option "load=[N]", "l" do
          arity -1
          cast :loadavg
          default "0.0:one"
          description "Loadavg of one, five or fifteen minutes. " \
          "Format: <N>:[one*,five,fifteen], 0 <= N: " \
          "0.32, 0.41:one, 0.1:five, 0.8:fifteen"
        end

        option "net=[N]", "n" do
          arity -1
          cast :byte_per_sec
          default "0 Kib/s"
          description "Bytes/second received or tranmitted through "\
          "net interface, 0 <= N."
          validate { |n| 0 <= n }
        end

        option "sleep=N", "s" do
          cast :number
          default 60.0
          description "Number of seconds to sleep beween each sample, 0 < N."
          validate { |n| 0 < n }
        end

        option "samples=N", "S" do
          cast :integer
          default 1
          description "Number of samples that must be below the limits, 1 <= N."
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

          pp params.map { |p| [ p.name, p.given?, p.values ] }
        end
      end
    end
  end
end