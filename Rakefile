begin
  require 'bones'
rescue LoadError
  abort '### Please install the "bones" gem ###'
end

ensure_in_path 'lib'
require 'on_zero_load'

desc "Update changelog, check whitespace, run tests, specs and features"
task :default => 'bzr:changelog'
task :default => 'whitespace:check'
task :default => 'spec:run'
task :default => 'features:run'
task 'gem:release' => 'default'

Bones {
  name    'on_zero_load'
  authors 'Daniel Schömer'
  email   'daniel.schoemer@gmx.net'
  url     'https://code.launchpad.net/~daniel-schoemer/+junk/on-zero-load_devel'
  version OnZeroLoad::VERSION

  changelog 'Changelog.txt'

  exclude << '\.bzr/'
  exclude << '\.bzrignore$'
  exclude << '^ri/'
  exclude << '\..*swp$'
  exclude << '\.yardoc$'

  depend_on 'RubyInline', '>= 3.8'
  depend_on 'trollop', '>= 1.10'

  gem.development_dependencies << ['bones', ">= 3.2.0"]
  gem.development_dependencies << ['cucumber', ">= 0.1.8"]
  gem.development_dependencies << ['rake', ">= 0.8.3"]
  gem.development_dependencies << ['rdoc', ">= 2.4"]
  gem.development_dependencies << ['rspec', ">= 1.1.11"]

  gem.executables = ['on_zero_load']

  ignore_file '.bzrignore'

  yard.exclude << '\\.txt$'
}
