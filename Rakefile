# Look in the tasks/setup.rb file for the various options that can be
# configured in this Rakefile. The .rake files in the tasks directory
# are where the options are used.

begin
  require 'bones'
  Bones.setup
rescue LoadError
  load 'tasks/setup.rb'
end

ensure_in_path 'lib'
require 'on_zero_load'

desc "Update changelog, check whitespace, run specs"
task :default => 'bzr:changelog'
task :default => 'whitespace:check'
task :default => 'spec:run'
task :default => 'features:run'

PROJ.name           = 'on_zero_load'
PROJ.authors        = OnZeroLoad.authors.join(", ")
PROJ.email          = OnZeroLoad.authors(:email).join(", ")
PROJ.version        = OnZeroLoad.version
PROJ.url            = OnZeroLoad.homepage
PROJ.rubyforge.name = 'on_zero_load'

depend_on 'RubyInline', '>= 3.8'
depend_on 'trollop', '>= 1.10'

PROJ.gem.executables = ['on_zero_load']
PROJ.gem.development_dependencies << ['bones', ">= 2.2.0"]
PROJ.gem.development_dependencies << ['cucumber', ">= 0.1.8"]
PROJ.gem.development_dependencies << ['rake', ">= 0.8.3"]
PROJ.gem.development_dependencies << ['rspec', ">= 1.1.11"]

PROJ.bzr           = true
PROJ.changelog     = "Changelog.txt"
PROJ.exclude      << '^\.bzr\/'
PROJ.exclude      << '^\.bzrignore$'
PROJ.exclude      << '^\.shelf\/'
PROJ.exclude      << '^coverage/'
PROJ.exclude      << '^ri/'
PROJ.rdoc.exclude << '\.diff$'
PROJ.rdoc.opts     = [ '--all',
                       '--charset=utf-8',
                       '--inline-source',
                       '--line-numbers',
                       '--promiscuous',
                       '--show-hash' ]
PROJ.rdoc.template = 'hanna'
PROJ.ruby_opts     = [ '-Ku' ]
PROJ.spec.opts    << '--color'
