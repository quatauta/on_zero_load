# -*- coding: utf-8; -*-
# frozen_string_literal: true
# vim:set fileencoding=utf-8:

desc 'Run test:default'
task default: 'test:default'

namespace :doc do
  begin
    require 'rdoc/task'

    task clobber: :clobber_rdoc
    Rake::RDocTask.new(:rdoc) do |task|
      task.rdoc_files.include('bin/**/*.rb', 'lib/**/*.rb', 'doc/*.md')
      task.rdoc_dir = 'doc/rdoc'
      task.options << '--all'
      task.options << '--charset=utf-8'
      task.options << '--hyperlink-all'
      task.options << '--inline-source'
      task.options << '--show-hash'
    end
  rescue LoadError
    true # ignore missing rdoc
  end
end

namespace :doc do
  begin
    require 'yard'
    YARD::Rake::YardocTask.new
  rescue LoadError
    true # ignore missing yard
  end
end

namespace :gem do
  begin
    require 'bundler/audit/cli'

    desc 'Check for vulnerable gem dependencies'
    task :audit do
      %w(update check).each do |command|
        Bundler::Audit::CLI.start([command])
      end
    end

    Rake::Task[:default].enhance(['gem:audit'])
  rescue LoadError
    true # ignore missing bundler
  end
end

namespace :gem do
  begin
    require 'bundler/gem_tasks'
  rescue LoadError
    true # ignore missing bundler
  end
end

namespace :gem do
  begin
    require 'rubinjam'

    desc 'Jam script in bin/ incl dependencies into script in pkg/'
    task :jam do
      dir = 'pkg'
      name, content = Rubinjam.pack(Dir.pwd)
      script = File.join(dir, name)

      FileUtils.mkdir_p(dir)
      File.open(script, 'w') { |f| f.write content }
      sh("chmod +x #{script}")
    end
  rescue LoadError
    true # ignore missing rubyinjam
  end
end

# metric_fu tasks will be defined in namespace :metrics
begin
  ENV['CC_BUILD_ARTIFACTS'] = 'doc/metrics'
  require 'metric_fu'
rescue LoadError
  true # ignore missing metric_fu
end

namespace :metrics do
  begin
    require 'rubocop/rake_task'
    RuboCop::RakeTask.new(:rubocop) do |task|
      task.patterns = ['Rakefile', 'bin/**/*.rb', 'config/**.rb', 'lib/**/*.rb']
      task.fail_on_error = false
    end
  rescue LoadError
    true # ignore missing rubocop
  end
end

task test: 'test:default'
namespace :test do
  begin
    require 'rspec/core/rake_task.rb'
    RSpec::Core::RakeTask.new
    task default: :spec
  rescue LoadError
    true # ignore missing rspec
  end
end
