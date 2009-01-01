# Cleanup RDoc stylesheet produced by hanna RDoc template

if 'hanna' == PROJ.rdoc.template && Rake::Task.task_defined?('doc/index.html')
  Rake::Task['doc/index.html'].enhance do
    families = [ "Arial",
                 "Courier( New)?",
                 "(Bitstream Vera|DejaVu) Sans Mono",
                 "Georgia",
                 "Helvetica",
                 "Monaco",
                 "Verdana" ].sort.uniq
    re   = Regexp.new('(%s)[[:space:]]*,?[[:space:]]*' % families.join('|'), true)
    expr = '$_.gsub!(/%s/, "")' % re
    cmd  = %w(ruby -p -i -e) << expr << 'doc/rdoc-style.css'

    system(*cmd)
    puts "Removed font families from doc/rdoc-style.css."
  end
end
