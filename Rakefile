# Look in the tasks/setup.rb file for the various options that can be
# configured in this Rakefile. The .rake files in the tasks directory
# are where the options are used.

load 'tasks/setup.rb'

ensure_in_path 'lib'
require 'on_zero_load'

task :default => 'spec:run'

PROJ.name           = 'on_zero_load'
PROJ.authors        = OnZeroLoad.authors.join(", ")
PROJ.email          = OnZeroLoad.emails.join(", ")
PROJ.version        = OnZeroLoad.version
PROJ.url            = 'FIXME (project homepage)'
PROJ.rubyforge_name = 'on_zero_load'

PROJ.spec_opts << '--color'

# EOF
