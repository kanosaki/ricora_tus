usage       'deplpy'
aliases     :dep
summary     'Compile and Deploy pages to remote server'
description 'Homuhomu'

flag  :h, :help, 'Show help for this command' do |value, cmd|
  puts "Some help"
  exit 0
end

required :t, :remote, "Specify remote uri"
required :n, :name, "Specify remote name in config.yaml"

run do |opts, args, cmd|
  Nanoc3::CLI::Commands::Compile.call(opts, args, cmd)
  RsyncDeploy.call(opts, args, cmd)
end

class RsyncDeploy < Nanoc3::CLI::Command
  def run
    puts "Deploying site.."
    puts "Target: #{target}"
    permission_modify
    exec_deploy
    puts "Deploy complete"
  end

  def exec_deploy
    system(deploy_command)
  end
  
  def permission_modify
    system("find #{output_root} -type d -exec chmod og+rx {} \\;")
    system("find #{output_root} -type f -exec chmod og+r {} \\;")
  end

  def deploy_command
    "rsync -avzP -e ssh \"./#{output_root}/\" \"#{target}\""
  end

  def output_root
    "./#{site.config[:output_dir]}/"
  end
  def target
    target_from_args || target_from_config
  end

  protected
  def target_from_args
    options[:remote]
  end

  def target_from_config
    cfg = site.config[:deploy]
    name = options.has_key?(:confname) ? options[:confname] : :default
    raise "deploy section wa not found in config.yaml" unless cfg
    raise "The remote named #{name} was not found in config.yaml" unless cfg.has_key?(name)
    raise "Invalid config file structure, 'dst' entry is required at /deploy/#{name}/dst in config.yaml" unless cfg[name].has_key?(:dst)
    cfg[name][:dst]
  end
end
