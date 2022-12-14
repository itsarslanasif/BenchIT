set :rvm_type, :system
set :rvm_ruby_version, 'ruby-3.0.4'

set :repo_url,        'git@github.com:yoarslan/BenchIT.git'
set :application,     'benchit'
set :user,            'deployer'

# Don't change these unless you know what you're doing
set :pty,             true
set :use_sudo,        true
set :stage,           :staging
set :deploy_via,      :remote_cache
set :deploy_to,       "/var/www/#{fetch(:application)}"
# set :default_shell,   '/bin/bash -l'

set :log_level, :debug

## Linked Files & Directories (Default None):
set :linked_files, %w{config/application.yml}
set :linked_dirs,  %w{config/credentials log tmp/pids tmp/cache tmp/sockets vendor/bundle node_modules}

namespace :deploy do
  desc "Restart Puma"
  task :restart_puma do
    on roles(:app), in: :sequence, wait: 5 do
      # execute :sudo, :systemctl, :restart, 'puma-website'
    end
  end

  # after  :finishing,    :restart_puma
  # after  :finishing,    :restart_sidekiq
end

# https://medium.com/@KerrySheldon/ec2-exercise-1-6-deploy-a-rails-app-to-an-ec2-instance-using-capistrano-3485238e4a4a
# ssh-keygen -t rsa -C "adan.sarfraz@devsinc.com"
