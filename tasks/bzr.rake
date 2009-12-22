HAVE_BZR = Dir.entries(Dir.pwd).include?('.bzr')

if HAVE_BZR
  desc 'Alias to bzr:changelog'
  task 'changelog' => 'bzr:changelog'

  task 'gem:release' => 'bzr:create_tag'

  namespace :bzr do
    desc 'Show tags of this branch'
    task :show_tags do |t|
      tags = %x{bzr tags}
      puts tags
    end

    desc 'Create a new tag in this branch'
    task :create_tag do |t|
      v = ENV['VERSION'] or abort 'Must supply VERSION=x.y.z'
      abort "Versions don't match #{v} vs #{Bones.config.version}" if v != Bones.config.version

      tag = "%s-%s" % [Bones.config.name, Bones.config.version]

      puts "Creating bzr tag '#{tag}'"
      unless system("bzr tag #{tag}")
        abort "Tag creation failed"
      end
    end

    desc "Write bzr changelog to file #{Bones.config.changelog}"
    task :changelog => [Bones.config.changelog]
    file Bones.config.changelog => [".bzr/branch/last-revision"] do |t|
      ["gnu", "long"].each do |f|
        sh("bzr log --log-format=#{f} --verbose >#{t.name}") do |ok, result|
        end

        break if 0 == $?
      end
    end
  end
end
