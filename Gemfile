source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gem 'bootsnap', require: false
gem 'brakeman'
gem 'bundler-audit'
gem 'cancancan'
gem 'devise'
gem 'devise_invitable'
gem 'devise-jwt'
gem 'dotenv-rails'
gem 'elasticsearch', '~> 7.0'
gem 'foreman'
gem 'jbuilder'
gem 'kaminari'
gem 'pagy'
gem 'pg'
gem 'puma', '~> 5.0'
gem 'rack-cors'
gem 'rails', '~> 7.0.2'
gem 'ransack'
gem 'redis', '~> 4.0'
gem 'redis-namespace'
gem 'route_translator'
gem 'sassc-rails'
gem 'searchkick'
gem 'sidekiq', '~>6.0'
gem 'sprockets-rails'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
gem 'vite_rails'
gem 'ed25519'
gem 'bcrypt_pbkdf'

group :development, :test do
  gem 'debug', platforms: %i[mri mingw x64_mingw]
end

group :development do
  gem 'capistrano'
  gem 'capistrano-rvm'
  gem 'capistrano-rails'
  gem 'capistrano-bundler'
  gem 'capistrano3-puma'
  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
  gem 'spring'
  gem 'web-console'
end

group :test do
  gem 'capybara'
  gem 'capybara-email'
  gem 'json-schema'
  gem 'minitest'
  gem 'minitest-focus'
  gem 'minitest-matchers'
  gem 'minitest-metadata'
  gem 'minitest-profiler'
  gem 'minitest-rails'
  gem 'selenium-webdriver'
  gem 'warden'
  gem 'webdrivers'
end

group :production do
  gem 'aws-sdk-s3', require: false
end
