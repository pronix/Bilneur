require 'bundler/capistrano'
require 'thinking_sphinx/deploy/capistrano'

# require "delayed/recipes"

# set :whenever_command, "bundle exec whenever"
# require "whenever/capistrano"

set :application, "bilneur"
set :repository,  "git@github.com:pronix/Bilneur.git"

set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "bfile.adenin.ru"                          # Your HTTP server, Apache/etc
role :app, "bfile.adenin.ru"                          # This may be the same as your `Web` server
role :db,  "bfile.adenin.ru", :primary => true # This is where Rails migrations will run
role :db,  "bfile.adenin.ru"

set :deploy_to, "/var/www/#{application}"

set :rails_env, "production"

set :deploy_via, :remote_cache
set :use_sudo, false
set :ssh_options, {:forward_agent => true, :port => 6022 }
set :branch, "master"
set :user, "root"


set :spinner, false
set :deploy_via, :remote_cache
set :keep_releases, 3

set :bundle_flags,       "--quiet"



after  "deploy:update",  "deploy:migrate"
after  "deploy:migrate", "deploy:chown_apache"
before "deploy:migrate", "deploy:symlink_database"
after  "deploy:symlink", "deploy:symlink_image"
after  "deploy:update", "deploy:cleanup"

# before "deploy:restart", "delayed_job:stop"
# after  "deploy:restart", "delayed_job:start"

# after "deploy:stop",  "delayed_job:stop"
# after "deploy:start", "delayed_job:start"


namespace :deploy do

  desc "Restarting passenger with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end

  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with passenger"
    task t, :roles => :app do ; end
  end

  task :symlink_database do
    run "ln -nfs #{shared_path}/config/database.yml #{latest_release}/config/database.yml "
    run "ln -nfs #{shared_path}/db/production.sqlite3 #{latest_release}/db/production.sqlite3 "
    run "ln -nfs #{shared_path}/db/schema.rb #{latest_release}/db/schema.rb "
  end

  task :chown_apache do
    run "chown -R nginx:nginx #{current_path}/"
  end

  desc "Symlink the images"
  task :symlink_image, :roles => :app do
    %w(assets).each do |share_folder|
      run "cd #{current_path}/public; rm -rf #{share_folder}; ln -s #{shared_path}/#{share_folder} ."
    end
  end

  desc "Populates the database with seed data"
  task :seed do
    run "cd #{current_path}; RAILS_ENV=production bundle exec rake db:seed"
  end

  desc "Populates the database with sample data"
  task :sample do
    run "cd #{current_path}; AUTO_ACCEPT=true RAILS_ENV=production bundle exec rake db:sample"
  end
  task :before_update_code, :roles => [:app] do
    thinking_sphinx.stop
  end

  task :after_update_code, :roles => [:app] do
    # symlink_sphinx_indexes
    thinking_sphinx.configure
    thinking_sphinx.start
  end

end

