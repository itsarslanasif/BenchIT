Ruby 3.0.4

Node 16.10

bundle install

yarn install

rails db:create

rails db:reset

foreman start -f Procfile.dev

# Chatwoot Project SetUp

## Git Clone with personal access token

* Go to your github account , Click your profile photo, then click Settings

* In the left sidebar, at the bottom click Developer settings
* In the left sidebar, at the bottom click Personal access tokens
* Click token classic
* Click Generate new token (classic)
* Give your token a descriptive name , expiry date and scopes
* Generate token
* Copy token and save

### Go to terminal

* git clone https://github.com/arslan-asif-se/BenchIT.git
* Username :your github user name
* Passward : paste the above copied token and press enter


## Git Clone with SSH key

* Go to your github account , click your profile photo, then click Settings
* In the left sidebar , click on SSH and GPG key
* If there is no SSH key associated with your account

### Go to terminal

* ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
* cat ~/.ssh/id_rsa.pub
* copy public key
* Go to your repo , click on code , click on ssh and add this copied public key

#### Go to terminal

* git clone git@github.com:arslan-asif-se/BenchIT.git

## Open project In vs Code

* rvm install "ruby-3.0.4"
* rvm use 3.0.4
* if (RVM is not a function , selecting rubies with 'rvm use ...' will not work.) then use
* bash –login.
* rvm use 3.0.4
* nvm install 16.10.0
* nvm use 16.10.0
* bundle install
* ruby -v (must be 3.0.4)
*  rails -v (must be 6.1.6.1)
* node -v (must be 16.10.0)
* yarn install
* rails db:create

### Errors

*   fe_sendauth: no password supplied
* Couldn't create 'chatwoot_dev' database. Please check your configuration.
rails aborted!
* ActiveRecord::ConnectionNotEstablished: fe_sendauth: no password supplied
* Caused by: PG::ConnectionBad: fe_sendauth: no password supplied

#### Go to project database.yml

* In development password will be empty you have to set it
* In test password will be empty you have to set it

##### Set your database

* Go to terminal
* sudo -u postgres psql
* ALTER USER postgres WITH PASSWORD 'postgres'; // this is will work only if you have an existing database name postgres

##### If postgres database not exist

* sudo -u postgres psql with
* create a databse (name) postgres and (password) also postgres .

##### Set your project database.yml

* In database.yml

*    development:
<<: *default
database: <%= ENV.fetch('POSTGRES_DATABASE', 'chatwoot_dev') %>
username: <%= ENV.fetch('POSTGRES_USERNAME', 'postgres') %>
password: <%= ENV.fetch('POSTGRES_PASSWORD', 'postgres') %> //this is line you have to set passward

* test:
<<: *default
database: <%= ENV.fetch('POSTGRES_DATABASE', 'chatwoot_test') %>
username: <%= ENV.fetch('POSTGRES_USERNAME', 'postgres') %>
password: <%= ENV.fetch('POSTGRES_PASSWORD', 'postgres') %> //this is line you have to set passward

## Create Database

* rails db:create
* rails db:reset
* bundle exec rails webpacker:compile
* foreman start -f Procfile.dev
* http://localhost:3000/app/login
* email: john@acme.inc
* password: Password1!



