# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

   - 2.7.4
    - rails 5.2.6

* System dependencies

  - gem 'jsonapi-serializer'
  - gem 'pry'
  - gem 'rspec-rails'
  - gem 'factory_bot_rails'
  - gem 'faker'
  - gem 'simplecov', require: false
  - gem 'shoulda-matchers'

* Configuration

* Database creation

* Database initialization

  - rails db:{drop,create,migrate,seed}
  - rails db:schema:dump

* How to run the test suite
   - bundle exec rspec

* Services (job queues, cache servers, search engines, etc.)

  - rails server

* Deployment instructions

  - run bundle install

* API end points

  - All merchants - http://localhost:3000/api/v1/merchants
  - One merchant - http://localhost:3000/api/v1/merchants/{{merchant_id}}
  - Find merchant by name - http://localhost:3000/api/v1/merchants/find?name={{name}}
  - Merchant items - http://localhost:3000/api/v1/merchants/{{merchant_id}}/items
  - All tems - http://localhost:3000/api/v1/items
  - One item - http://localhost:3000/api/v1/items/{{item_id}}
  - Create item - POST 'http://localhost:3000/api/v1/items'
  - Update item - PATCH 'http://localhost:3000/api/v1/items'
  - Delete item - DELETE 'http://localhost:3000/api/v1/items/{{item_id}}'
  - Find all items by name - http://localhost:3000/api/v1/items/find_all?name={{name}}
  - Item merchant - http://localhost:3000/api/v1/items/{{item_id}}/merchant
