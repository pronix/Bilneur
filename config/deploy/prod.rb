set :ssh_options, {:forward_agent => true }
set :default_environment, {
  'PATH' => "/usr/local/rvm/gems/ree-1.8.7-2011.03/bin:/usr/local/rvm/bin:$PATH",
  'GEM_HOME'     => '/usr/local/rvm/gems/ree-1.8.7-2011.03',
  'GEM_PATH'     => '/usr/local/rvm/gems/ree-1.8.7-2011.03',
  'BUNDLE_PATH'  => '/usr/local/rvm/gems/ree-1.8.7-2011.03/bin'
}


role :web, "50.57.79.164"
role :app, "50.57.79.164"
role :db,  "50.57.79.164", :primary => true
role :db,  "50.57.79.164"

set :deploy_to, "/var/www/#{application}"

set :rails_env, "production"

set :branch, "master"
set :user, "root"

set :sphinx_role, :app

after  "deploy:update",  "deploy:migrate"
after  "deploy:migrate", "deploy:chown_apache"
before "deploy:migrate", "deploy:symlink_database"
after  "deploy:symlink", "deploy:symlink_image"
after  "deploy:update", "deploy:cleanup"


after "deploy:restart",          "thinking_sphinx:restart"
after "thinking_sphinx:start",   "deploy:chown_apache"
after "thinking_sphinx:restart"," deploy:chown_apache"



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
    run "ln -nfs #{shared_path}/db/schema.rb #{latest_release}/db/schema.rb "
  end

  task :chown_apache do
    run "chown -R www-data:www-data #{current_path}/"
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

end


namespace :thinking_sphinx do

  desc "Starts the thinking sphinx searchd server"
  task :start, :roles => sphinx_role do
    puts "Starting thinking sphinx searchd server"
    run "cd #{current_path}; RAILS_ENV=production bundle exec rake thinking_sphinx:configure"
    run "cd #{current_path}; RAILS_ENV=production bundle exec rake ts:start"
  end

  desc "Stops the thinking sphinx searchd server"
  task :stop, :roles => sphinx_role do
    puts "Stopping thinking sphinx searchd server"
    run "cd #{current_path}; RAILS_ENV=production bundle exec rake thinking_sphinx:configure"
    run "cd #{current_path}; RAILS_ENV=production bundle exec rake ts:stop"
  end

  desc "Restarts the thinking sphinx searchd server"
  task :restart, :roles => sphinx_role do
    thinking_sphinx.stop
    thinking_sphinx.index
    thinking_sphinx.start
  end

  desc "Copies the shared/config/sphinx yaml to release/config/"
  task :symlink_config, :roles => :app do
    run "ln -s #{shared_path}/config/sphinx.yml #{release_path}/config/sphinx.yml"
  end

  desc "Displays the thinking sphinx log from the server"
  task :tail, :roles => :app do
    stream "tail -f #{shared_path}/log/searchd.log"
  end

  desc "Runs Thinking Sphinx indexer"
  task :index, :roles => sphinx_role do
    puts "Updating search index"
    run "cd #{current_path}; RAILS_ENV=production bundle exec rake ts:index"
  end
end

