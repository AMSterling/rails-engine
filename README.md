<a name="readme-top"></a>

<!-- PROJECT SHIELDS -->
[![Contributors][contributors-shield]][contributors-url]
[![LinkedIn][linkedin-shield]][linkedin-url]

<br>

<div align="center">

# Rails Engine

[![Rails][Rails]][Rails-url] [![Ruby][Ruby]][Ruby-url] [![RSpec][RSpec]][RSpec-url] [![Atom][Atom]][Atom-url] [![PostgreSQL][PostgreSQL]][PostgreSQL-url] [![Postman][Postman]][Postman-url]

</div>

## Description

Rails Engine is a Backend Service Oriented Architecture application. Front end repo can be found here.

<br>

<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li><a href="#architecture">Architecture</a></li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#gem-documentation">Gem Documentation</a></li>
    <li>
      <a href="#endpoints">Endpoints</a>
      <ul>
        <li><a href="#all-merchants">All Merchants</a></li>
        <li><a href="#one-merchant">One Merchant</a></li>
        <li><a href="#find-merchant-by-name">Find Merchant By Name</a></li>
        <li><a href="#merchant-items">Merchant Items</a></li>
        <li><a href="#all-items">All Items</a></li>
        <li><a href="#one-item">One Item</a></li>
        <li><a href="#create-item">Create Item</a></li>
        <li><a href="#update-item">Update Item</a></li>
        <li><a href="#delete-item">Delete Item</a></li>
        <li><a href="#find-items-by-name">Find Items By Name</a></li>
        <li><a href="#item-merchant">Item Merchant</a></li>
      </ul>
    </li>  
    <li><a href="#contact">Contact</a></li>
  </ol>
</details>
<br>

<!-- Architecture -->
## Architecture

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- GETTING STARTED -->
## Getting Started

### Prerequisites

This is an example of how to list things you need to use the software and how to install them.

Ruby:
  ```sh
  rbenv install 2.7.4
  ```
Rails:
  ```sh
  gem install rails --version 5.2.8
  ```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Installation

Instructions to set up a local version of Rails Engine:

Fork and clone the project, then install the required gems with `bundle`. A full list of gems that will be installed can be found in the [gemfile](gemfile).

```sh
bundle install
```

Reset the database:

```sh
rake db:{drop,create,migrate}
```

Push to your preferred production server or in your terminal run
 ```sh
  rails server
 ```
