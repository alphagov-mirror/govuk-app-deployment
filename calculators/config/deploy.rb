set :application,        "calculators"
set :capfile_dir,        File.expand_path('../', File.dirname(__FILE__))
set :server_class,       "calculators_frontend"

load 'defaults'
load 'ruby'

load 'deploy/assets'
set :assets_prefix, 'calculators'

set :db_config_file, false
set :rails_env, 'production'
set :source_db_config_file, false

after "deploy:symlink", "deploy:publishing_api:publish"
after "deploy:notify", "deploy:notify:error_tracker"
