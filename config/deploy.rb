# govcms drupal site
set :app_name, "govcms"
set :location, "#{app_name}.qa.previousnext.com.au"
set :application, "#{app_name}.qa.previousnext.com.au"
set :repository,  "git@github.com:previousnext/#{app_name}.git"
set :user, "deployer"
set :runner, "deployer"
set :branch, "master"
set :port, 2222
# set :git_enable_submodules, 1
ssh_options[:forward_agent] = true
if ENV["PNX_SSH_KEY"] != ""
  ssh_options[:keys] = ENV["PNX_SSH_KEY"]
end
set :default_stage, "dev"

before("deploy:cleanup") { set :use_sudo, false }
before("deploy:create_symlink") { set :use_sudo, false }
after "deploy", "deploy:cleanup"
after "deploy", "drush:features_revert_all"
after "deploy", "drush:cache_clear"

namespace :drush do
  desc "Revert all features"
  task :features_revert_all, :on_error => :continue do
    run "drush -r #{app_path} fr-all -y"
  end
end
