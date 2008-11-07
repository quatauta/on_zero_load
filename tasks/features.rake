require 'cucumber'
require 'cucumber/rake/task'

desc 'Alias to features:run'
task :features => 'features:run'

namespace :features do
  Cucumber::Rake::Task.new(:run) do |t|
    t.cucumber_opts = "--format progress"
  end

  Cucumber::Rake::Task.new(:verbose,
                           "Pretty print Features with Cucumber") do |t|
    t.cucumber_opts = "--format pretty"
  end
end
