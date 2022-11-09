Bentch-it is a new way to communicate with your team. It's faster, better organized, and more secure than email.

## Tech Stack

**Rails + Vite + Vue + Pina + tailwind-css**

- VueJS
- Ruby 3.0.4
- Ruby on Rails 7
- Postgresql
- Application Server: Puma
- Node 16.10


## Component Description


- **Front**
- **I18n** (server side + client side)
- **Forms** (with progress and error handling)
- **Authentication** (Devise)
- **Pagination** (Kaminari)
- **Dynamic search filters** (Ransack)
- **Websockets** (ActionCable)
- **Bootstrap like grid** (using CSS Grid layout)

## Rails 7 Migration

- Webpacker is now replaced by Vite
- Vuex is now replaced by Pinia to handle state management

Nonetheless, a lot of opinions and conventions from the previous version remain valid, you may have a look at the previous code at master branch

Boostrapping the plumbing for basic stuff can take some time, but once you get the basic it's
pretty easy to extend and to get really efficient with Vue + Rails.

## Installation

```
git clone git@github.com:arslan-asif-se/BenchIT.git
cd BenchIT
cp .env.example .env
bundle install
yarn install
bundle exec rails db:create
bundle exec rails db:migrate
bundle exec rails db:seed
```

## Booting the app

```
foreman start
```

Hot Module Reloading (HMR) is enabled by default. If you prefer to turn it off, set "hmr" to false
in /vite.config.ts.
## Running tests

### Rails side

```
rails test
```

### JS side

```
yarn test
```


