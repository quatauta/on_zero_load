# Cleanup RDoc stylesheet

if Rake::Task.task_defined?('doc/index.html')
  Rake::Task['doc/index.html'].enhance do
    families = [ "Arial",
                 "Courier( New)?",
                 "(Bitstream Vera|DejaVu) Sans Mono",
                 "Georgia",
                 "Helvetica",
                 "Lucida Grande",
                 "Monaco",
                 "Verdana" ].sort.uniq
    re    = Regexp.new("['\"]?(%s)['\"]?[[:space:]]*,?[[:space:]]*" % families.join('|'), true)
    expr  = '$_.gsub!(/%s/, "")' % re
    cmd   = %w(ruby -p -i -e) << expr
    files = Dir.glob('doc/*.css')

    unless files.empty?
      system(*cmd + files)
      puts "Removed font families from %s" % files.join(", ")
    end
  end
end
