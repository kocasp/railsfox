# Define roles, user and IP address of deployment server
# role :name, %{[user]@[IP adde.]}
# server '164.132.110.218', roles: [:web, :app, :db], primary: true, port: 4321

# set :repo_url,        'git@bitbucket.org:kocasp/letters.git'
# set :application,     'letters'
# set :user,            'deploy'

# # SSH Options
# # See the example commented out section in the file
# # for more options.
# set :ssh_options, {
#     forward_agent: false,
#     # auth_methods: %w(password),
#     # password: '',
#     user: 'deploy',
# }

# set :puma_threads,    [4, 16]
# set :puma_workers,    0

# # Don't change these unless you know what you're doing
# set :pty,             true
# set :use_sudo,        false
# set :stage,           :production
# set :deploy_via,      :remote_cache
# set :deploy_to,       "/home/#{fetch(:user)}/apps/#{fetch(:application)}"
# set :puma_bind,       "unix://#{shared_path}/tmp/sockets/#{fetch(:application)}-puma.sock"
# set :puma_state,      "#{shared_path}/tmp/pids/puma.state"
# set :puma_pid,        "#{shared_path}/tmp/pids/puma.pid"
# set :puma_access_log, "#{release_path}/log/puma.error.log"
# set :puma_error_log,  "#{release_path}/log/puma.access.log"
# set :puma_preload_app, true
# set :puma_worker_timeout, nil
# set :puma_init_active_record, true  # Change to false when not using ActiveRecord


require 'bundler/capistrano'
require 'capistrano-unicorn'
require 'capistrano/sidekiq'

load 'config/deploy/symlinks'

role :app, '145.239.80.138'
role :web, '145.239.80.138'
role :db,  '145.239.80.138', :primary => true

set :application, 'pkpfox'
set :rails_env, 'production'
set :database, 'app_production'
set :branch, 'master'
set :all_symlinks, {
  'config/database.yml' => 'config/database.yml',
  'config/sidekiq.yml' => 'config/sidekiq.yml',
  'config/unicorn.rb' => 'config/unicorn.rb',
  'config/settings.local.yml' => 'config/settings.local.yml',
  'exports' => 'exports',
}
set :default_shell, '/bin/bash -l'
set :user, 'deploy'
set :runner, 'deploy'
set :deploy_to, "/home/#{user}/apps/#{application}"
set :scm, 'git'
set :use_sudo, false
set :deploy_via, :remote_cache
set :repository, 'git@bitbucket.org:kocasp/pkpfox.git'
set :repository_cache, 'git_cache'
set :ssh_options, { :forward_agent => true }

set :unicorn_pid, '/home/deploy/apps/pkpfox/shared/pids/unicorn.pid'
set :sidekiq_config, '/home/deploy/apps/pkpfox/shared/config/sidekiq.yml'

default_run_options[:pty] = true
# before 'deploy:update_code', 'thinking_sphinx:stop'
# after  'deploy:update_code', 'thinking_sphinx:index'
# after  'deploy:update_code', 'thinking_sphinx:start'
after  'deploy:restart', 'unicorn:restart'

load 'deploy/assets'
