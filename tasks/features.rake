require 'cucumber/rake/task'

desc 'Alias to features:run'
task :features => 'features:run'

namespace :features do
  Cucumber::Rake::Task.new(:run) do |t|
    t.cucumber_opts = "--format progress"
  end

  Cucumber::Rake::Task.new(:verbose,
                           "Pretty print features with cucumber") do |t|
    t.cucumber_opts = "--format pretty"
  end

  Cucumber::Rake::Task.new(:rcov, "Run features with rcov") do |t|
    t.rcov = true
  end
end
