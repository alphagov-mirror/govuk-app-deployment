set :application, "email-alert-service"
set :capfile_dir, File.expand_path("../", File.dirname(__FILE__))
set :server_class, "email_alert_api"
set :perform_hard_restart, true

load "defaults"
load "ruby"

set :copy_exclude, [
  ".git/*",
]
