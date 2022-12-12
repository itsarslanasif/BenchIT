#app
server '65.1.194.133', user: 'deployer', roles: %w{app db web sidekiq cronjobs}

set :branch,          'deployment'
set :rvm_type,        :user
set :deploy_to,       '/var/www/benchit'
set :stage,           :staging
set :rails_env,       'staging'

namespace :deploy do
  desc "Restart sidekiq"
  task :restart_sidekiq do
    on roles(:sidekiq), in: :sequence, wait: 5 do
    #   execute :sudo, :systemctl, :restart, 'sidekiq-worker'
    end
  end
end