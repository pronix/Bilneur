require 'bundler/capistrano'
require 'thinking_sphinx/deploy/capistrano'
require 'capistrano/ext/multistage'

set :stages, %w(dev prod)
set :default_stage, "dev"

set :scm, :git
set :application, "bilneur"
set :repository,  "git@github.com:pronix/Bilneur.git"

set :deploy_via, :remote_cache
set :use_sudo, false


set :spinner, false
set :deploy_via, :remote_cache
set :keep_releases, 3

set :bundle_flags,       "--quiet"