Then open [http://localhost:3000](http://localhost:3000) in your browser.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## Gem Documentation

* [factory_bot_rails][factory_bot_rails-docs]
* [faker][faker-docs]
* [jsonapi-serializer][jsonapi-serializer-docs]
* [pry][pry-docs]
* [rspec-rails][rspec-rails-docs]
* [shoulda-matchers][shoulda-matchers-docs]
* [simplecov][simplecov-docs]

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## Endpoints

Endpoints to use in Postman running a local server `rails s`

* API end points

  - All merchants - http://localhost:3000/api/v1/merchants
  - One merchant - http://localhost:3000/api/v1/merchants/{{merchant_id}}
  - Find merchant by name - http://localhost:3000/api/v1/merchants/find?name={{name}}
  - Merchant items - 
  - All tems - http://localhost:3000/api/v1/items
  - One item - http://localhost:3000/api/v1/items/{{item_id}}
  - Create item - POST 'http://localhost:3000/api/v1/items'
  - Update item - PATCH 'http://localhost:3000/api/v1/items'
  - Delete item - DELETE 'http://localhost:3000/api/v1/items/{{item_id}}'
  - Find all items by name - http://localhost:3000/api/v1/items/find_all?name={{name}}
  - Item merchant - http://localhost:3000/api/v1/items/{{item_id}}/merchant

### All Merchants

```sh
  GET http://localhost:3000/api/v1/merchants
```

**Sample Response**

```sh
{
    "data": [
        {
            "id": null,
            "type": "recipe",
            "attributes": {
                "title": "Andy Ricker's Naam Cheuam Naam Taan Piip (Palm Sugar Simple Syrup)",
                "url": "https://www.seriouseats.com/recipes/2013/11/andy-rickers-naam-cheuam-naam-taan-piip-palm-sugar-simple-syrup.html",
                "country": "thailand",
                "image": "https://edamam-product-images.s3.amazonaws.com..."
            }
        },
        {
            "id": null,
            "type": "recipe",
            "attributes": {
                "title": "Sriracha",
                "url": "http://www.jamieoliver.com/recipes/vegetables-recipes/sriracha/",
                "country": "thailand",
                "image": "https://edamam-product-images.s3.amazonaws.com/."
            }
        },
        {...},
        {...},
        {...},
        {etc},
    ]
}
```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

#### One Merchant

```sh
  GET http://localhost:3000/api/v1/merchants/{{merchant_id}}
```

**Sample Response(country missing from endpoint)**

```sh
  {
    "data": []
  }
```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Find Merchant By Name

```sh
  GET  http://localhost:3000/api/v1/merchants/find?name={{name}}
```

**Sample Response**

```sh
{
    "data": {
        "id": null,
        "type": "learning_resource",
        "attributes": {
            "country": "laos",
            "video": {
                "title": "A Super Quick History of Laos",
                "youtube_video_id": "uw8hjVqxMXw"
            },
            "images": [
                {
                    "alt_tag": "standing statue and temples landmark during daytime",
                    "url": "https://images.unsplash.com/photo-1528181304800-259b08848526?ixid=MnwzNzg2NzV8MHwxfHNlYXJjaHwxfHx0aGFpbGFuZHxlbnwwfHx8fDE2Njc4Njk1NTA&ixlib=rb-4.0.3"
                },
                {
                    "alt_tag": "five brown wooden boats",
                    "url": "https://images.unsplash.com/photo-1552465011-b4e21bf6e79a?ixid=MnwzNzg2NzV8MHwxfHNlYXJjaHwyfHx0aGFpbGFuZHxlbnwwfHx8fDE2Njc4Njk1NTA&ixlib=rb-4.0.3"
                },
                {
                    "alt_tag": "orange temples during daytime",
                    "url": "https://images.unsplash.com/photo-1563492065599-3520f775eeed?ixid=MnwzNzg2NzV8MHwxfHNlYXJjaHwzfHx0aGFpbGFuZHxlbnwwfHx8fDE2Njc4Njk1NTA&ixlib=rb-4.0.3"
                },
                {...},
                {...},
                {...},
                {etc},
              ]
        }
    }
}
```

**Sample Response(no video or images found)**

```sh
{
  "data": {
      "id": null,
      "type": "learning_resource",
      "attributes": {
          "country": "Nameofcountry", # this value is the value used to search for learning resources
          "video": [],
          "images": []
      }
  }
}
```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Merchant Items

```sh
  GET http://localhost:3000/api/v1/merchants/{{merchant_id}}/items
```

**Sample Body**

```sh
 {
   "name": "Athena Dao",
   "email": "athenadao@bestgirlever.com"
 }
```

**Sample Response**

```sh
  {
    "data": {
      "type": "user",
      "id": "1",
      "attributes": {
        "name": "Athena Dao",
        "email": "athenadao@bestgirlever.com",
        "api_key": "jgn983hy48thw9begh98h4539h4"
      }
    }
  }
```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Add Favorite

```sh
  POST '/api/v1/favorites'
```

**Sample Body**

```sh
 {
    "api_key": "jgn983hy48thw9begh98h4539h4",
    "country": "thailand",
    "recipe_link": "https://www.tastingtable.com/.....",
    "recipe_title": "Crab Fried Rice (Khaao Pad Bpu)"
 }
```

**Sample Response**

```sh
 {
    "success": "Favorite added successfully"
 }
```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Get Favorites

```sh
  GET '/api/v1/favorites'
```

**Sample Body**

```sh
 {
   "api_key": "jgn983hy48thw9begh98h4539h4"
 }
```

**Sample Response**

```sh
{
   "data": [
       {
           "id": "1",
           "type": "favorite",
           "attributes": {
               "recipe_title": "Recipe: Egyptian Tomato Soup",
               "recipe_link": "http://www.thekitchn.com/recipe-egyptian-tomato-soup-weeknight....",
               "country": "egypt",
               "created_at": "2022-11-02T02:17:54.111Z"
           }
       },
       {
           "id": "2",
           "type": "favorite",
           "attributes": {
               "recipe_title": "Crab Fried Rice (Khaao Pad Bpu)",
               "recipe_link": "https://www.tastingtable.com/.....",
               "country": "thailand",
               "created_at": "2022-11-07T03:44:08.917Z"
           }
       }
   ]
}    
```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Delete Favorite

```sh
  DELETE '/api/v1/favorites'
```

<p align="right">(<a href="#readme-top">back to top</a>)</p>


## Contact

Anna Marie Sterling - [LinkedIn][linkedin-url]

Project Link: [https://github.com/AMSterling/lunch-and-learn](https://github.com/AMSterling/lunch-and-learn)

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/AMSterling/lunch-and-learn.svg?style=for-the-badge
[contributors-url]: https://github.com/AMSterling/lunch-and-learn/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/AMSterling/lunch-and-learn.svg?style=for-the-badge
[forks-url]: https://github.com/AMSterling/lunch-and-learn/network/members
[stars-shield]: https://img.shields.io/github/stars/AMSterling/lunch-and-learn.svg?style=for-the-badge
[stars-url]: https://github.com/AMSterling/lunch-and-learn/stargazers
[issues-shield]: https://img.shields.io/github/issues/AMSterling/lunch-and-learn.svg?style=for-the-badge
[issues-url]: https://github.com/AMSterling/lunch-and-learn/issues
[license-shield]: https://img.shields.io/github/license/AMSterling/lunch-and-learn.svg?style=for-the-badge
[license-url]: https://github.com/AMSterling/lunch-and-learn/blob/master/LICENSE.txt
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
[linkedin-url]: https://linkedin.com/in/sterling-316a6223a/

[Atom]: https://img.shields.io/badge/Atom-66595C?style=for-the-badge&logo=Atom&logoColor=white
[Atom-url]: https://atom.io/

[Bootstrap]: https://img.shields.io/badge/bootstrap-%23563D7C.svg?style=for-the-badge&logo=bootstrap&logoColor=white
[Bootstrap-url]: https://getbootstrap.com/

[CircleCI]: https://img.shields.io/badge/circle%20ci-%23161616.svg?style=for-the-badge&logo=circleci&logoColor=white
[CircleCI-url]: https://circleci.com/developer

[CSS]: https://img.shields.io/badge/CSS-239120?&style=for-the-badge&logo=css3&logoColor=white
[CSS-url]: https://en.wikipedia.org/wiki/CSS

[Fly]: https://custom-icon-badges.demolab.com/badge/Fly-DCDCDC?style=for-the-badge&logo=fly-io
[Fly-url]: https://fly.io/

[GitHub Badge]: https://img.shields.io/badge/GitHub-100000?style=for-the-badge&logo=github&logoColor=white
[GitHub-url]: https://github.com/<Username>/

[Heroku]: https://img.shields.io/badge/Heroku-430098?style=for-the-badge&logo=heroku&logoColor=white
[Heroku-url]: https://www.heroku.com/

[HTML5]: https://img.shields.io/badge/html5-%23E34F26.svg?style=for-the-badge&logo=html5&logoColor=white
[HTML5-url]: https://en.wikipedia.org/wiki/HTML5

[JavaScript]: https://img.shields.io/badge/javascript-%23323330.svg?style=for-the-badge&logo=javascript&logoColor=%23F7DF1E
[JavaScript-url]: https://www.javascript.com/

[jQuery]: https://img.shields.io/badge/jquery-%230769AD.svg?style=for-the-badge&logo=jquery&logoColor=white
[jQuery-url]: https://github.com/rails/jquery-rails

[LinkedIn Badge]: https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white
[LinkedIn-url]: https://www.linkedin.com/in/<Username>/

[Miro]: https://img.shields.io/badge/Miro-050038?style=for-the-badge&logo=Miro&logoColor=white
[Miro-url]: https://miro.com/

[PostgreSQL]: https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge&logo=postgresql&logoColor=white
[PostgreSQL-url]: https://www.postgresql.org/

[Postman]: https://img.shields.io/badge/Postman-FF6C37?style=for-the-badge&logo=postman&logoColor=white
[Postman-url]: https://web.postman.co/

[Rails]: https://img.shields.io/badge/rails-%23CC0000.svg?style=for-the-badge&logo=ruby-on-rails&logoColor=white
[Rails-url]: https://rubyonrails.org/

[RSpec]: https://custom-icon-badges.demolab.com/badge/RSpec-fffcf7?style=for-the-badge&logo=rspec
[RSpec-url]: https://rspec.info/

[RuboCop]: https://img.shields.io/badge/RuboCop-000?logo=rubocop&logoColor=fff&style=for-the-badge
[RuboCop-url]: https://docs.rubocop.org/rubocop-rails/index.html

[Ruby]: https://img.shields.io/badge/Ruby-000000?style=for-the-badge&logo=ruby&logoColor=CC342D
[Ruby-url]: https://www.ruby-lang.org/en/

[Visual Studio Code]: https://img.shields.io/badge/Visual%20Studio%20Code-0078d7.svg?style=for-the-badge&logo=visual-studio-code&logoColor=white
[Visual Studio Code-url]: https://code.visualstudio.com/

[bcrypt-docs]: https://github.com/bcrypt-ruby/bcrypt-ruby
[capybara-docs]: https://github.com/teamcapybara/capybara
[factory_bot_rails-docs]: https://github.com/thoughtbot/factory_bot_rails
[faker-docs]: https://github.com/faker-ruby/faker
[faraday-docs]: https://lostisland.github.io/faraday/
[figaro-docs]: https://github.com/laserlemon/figaro
[jsonapi-serializer-docs]: https://github.com/jsonapi-serializer/jsonapi-serializer
[launchy-docs]: https://www.rubydoc.info/gems/launchy/2.2.0
[omniauth-google-oauth2-docs]: https://github.com/zquestz/omniauth-google-oauth2
[orderly-docs]: https://github.com/jmondo/orderly
[pry-docs]: https://github.com/pry/pry
[rspec-rails-docs]: https://github.com/rspec/rspec-rails
[shoulda-matchers-docs]: https://github.com/thoughtbot/shoulda-matchers
[simplecov-docs]: https://github.com/simplecov-ruby/simplecov
[vcr-docs]: https://github.com/vcr/vcr
[webmock-docs]: https://github.com/bblimke/webmock



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
