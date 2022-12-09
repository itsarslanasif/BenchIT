#app
server '35.183.167.106', user: 'deploy', roles: %w{app db web sidekiq cronjobs}

set :branch, 'deployment'
set :rvm_type, :system
set :deploy_to, '/var/www/benchit'
set :stage, :staging
set :rails_env, 'staging'

namespace :deploy do
  desc "Restart sidekiq"
  task :restart_sidekiq do
    on roles(:sidekiq), in: :sequence, wait: 5 do
    #   execute :sudo, :systemctl, :restart, 'sidekiq-worker'
    end
  end
end