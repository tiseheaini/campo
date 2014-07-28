require "bundler/capistrano"
require "capistrano-rbenv"
require 'puma/capistrano'

set :application, "campo-h5"
set :repository,  "https://github.com/tiseheaini/campo.git"
#set :repository,  "git@bitbucket.org:tiseheaini/houread.git"
#default_run_options[:shell] = 'zsh'
#default_run_options[:shell] = '/bin/bash --login'
#default_run_options[:shell] = '/bin/bash --l'

set :scm, "git"
set :rbenv_ruby_version, "2.0.0-p451"
#set :rbenv_ruby_version, "2.0.0p451"
set :user, "tiny"
set :deploy_to, "/home/#{user}/#{application}"
set :use_sudo, false
set :ssh_options, { :forward_agent => true }
default_run_options[:pty] = true

#set :rvm_ruby_string,  ENV['GEM_HOME'].gsub(/.*\//,"")
#set :rvm_type, :user

#set :branch, "cartoon-pics-show"
set :branch, "master-h5"
set :deploy_via, :remote_cache
set :git_shallow_clone, 1

# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

#server "192.168.0.104", :web, :app, :db, :primary => true
server "c2qu.com", :web, :app, :db, :primary => true
set :puma_config_file, "config/puma.rb"

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

namespace :deploy do
  #task :start, :roles => :app do
    #run "cd #{deploy_to}/current/; RAILS_ENV=production bundle exec unicorn_rails -c #{unicorn_path} -D"
  #end

  desc "upload qiniu assets"
  task :qiniu_upload, :roles => :app do
    run "cd /home/tiny/script; ./qrsync ./qiniu_conf.json"
  end
  after "deploy:symlink", "deploy:qiniu_upload"

  task :symlink_config, :roles => :app do
    run "ln -s /home/#{user}/script/database.yml #{release_path}/config/database.yml"
    run "ln -s /home/#{user}/script/config.yml #{release_path}/config/config.yml"
    run "ln -s /home/#{user}/script/secrets.yml #{release_path}/config/secrets.yml"
    run "mkdir -p #{shared_path}/public/uploads"
    run "ln -s #{shared_path}/public/uploads #{release_path}/public/uploads"
  end
  after "deploy:finalize_update", "deploy:symlink_config"

end

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end
