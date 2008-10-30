require 'cucumber'
require 'cucumber/rake/task'

desc 'Alias to features:run'
task :features => 'features:run'

namespace :features do
  Cucumber::Rake::Task.new(:run) do |t|
    t.cucumber_opts = "--format pretty"
  end
end
