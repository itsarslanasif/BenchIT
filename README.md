upgrade ruby using rvm
upgrade node using nvm
bundle install
yarn install
delete node modules
rvm gemset empty
bundle install
yarn install
update password in config/database.yml
rails db:create
rails db:reset (optional)
bundle exec rails webpacker:compile
foreman start -f Procfile.dev
