set :application, "manuals-publisher"
set :capfile_dir, File.expand_path('../', File.dirname(__FILE__))
set :server_class, "backend"
set :run_migrations_by_default, true

load 'defaults'
load 'ruby'
load 'deploy/assets'
load 'govuk_admin_template'

after "deploy:restart", "deploy:restart_procfile_worker"
