set :application, "accelerant"
set :user, "chazzer"
set :admin_runner, "chazzer"
set :port, 30000
#set :repository,  "set your repository location here"
set :deploy_to, "/home/chazzer/public_html/#{application}"
 
default_run_options[:pty] = true
#set :repository,  "git://github.com/chazzerguy/Accelerant.git"
set :repository,  "git@github.com:silvanito/Accelerant.git"
 
 
# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
# set :deploy_to, "/var/www/#{application}"
 
# If you aren't using Subversion to manage your source code, specify
# your SCM below:

set :scm, "git"
set :branch, "blognog2-silvano"
#ssh_options[:forward_agent] = true
#set :user, "chazzer@Accelerant"  # The server's user for deploys
#set :scm_passphrase, "At0m1cD0g"  # The deploy user's password
set :deploy_via, :remote_cache
#set :scm_command, "usr/lib/ruby/gems/1.8/gems/git-1.0.5/lib/git/"
 
set :location, "67.23.9.5"
 
role :app, location
role :web, location
role :db,  location, :primary => true

after 'deploy:update_code', 'bundler:bundle_new_release'
after "bundler:bundle_new_release", "deploy:update_crontab"

namespace :deploy do
  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end
 
  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end

  desc "Update the crontab file"
  task :update_crontab, :roles => :db do
    run "cd #{release_path} && whenever --update-crontab #{application}"
  end
end

namespace :bundler do
  task :create_symlink, :roles => :app do
    shared_dir = File.join(shared_path, 'bundle')
    release_dir = File.join(current_release, '.bundle')
    run("mkdir -p #{shared_dir} && ln -s #{shared_dir} #{release_dir}")
  end
 
  task :bundle_new_release, :roles => :app do
    bundler.create_symlink
    run "cd #{release_path} && bundle update"
  end
end

