set :rvm_type, :user
set :rvm_ruby_version, 'ruby-3.1.2'
# set :rvm_custom_path, '/usr/share/rvm'

set :repo_url,        'git@github.com:yoarslan/BenchIT.git'
set :application,     'benchit'
set :user,            'deployer'

# Don't change these unless you know what you're doing
# set :pty,             true
set :use_sudo,        true
set :stage,           :development
set :deploy_via,      :remote_cache
set :deploy_to,       "/home/#{fetch(:user)}/app/#{fetch(:application)}"

set :log_level,       :debug

## Linked Files & Directories (Default None):
set :linked_files,    %w[.env]
set :linked_dirs,     %w[bin log tmp/pids tmp/cache tmp/sockets vendor/bundle]

# namespace :deploy do
#   desc "Restart Puma"
#   task :restart_puma do
#     on roles(:app), in: :sequence, wait: 5 do
#       execute :sudo, :systemctl, :restart, :puma
#     end
#   end

#   after  :finishing,    :restart_puma
#   after  :finishing,    :restart_sidekiq
# end
