require 'set'

desc "Alias to whitespace:warn"
task :whitespace => ["whitespace:warn"]

namespace :whitespace do
  desc "List files with tabs or trailing whitespace"
  task :warn do
    warnings = {}

    SPEC.files.reject { |n|
      /(Changelog)|(\.diff$)/i =~ n
    } .each do |name|
      warnings[name] = SortedSet.new

      open(name, "r") do |file|
        while (!file.eof?)
          line = file.gets.chomp

          warnings[name] << "spaces" if (/\s+$/ =~ line && /^\s*#/ !~ line)
          warnings[name] << "tabs"   if /\t/ =~ line
        end
      end

      warnings.delete(name) if warnings[name].empty?
    end

    unless warnings.empty?
      max_name_length = warnings.keys.max { |a, b| a.length <=> b.length }.length

      warnings.sort.each do |name, warn|
        puts(sprintf("%-#{max_name_length + 1}s %s",
                     name + ":",
                     warn.to_a.join(", ")))
      end
    end
  end
end
