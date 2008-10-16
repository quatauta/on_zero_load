HAVE_BZR = Dir.entries(Dir.pwd).include?('.bzr') &&
           system("bzr --version 2>&1 > #{DEV_NULL}")

if HAVE_BZR
  namespace :bzr do
    desc 'Show tags of this branch'
    task :show_tags do |t|
      tags = %x{bzr tags}
      puts tags
    end

    desc 'Create a new tag in this branch'
    task :create_tag do |t|
      v = ENV['VERSION'] or abort 'Must supply VERSION=x.y.z'
      abort "Versions don't match #{v} vs #{PROJ.version}" if v != PROJ.version

      tag = "%s-%s" % [PROJ.name, PROJ.version]

      puts "Creating bzr tag '#{tag}'"
      unless system("bzr tag #{tag}")
        abort "Tag creation failed"
      end
    end

    desc "Write bzr changelog to file #{PROJ.changelog}"
    task :changelog => [PROJ.changelog]
    file PROJ.changelog => [".bzr/branch/last-revision"] do |t|
      ["gnu", "long"].each do |f|
        sh("bzr log --log-format=#{f} --verbose >#{t.name}") do |ok, result|
        end

        break if 0 == $?
      end
    end
  end

  desc 'Alias to bzr:changelog'
  task 'changelog' => 'bzr:changelog'

  task 'gem:release' => 'bzr:create_tag'
end
