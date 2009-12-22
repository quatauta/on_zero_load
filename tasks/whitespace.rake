require 'set'

class Array
  def join2(sep = $,, last_sep = nil)
    if last_sep && 1 < self.size
      self[0..-2].join(sep) + last_sep + self[-1]
    else
      self.join(sep)
    end
  end
end

desc "Alias to whitespace:check"
task :whitespace => "whitespace:check"

namespace :whitespace do
  violations = {
    "tabs" => {
      :expr => /\t/,
      :excl => /(^Changelog)|(\.diff$)/,
    },
    "trailing spaces" => {
      :expr     => /\s+$/,
      :neg_expr => /^\s*#/,
    },
  }

  desc "List files with " + violations.keys.sort.join2(", ", " or ")
  task :check do
    files = {}

    Bones.config.gem.files.each do |name|
      files[name] = {}
      linenum     = 0

      open(name, "r") do |file|
        while (!file.eof?)
          line    = file.gets.chomp
          linenum = linenum.next

          violations.each do |n, v|
            next if v[:excl] =~ name

            if v[:expr] =~ line && v[:neg_expr] !~ line
              (files[name][n] ||= []) << linenum
            end
          end
        end
      end

      files.delete(name) if files[name].empty?
    end

    unless files.empty?
      pad_to = files.keys.max { |a, b| a.length <=> b.length }.length

      files.sort.each do |name, vs|
        puts(sprintf("%-*s %s",
                     pad_to + 1,
                     name + ":",
                     vs.sort.map { |v, ls|
                       "#{v} (line #{ls.join(", ")})"
                     }.join(", ")))
      end
    end
  end
end
