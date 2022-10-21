release: bundle exec rails db:benchit_prepare
web: bin/rails server -p $PORT -e $RAILS_ENV
worker: bundle exec sidekiq -C config/sidekiq.yml
