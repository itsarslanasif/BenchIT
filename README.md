# Bench-it: Project Setup

Bentch-it is a new way to communicate with your team. It's faster, better organized, and more secure than email.
## Tech Stack

**Stack**
- VueJS
- Ruby 3.0.4
- Ruby on Rails 6.1
- Postgresql
- Application Server: Puma
- Node 16.10

**Test Cases**
- N/A


## Installation

Before runing this project locally your Device must have
- Ruby 3.0.4
- Postgres
- Node 16.10
- Yarn
- git
installed in it.
## Run Locally

### Step 1:
Setup repo access via SSH or Personal Access Token, go to the project directory

### Step 2
Install and use nvm

    nvm install 16.10.0
    nvm use 16.10.0

### Step 3
Run bundle

    bundle install

### Step 4
Then run compile assets using yarn

    yarn install

### Step 5
Setup database credentials in `database.yml` and rum migration

    rails db:create
    rails db:migrate

OR we can do this in a single command

    rails db:create db:migrate

To add dummy data run seed file

    rails db:create db:migrate

### Step 6

For webpacker

    bundle exec rails webpacker:compile

#### Step 7

Run the project with foreman

    foreman start -f Procfile.dev


To get visual display of your project open any browser and visit [BenchIt](http://localhost:3000/app/login)
