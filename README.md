Ruby 3.0.4

Node 16.10

bundle install

yarn install

rails db:create

rails db:reset

foreman start -f Procfile.dev


Clone with personal access token

1. click your profile photo, then click Settings.
    1. In the left sidebar, at the bottom click Developer settings.
    2. In the left sidebar, at the bottom click Personal access tokens.
    3. Click token classic
    4. Click Generate new token (classic).
    5. Give your token a descriptive name , expiry date and scopes .
    6. Generate token
  7.Copy token

Go to terminal
 git clone https://github.com/arslan-asif-se/BenchIT.git
 Username :your github user name
  Passward : paste the above copied token and press enter


Clone with SSH key

1. click your profile photo, then click Settings.
2.In the left sidebar , click on SSH and GPG key .
3. If there is no SSH key then generate a new SSH key.
4. Click on generate a new SSH key and adding it to ssh-agent.
5. Open terminal
6.  ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
7. cat ~/.ssh/id_rsa.pub
8.copy public key
9.Add a public key in your repo.

Go to terminal
 git clone git@github.com:arslan-asif-se/BenchIT.git

Open project In vs Code.
1. rvm install "ruby-3.0.4"
2. rvm use 3.0.4
3. if (RVM is not a function, selecting rubies with 'rvm use ...' will not work.) then use
bash –login.
4.rvm use 3.0.4
5. nvm install 16.10.0
6. nvm use 16.10.0
7.bundle install
8.ruby -v (must be 3.0.4)
9. rails -v(must be 6.1.6.1)
10.node -v(must be 16.10.0)
11.yarn install
12.rails db:create

   fe_sendauth: no password supplied
Couldn't create 'chatwoot_dev' database. Please check your configuration.
rails aborted!
ActiveRecord::ConnectionNotEstablished: fe_sendauth: no password supplied


Caused by:
PG::ConnectionBad: fe_sendauth: no password supplied

13.Go to database.yml

In development password will be empty you have to set it.
In test password will be empty you have to set it.

 You can set you database with these 2 commands for better help
if  you have a database (name)  postgres.
On terminal sudo -u postgres psql
ALTER USER postgres WITH PASSWORD 'postgres';
else
you can creat a database using sudo -u postgres psql with (name) postgres and (password) also postgres .

In database.yml
    development:
<<: *default
database: <%= ENV.fetch('POSTGRES_DATABASE', 'chatwoot_dev') %>
username: <%= ENV.fetch('POSTGRES_USERNAME', 'postgres') %>
password: <%= ENV.fetch('POSTGRES_PASSWORD', 'postgres') %> //this is line you have to set passward

test:
<<: *default
database: <%= ENV.fetch('POSTGRES_DATABASE', 'chatwoot_test') %>
username: <%= ENV.fetch('POSTGRES_USERNAME', 'postgres') %>
password: <%= ENV.fetch('POSTGRES_PASSWORD', 'postgres') %> //this is line you have to set passward



14. rails db:create
15. rails db:reset
16. bundle exec rails webpacker:compile
17. foreman start -f Procfile.dev
18. http://localhost:3000/app/login
   email (john@acme.inc)
   password (Password1!)




