# Look in the tasks/setup.rb file for the various options that can be
# configured in this Rakefile. The .rake files in the tasks directory
# are where the options are used.

load 'tasks/setup.rb'

ensure_in_path 'lib'
require 'on_zero_load'

task :default => 'bzr:changelog'
task :default => 'whitespace:check'
task :default => 'spec:run'

PROJ.name           = 'on_zero_load'
PROJ.authors        = OnZeroLoad.authors.join(", ")
PROJ.email          = OnZeroLoad.authors(:email).join(", ")
PROJ.version        = OnZeroLoad.version
PROJ.url            = OnZeroLoad.homepage
PROJ.rubyforge_name = 'on_zero_load'

depend_on 'main'
depend_on 'ruby-units'

PROJ.bzr           = true
PROJ.changelog     = "Changelog.txt"
PROJ.exclude      << '^\.bzr\/'
PROJ.exclude      << '^\.bzrignore$'
PROJ.rdoc_exclude << '\.diff$'
PROJ.rdoc_opts     = [ '--all',
                       '--charset', 'utf-8',
                       '--inline-source',
                       '--line-numbers',
                       '--promiscuous',
                       '--show-hash' ]
PROJ.rdoc_template = 'vendor/jamis/jamis'
PROJ.spec_opts    << '--color'

# EOF
