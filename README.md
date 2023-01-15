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

Rails Engine is a Backend Service Oriented Architecture application. Front end repo can be found <a href="https://github.com/AMSterling/rails_engine_fe">here</a>.

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
        <li><a href="#find-all-merchants-by-name">Find All Merchants By Name</a></li>
        <li><a href="#merchant-items">Merchant Items</a></li>
        <li><a href="#all-items">All Items</a></li>
        <li><a href="#one-item">One Item</a></li>
        <li><a href="#create-item">Create Item</a></li>
        <li><a href="#update-item">Update Item</a></li>
        <li><a href="#delete-item">Delete Item</a></li>
        <li><a href="#find-item-by-name">Find Item By Name</a></li>
        <li><a href="#find-item-by-price">Find Item By Price</a></li>
        <li><a href="#find-all-items-by-name">Find All Items By Name</a></li>
        <li><a href="#find-all-items-by-price">Find All Items By Price</a></li>
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

Reset and seed the database:

```sh
rake db:{drop,create,migrate,seed}
```

```sh
rake db:schema:dump
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

### All Merchants

```sh
  GET http://localhost:3000/api/v1/merchants
```

**Sample Response(200)**

```sh
{
    "data": [
        {
            "id": "1",
            "type": "merchant",
            "attributes": {
                "name": "Schroeder-Jerde"
            }
        },
        {
            "id": "2",
            "type": "merchant",
            "attributes": {
                "name": "Klein, Rempel and Jones"
            }
        },
        {
            "id": "3",
            "type": "merchant",
            "attributes": {
                "name": "Willms and Sons"
            }
        },
        {
            "id": "4",
            "type": "merchant",
            "attributes": {
                "name": "Cummings-Thiel"
            }
        },
        {
            "id": "5",
            "type": "merchant",
            "attributes": {
                "name": "Williamson Group"
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

### One Merchant

```sh
  GET http://localhost:3000/api/v1/merchants/42
```

**Sample Response(200)**

```sh
{
    "data": {
        "id": "42",
        "type": "merchant",
        "attributes": {
            "name": "Glover Inc"
        }
    }
}
```

```sh
GET http://localhost:3000/api/v1/merchants/8923987297
GET http://localhost:3000/api/v1/merchants/string-instead-of-integer
```

**Sample Response(404 Not Found - Merchant ID doesn't exist)**

```sh
{
    "error": "No merchant found"
}
```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Find Merchant By Name

```sh
  GET  http://localhost:3000/api/v1/merchants/find?name=iLl
```

**Sample Response(200)**

```sh
{
    "data": {
        "id": "28",
        "type": "merchant",
        "attributes": {
            "name": "Schiller, Barrows and Parker"
        }
    }
}
```

```sh
  GET  http://localhost:3000/api/v1/merchants/find
```

**Sample Response(400 Bad Request - No search parameter given)**

```sh
{
    "data": {}
}
```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Find All Merchants By Name

```sh
GET http://localhost:3000/api/v1/merchants/find_all?name=ILL
```

**Sample Response(200)**

```sh
{
    "data": [
        {
            "id": "28",
            "type": "merchant",
            "attributes": {
                "name": "Schiller, Barrows and Parker"
            }
        },
        {
            "id": "13",
            "type": "merchant",
            "attributes": {
                "name": "Tillman Group"
            }
        },
        {
            "id": "5",
            "type": "merchant",
            "attributes": {
                "name": "Williamson Group"
            }
        },
        {
            "id": "6",
            "type": "merchant",
            "attributes": {
                "name": "Williamson Group"
            }
        },
        {
            "id": "3",
            "type": "merchant",
            "attributes": {
                "name": "Willms and Sons"
            }
        }
    ]
}
```

```sh
  GET  http://localhost:3000/api/v1/merchants/find_all?name=
```

**Sample Response(400 Bad Request - No search parameter given)**

```sh
{
    "data": {}
}
```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Merchant Items

```sh
  GET http://localhost:3000/api/v1/merchants/99/items
```

**Sample Response(200)**

```sh
{
    "data": [
        {
            "id": "2425",
            "type": "item",
            "attributes": {
                "name": "Item Excepturi Rem",
                "description": "Perferendis reprehenderit fugiat sit eos. Corporis ipsum ut. Natus molestiae quia rerum fugit quis. A cumque doloremque magni.",
                "unit_price": 476.82,
                "merchant_id": 99
            }
        },
        {
            "id": "2427",
            "type": "item",
            "attributes": {
                "name": "Item Illum Minus",
                "description": "Aut voluptatem aut officiis minima cum at. Est ea sed est quia repudiandae. Eum omnis rerum in adipisci aut. Deleniti sunt voluptatibus rerum aut quo omnis.",
                "unit_price": 98.07,
                "merchant_id": 99
            }
        },
        {
            "id": "2426",
            "type": "item",
            "attributes": {
                "name": "Item Repellendus Cum",
                "description": "Odio vitae asperiores sint ut labore. Tenetur perspiciatis facere quos cum. Optio modi consequatur.",
                "unit_price": 612.11,
                "merchant_id": 99
            }
        },
        {
            "id": "2397",
            "type": "item",
            "attributes": {
                "name": "Item Iusto Voluptates",
                "description": "Dolor sequi aut totam molestiae vel magni. Molestiae repudiandae impedit mollitia provident suscipit et. Voluptatum molestias iusto. Ullam minus quisquam consequatur consequuntur molestias. Consequatur voluptatum molestias ipsum.",
                "unit_price": 42.65,
                "merchant_id": 99
            }
        },
        {
            "id": "2398",
            "type": "item",
            "attributes": {
                "name": "Item Maxime Corporis",
                "description": "Dicta enim rerum. Laborum sit soluta. Quo occaecati blanditiis sunt. Sequi aut suscipit numquam eveniet ipsam repudiandae.",
                "unit_price": 712.22,
                "merchant_id": 99
            }
        },
        {...},
        {...},
        {...},
        {etc},
    ]
}
```

```sh
GET http://localhost:3000/api/v1/merchants/8923987297/items
GET http://localhost:3000/api/v1/merchants/string-instead-of-integer/items
```

**Sample Response(404 Not Found - Merchant ID doesn't exist)**

```sh
{
    "error": "error"
}
```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### All Items

```sh
  GET http://localhost:3000/api/v1/items
```

**Sample Response(200)**

```sh
{
   "data": [
       {
           "id": "4",
           "type": "item",
           "attributes": {
               "name": "Item Nemo Facere",
               "description": "Sunt eum id eius magni consequuntur delectus veritatis. Quisquam laborum illo ut ab. Ducimus in est id voluptas autem.",
               "unit_price": 42.91,
               "merchant_id": 1
           }
       },
       {
           "id": "5",
           "type": "item",
           "attributes": {
               "name": "Item Expedita Aliquam",
               "description": "Voluptate aut labore qui illum tempore eius. Corrupti cum et rerum. Enim illum labore voluptatem dicta consequatur. Consequatur sunt consequuntur ut officiis.",
               "unit_price": 687.23,
               "merchant_id": 1
           }
       },
       {
           "id": "6",
           "type": "item",
           "attributes": {
               "name": "Item Provident At",
               "description": "Numquam officiis reprehenderit eum ratione neque tenetur. Officia aut repudiandae eum at ipsum doloribus. Iure minus itaque similique. Ratione dicta alias asperiores minima ducimus nesciunt at.",
               "unit_price": 159.25,
               "merchant_id": 1
           }
       },
       {
           "id": "7",
           "type": "item",
           "attributes": {
               "name": "Item Expedita Fuga",
               "description": "Fuga assumenda occaecati hic dolorem tenetur dolores nisi. Est tenetur adipisci voluptatem vel. Culpa adipisci consequatur illo. Necessitatibus quis quo velit sed repellendus ut amet.",
               "unit_price": 311.63,
               "merchant_id": 1
           }
       },
       {
           "id": "8",
           "type": "item",
           "attributes": {
               "name": "Item Est Consequuntur",
               "description": "Reprehenderit est officiis cupiditate quia eos. Voluptatem illum reprehenderit quo vel eligendi. Et eum omnis id ut aliquid veniam.",
               "unit_price": 343.55,
               "merchant_id": 1
           }
       },
       {...}
    ]
}
```

#### One Item

```sh
  GET http://localhost:3000/api/v1/items/179
```

**Sample Response(200)**

```sh
{
    "data": {
        "id": "179",
        "type": "item",
        "attributes": {
            "name": "Item Qui Veritatis",
            "description": "Totam labore quia harum dicta eum consequatur qui. Corporis inventore consequatur. Illum facilis tempora nihil placeat rerum sint est. Placeat ut aut. Eligendi perspiciatis unde eum sapiente velit.",
            "unit_price": 906.17,
            "merchant_id": 9
        }
    }
}
```

```sh
GET http://localhost:3000/api/v1/items/456468146546
GET http://localhost:3000/api/v1/items/string-instead-of-integer
```

**Sample Response(404 Not Found - Item ID doesn't exist)**

```sh
{
    "error": "Item does not exist or is no longer available"
}
```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Create Item

```sh
POST http://localhost:3000/api/v1/items
```

**Sample Body**

```sh
{
  "name": "{{item_name}}",
  "description": "{{item_description}}",
  "unit_price": {{item_price}},
  "merchant_id": {{item_merchant_id}}
}
```

**Sample Response(201 Created)**

```sh
{
    "data": {
        "id": "2549",
        "type": "item",
        "attributes": {
            "name": "Shiny Itemy Item",
            "description": "It does a lot of things real good.",
            "unit_price": 123.45,
            "merchant_id": 43
        }
    }
}
```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Update Item

```sh
  PUT http://localhost:3000/api/v1/items/179
```

**Sample Body**

```sh
{
    "name": "{{new_item_name}}",
    "description": "{{new_item_description}}",
    "unit_price": {{new_item_price}},
    "merchant_id": {{new_item_merchant_id}}
}
```

**Sample Response(200)**

```sh
{
    "data": {
        "id": "179",
        "type": "item",
        "attributes": {
            "name": "Shiny Itemy Item, New and Improved",
            "description": "It does a lot of things even more good than before!",
            "unit_price": 65.23,
            "merchant_id": 56
        }
    }
}
```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Delete Item

```sh
  DELETE http://localhost:3000/api/v1/items/{{item_id}}
```

**Sample Response(404 Not found)**

```sh
{
    "error": "error"
}
```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Find Item By Name

```sh
GET http://localhost:3000/api/v1/items/find?name=hArU
```

**Sample Response(200)**

```sh
{
    "data": {
        "id": "21",
        "type": "item",
        "attributes": {
            "name": "Item Repellendus Harum",
            "description": "Minus sit dolorum velit ratione. Et dolore accusantium quam perferendis repudiandae doloremque saepe. Velit illo doloremque.",
            "unit_price": 636.65,
            "merchant_id": 2
        }
    }
}
```

```sh
GET http://localhost:3000/api/v1/items/find?name=
```

**Sample Response(400 Bad Request - Item name not passed in)**

```sh
{
    "data": {},
    "error": "error"
}
```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Find Item By Price

```sh
GET http://localhost:3000/api/v1/items/find?min_price=50
```

**Sample Response(200)**

```sh
{
    "data": {
        "id": "2352",
        "type": "item",
        "attributes": {
            "name": "Item A Error",
            "description": "Exercitationem rerum porro illo quam molestiae fugiat. Est sit consequatur magnam qui. Officia fugit corporis aliquam enim consectetur.",
            "unit_price": 285.96,
            "merchant_id": 97
        }
    }
}
```

```sh
GET http://localhost:3000/api/v1/items/find?max_price=150
```

**Sample Response(200)**

```sh
{
    "data": {
        "id": "839",
        "type": "item",
        "attributes": {
            "name": "Item A Non",
            "description": "Ratione consequatur ipsam quia saepe voluptatem sed blanditiis. Eaque rerum eos ullam quo nostrum distinctio. Ut ad et quos sunt repellendus soluta.",
            "unit_price": 14.11,
            "merchant_id": 37
        }
    }
}
```

```sh
GET http://localhost:3000/api/v1/items/find?min_price=
GET http://localhost:3000/api/v1/items/find?max_price=
```

**Sample Response(400 Bad Request - Item price not passed in)**

```sh
{
    "data": {},
    "error": "error"
}
```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

```sh
GET http://localhost:3000/api/v1/items/find?min_price=-5
GET http://localhost:3000/api/v1/items/find?min_price=500000000
GET http://localhost:3000/api/v1/items/find?max_price=-5
GET http://localhost:3000/api/v1/items/find?max_price=1.99
GET http://localhost:3000/api/v1/items/find?min_price=50&max_price=5
```

**Sample Response(400 Bad Request - Price out of range)**

```sh
{
    "data": {},
    "error": "error"
}
```

<p align="right">(<a href="#readme-top">back to top</a>)</p>


```sh
GET http://localhost:3000/api/v1/items/find?name=ring&max_price=50
```

**Sample Response(400 Bad Request - Name and Price)**

```sh
{
    "data": {},
    "error": "error"
}
```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Find All Items By Name

```sh
GET http://localhost:3000/api/v1/items/find_all?name=hArU
```

**Sample Response(200)**

```sh
{
    "data": [
        {
            "id": "21",
            "type": "item",
            "attributes": {
                "name": "Item Repellendus Harum",
                "description": "Minus sit dolorum velit ratione. Et dolore accusantium quam perferendis repudiandae doloremque saepe. Velit illo doloremque.",
                "unit_price": 636.65,
                "merchant_id": 2
            }
        },
        {
            "id": "62",
            "type": "item",
            "attributes": {
                "name": "Item Harum Molestiae",
                "description": "Fuga modi eos iusto nisi vero omnis. Blanditiis corrupti quibusdam deleniti qui. Quasi qui maiores tenetur omnis odit incidunt. Omnis ut tenetur. Expedita iure maxime.",
                "unit_price": 609.45,
                "merchant_id": 3
            }
        },
        {
            "id": "136",
            "type": "item",
            "attributes": {
                "name": "Item Explicabo Harum",
                "description": "Ut nihil harum quia. Odio neque qui molestiae. Eligendi fugiat consequatur. Id officiis fugit et. Illo autem est qui.",
                "unit_price": 117.88,
                "merchant_id": 8
            }
        },
        {
            "id": "313",
            "type": "item",
            "attributes": {
                "name": "Item Harum Omnis",
                "description": "Non modi voluptas fuga quidem explicabo. Nihil et consequatur sed sint. Dolorem sequi aut odit qui reprehenderit fugit.",
                "unit_price": 708.91,
                "merchant_id": 18
            }
        },
        {
            "id": "427",
            "type": "item",
            "attributes": {
                "name": "Item Illum Harum",
                "description": "Quod nobis deleniti sint ut. Nihil non enim natus aut. Occaecati adipisci repellat aut reprehenderit sit. Et modi praesentium ipsum sapiente maiores.",
                "unit_price": 0.56,
                "merchant_id": 22
            }
        },
        {...}
    ]
}
```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Find All Items By Price

```sh
GET http://localhost:3000/api/v1/items/find_all?min_price=999
```

**Sample Response(200)**

```sh
{
    "data": [
        {
            "id": "1708",
            "type": "item",
            "attributes": {
                "name": "Item Eos Similique",
                "description": "Minima ex voluptatem provident voluptatem sapiente reiciendis adipisci. Eius nihil neque. Architecto omnis sunt voluptatem ratione dignissimos fuga. Sint tenetur maiores sapiente eos placeat. Sit sed perspiciatis.",
                "unit_price": 999.94,
                "merchant_id": 69
            }
        },
        {
            "id": "1063",
            "type": "item",
            "attributes": {
                "name": "Item Et Dolorem",
                "description": "Quo aut architecto eum suscipit. Cumque blanditiis aut beatae recusandae. Dolores ut accusantium deleniti.",
                "unit_price": 999.54,
                "merchant_id": 47
            }
        },
        {
            "id": "1711",
            "type": "item",
            "attributes": {
                "name": "Item Quaerat Expedita",
                "description": "Sed consequatur in atque odit ex quae perspiciatis. Ut aut quos. Reiciendis rem excepturi ex explicabo dolore. Aliquam deserunt sed voluptas.",
                "unit_price": 999.88,
                "merchant_id": 70
            }
        }
    ]
}
```

```sh
GET http://localhost:3000/api/v1/items/find_all?max_price=1000&min_price=999
```

**Sample Response(200 - price range)**

```sh
{
    "data": [
        {
            "id": "1708",
            "type": "item",
            "attributes": {
                "name": "Item Eos Similique",
                "description": "Minima ex voluptatem provident voluptatem sapiente reiciendis adipisci. Eius nihil neque. Architecto omnis sunt voluptatem ratione dignissimos fuga. Sint tenetur maiores sapiente eos placeat. Sit sed perspiciatis.",
                "unit_price": 999.94,
                "merchant_id": 69
            }
        },
        {
            "id": "1063",
            "type": "item",
            "attributes": {
                "name": "Item Et Dolorem",
                "description": "Quo aut architecto eum suscipit. Cumque blanditiis aut beatae recusandae. Dolores ut accusantium deleniti.",
                "unit_price": 999.54,
                "merchant_id": 47
            }
        },
        {
            "id": "1711",
            "type": "item",
            "attributes": {
                "name": "Item Quaerat Expedita",
                "description": "Sed consequatur in atque odit ex quae perspiciatis. Ut aut quos. Reiciendis rem excepturi ex explicabo dolore. Aliquam deserunt sed voluptas.",
                "unit_price": 999.88,
                "merchant_id": 70
            }
        }
    ]
}
```

```sh
GET http://localhost:3000/api/v1/items/find_all
```

**Sample Response(400 Bad Request - Item search parameter not passed in)**

```sh
{
    "data": {},
    "error": "error"
}
```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

```sh
GET http://localhost:3000/api/v1/items/find_all?min_price=500000000
GET http://localhost:3000/api/v1/items/find_all?max_price=-5
GET http://localhost:3000/api/v1/items/find_all?max_price=1000&min_price=999
```

**Sample Response(400 Bad Request - Price out of range)**

```sh
{
    "data": {},
    "error": "error"
}
```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

```sh
GET http://localhost:3000/api/v1/items/find_all?name=ring&max_price=50
```

**Sample Response(400 Bad Request - Name and Price)**

```sh
{
    "data": {},
    "error": "error"
}
```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## Contact

Anna Marie Sterling - [LinkedIn][linkedin-url]

Project Link: [https://github.com/AMSterling/rails-engine](https://github.com/AMSterling/rails-engine)

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- MARKDOWN LINKS & IMAGES -->

<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/AMSterling/rails-engine.svg?style=for-the-badge
[contributors-url]: https://github.com/AMSterling/rails-engine/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/AMSterling/rails-engine.svg?style=for-the-badge
[forks-url]: https://github.com/AMSterling/rails-engine/network/members
[stars-shield]: https://img.shields.io/github/stars/AMSterling/rails-engine.svg?style=for-the-badge
[stars-url]: https://github.com/AMSterling/rails-engine/stargazers
[issues-shield]: https://img.shields.io/github/issues/AMSterling/rails-engine.svg?style=for-the-badge
[issues-url]: https://github.com/AMSterling/rails-engine/issues
[license-shield]: https://img.shields.io/github/license/AMSterling/rails-engine.svg?style=for-the-badge
[license-url]: https://github.com/AMSterling/rails-engine/blob/master/LICENSE.txt
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
[GitHub-url]: https://github.com/AMSterling/

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
