<a name="readme-top"></a>

<!-- PROJECT SHIELDS -->

<div align="right">

[![Maintainability](https://api.codeclimate.com/v1/badges/26f1b36435ef838c9599/maintainability)](https://codeclimate.com/github/AMSterling/rails-engine/maintainability)
[![Coverage](badge.svg)](https://github.com/AMSterling/rails-engine)

</div>

[![Contributors][contributors-shield]][contributors-url]
[![LinkedIn][linkedin-shield]][linkedin-url]

<br>

<div align="center">

# Rails Engine

[![Rails][Rails]][Rails-url] [![Ruby][Ruby]][Ruby-url] [![RSpec][RSpec]][RSpec-url] [![Atom][Atom]][Atom-url] [![PostgreSQL][PostgreSQL]][PostgreSQL-url] [![Postman][Postman]][Postman-url]

</div>

## Description

Rails Engine is a Backend Service Oriented Architecture application that utilizes RESTful architecture. <a href="https://github.com/AMSterling/rails_engine_fe">Rails Engine Front End Repo</a>.

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
        <li><a href="#merchants-with-most-items-sold">Merchants with Most Items Sold</a></li>
        <li><a href="#merchants-with-most-revenue">Merchants with Most Revenue</a></li>
        <li><a href="#total-revenue-for-a-given-merchant">Total Revenue for a Given Merchant</a></li>
        <li><a href="#items-ranked-by-revenue">Items Ranked By Revenue</a></li>
        <li><a href="#revenue-across-date-range">Revenue Across Date Range</a></li>
        <li><a href="#potential-revenue-of-unshipped-orders">Potential Revenue of Unshipped Orders</a></li>
        <li><a href="#report-by-month-of-revenue-generated">Report by Month of Revenue Generated</a></li>
      </ul>
    </li>  
    <li><a href="#contact">Contact</a></li>
  </ol>
</details>
<br>

<!-- Architecture -->
## Architecture

# <img src="app/assets/images/RailsEngineSchema.png">

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- GETTING STARTED -->
## Getting Started

### Prerequisites

Ruby:
  ```sh
  2.7.4
  ```
Rails:
  ```sh
  5.2.8
  ```
Database:
  ```sh
  postgresql@14
  ```
  
<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Installation

Instructions to set up a local version of Rails Engine:

Fork and clone the project, then install the required gems with `bundle`. A full list of gems that will be installed can be found in the [gemfile][gemfile-url].

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

```json
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

```json
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

```json
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

```json
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

```json
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

```json
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

```json
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

```json
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

```json
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

```json
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

<p align="right">(<a href="#readme-top">back to top</a>)</p>


### One Item

```sh
  GET http://localhost:3000/api/v1/items/179
```

**Sample Response(200)**

```json
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

```json
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

```json
{
  "name": "{{item_name}}",
  "description": "{{item_description}}",
  "unit_price": {{item_price}},
  "merchant_id": {{item_merchant_id}}
}
```

**Sample Response(201 Created)**

```json
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

```json
{
    "name": "{{new_item_name}}",
    "description": "{{new_item_description}}",
    "unit_price": {{new_item_price}},
    "merchant_id": {{new_item_merchant_id}}
}
```

**Sample Response(200)**

```json
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

```json
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

```json
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

```json
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

```json
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

```json
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

<p align="right">(<a href="#readme-top">back to top</a>)</p>

```sh
  GET http://localhost:3000/api/v1/items/find?min_price=
  GET http://localhost:3000/api/v1/items/find?max_price=
```

**Sample Response(400 Bad Request - Item price not passed in)**

```json
{
    "data": {},
    "error": "error"
}
```

```sh
  GET http://localhost:3000/api/v1/items/find?min_price=-5
  GET http://localhost:3000/api/v1/items/find?min_price=500000000
  GET http://localhost:3000/api/v1/items/find?max_price=-5
  GET http://localhost:3000/api/v1/items/find?max_price=1.99
  GET http://localhost:3000/api/v1/items/find?min_price=50&max_price=5
```

**Sample Response(400 Bad Request - Price out of range)**

```json
{
    "data": {},
    "error": "error"
}
```

```sh
  GET http://localhost:3000/api/v1/items/find?name=ring&max_price=50
```

**Sample Response(400 Bad Request - Name and Price)**

```json
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

```json
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

```json
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

```json
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

<p align="right">(<a href="#readme-top">back to top</a>)</p>

```sh
  GET http://localhost:3000/api/v1/items/find_all
```

**Sample Response(400 Bad Request - Item search parameter not passed in)**

```json
{
    "data": {},
    "error": "error"
}
```

```sh
  GET http://localhost:3000/api/v1/items/find_all?min_price=500000000
  GET http://localhost:3000/api/v1/items/find_all?max_price=-5
  GET http://localhost:3000/api/v1/items/find_all?max_price=1000&min_price=999
```

**Sample Response(400 Bad Request - Price out of range)**

```json
{
    "data": {},
    "error": "error"
}
```

```sh
  GET http://localhost:3000/api/v1/items/find_all?name=ring&max_price=50
```

**Sample Response(400 Bad Request - Name and Price)**

```json
{
    "data": {},
    "error": "error"
}
```

<p align="right">(<a href="#readme-top">back to top</a>)</p>


### Merchants with Most Items Sold

```sh
  GET http://localhost:3000/api/v1/merchants/most_items?quantity=2
```

**Sample Response(200)**

```json
{
    "data": [
        {
            "id": "89",
            "type": "items_sold",
            "attributes": {
                "name": "Kassulke, O'Hara and Quitzon",
                "count": 1653
            }
        },
        {
            "id": "12",
            "type": "items_sold",
            "attributes": {
                "name": "Kozey Group",
                "count": 1585
            }
        }
    ]
}
```

```sh
  GET  http://localhost:3000/api/v1/merchants/most_items?quantity=
```

**Sample Response(400 Bad Request - No search parameter given)**

```json
{
    "data": [],
    "error": "error"
}
```

<p align="right">(<a href="#readme-top">back to top</a>)</p>


### Merchants with Most Revenue

```sh
  GET http://localhost:3000/api/v1/revenue/merchants?quantity=2
```

**Sample Response(200)**

```json
{
    "data": [
        {
            "id": "14",
            "type": "merchant_name_revenue",
            "attributes": {
                "name": "Dicki-Bednar",
                "revenue": 1148393.74
            }
        },
        {
            "id": "89",
            "type": "merchant_name_revenue",
            "attributes": {
                "name": "Kassulke, O'Hara and Quitzon",
                "revenue": 1015275.15
            }
        }
    ]
}
```

```sh
  GET  http://localhost:3000/api/v1/revenue/merchants?quantity=
```

**Sample Response(400 Bad Request - No search parameter given)**

```json
{
    "data": [],
    "error": "error"
}
```

<p align="right">(<a href="#readme-top">back to top</a>)</p>


### Total Revenue for a Given Merchant

```sh
  GET http://localhost:3000/api/v1/revenue/merchants/42
```

**Sample Response(200)**

```json
{
    "data": {
        "id": "42",
        "type": "merchant_revenue",
        "attributes": {
            "revenue": 532613.9800000001
        }
    }
}
```

```sh
  GET  http://localhost:3000/api/v1/revenue/merchants/8923987297
```

**Sample Response(400 Bad Request - No merchant)**

```json
{
    "status": "Not Found"
}
```

<p align="right">(<a href="#readme-top">back to top</a>)</p>


### Items Ranked By Revenue

```sh
  GET http://localhost:3000/api/v1/revenue/items?quantity=1
```

**Sample Response(200)**

```json
{
    "data": [
        {
            "id": "227",
            "type": "item_revenue",
            "attributes": {
                "name": "Item Dicta Autem",
                "description": "Fugiat est ut eum impedit vel et. Deleniti quia debitis similique. Sint atque explicabo similique est. Iste fugit quis voluptas. Rerum ut harum sed fugiat eveniet ullam ut.",
                "unit_price": 853.19,
                "merchant_id": 14,
                "revenue": 1148393.7399999984
            }
        },
        {
            "id": "2174",
            "type": "item_revenue",
            "attributes": {
                "name": "Item Nam Magnam",
                "description": "Eligendi quibusdam eveniet temporibus sed ratione ut magnam. Sit alias et. Laborum dignissimos quos impedit excepturi molestiae.",
                "unit_price": 788.08,
                "merchant_id": 89,
                "revenue": 695086.5599999998
            }
        }
    ]
}
```

```sh
  GET  http://localhost:3000/api/v1/revenue/items
```

**Sample Response(400 Bad Request - Missing parameter)**

```json
{
    "data": [],
    "error": "error"
}
```

<p align="right">(<a href="#readme-top">back to top</a>)</p>


### Revenue Across Date Range

```sh
  GET http://localhost:3000/api/v1/revenue?start=2012-03-09&end=2012-03-24
```

**Sample Response(200)**

```json
{
    "data": {
        "id": null,
        "type": "revenue",
        "attributes": {
            "revenue": 43201227.8
        }
    }
}
```

```sh
  GET  http://localhost:3000/api/v1/revenue?start=2012-03-09&end=
```

**Sample Response(400 Bad Request - Missing parameter)**

```json
{
    "data": {},
    "error": "error"
}
```

<p align="right">(<a href="#readme-top">back to top</a>)</p>


### Potential Revenue of Unshipped Orders

```sh
  GET http://localhost:3000/api/v1/revenue/unshipped?quantity=1
```

**Sample Response(200)**

```json
{
    "data": [
        {
            "id": "4844",
            "type": "unshipped_order",
            "attributes": {
                "potential_revenue": 1504.08
            }
        }
    ]
}
```

```sh
  GET  http://localhost:3000/api/v1/revenue/unshipped
```

**Sample Response(400 Bad Request - Missing parameter)**

```json
{
    "data": [],
    "error": "error"
}
```

<p align="right">(<a href="#readme-top">back to top</a>)</p>


### Report by Month of Revenue Generated

```sh
  GET http://localhost:3000/api/v1/revenue/weekly
```

**Sample Response(200)**

```json
{
    "data": [
        {
            "id": null,
            "type": "weekly_revenue",
            "attributes": {
                "week": "2012-03-05",
                "revenue": 14981117.170000013
            }
        },
        {
            "id": null,
            "type": "weekly_revenue",
            "attributes": {
                "week": "2012-03-12",
                "revenue": 18778641.380000062
            }
        },
        {
            "id": null,
            "type": "weekly_revenue",
            "attributes": {
                "week": "2012-03-19",
                "revenue": 19106531.87999994
            }
        },
        {
            "id": null,
            "type": "weekly_revenue",
            "attributes": {
                "week": "2012-03-26",
                "revenue": 4627284.439999996
            }
        }
    ]
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
[gemfile-url]: https://github.com/AMSterling/rails-engine/blob/main/Gemfile
[stars-shield]: https://img.shields.io/github/stars/AMSterling/rails-engine.svg?style=for-the-badge
[stars-url]: https://github.com/AMSterling/rails-engine/stargazers
[issues-shield]: https://img.shields.io/github/issues/AMSterling/rails-engine.svg?style=for-the-badge
[issues-url]: https://github.com/AMSterling/rails-engine/issues
[license-shield]: https://img.shields.io/github/license/AMSterling/rails-engine.svg?style=for-the-badge
[license-url]: https://github.com/AMSterling/rails-engine/blob/master/LICENSE.txt
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
[linkedin-url]: https://linkedin.com/in/sterling-316a6223a/

[Atom]: https://custom-icon-badges.demolab.com/badge/Atom-5FB57D?style=for-the-badge&logo=atom
[Atom-url]: https://github.com/atom/atom/releases/tag/v1.60.0

[Bootstrap]: https://img.shields.io/badge/bootstrap-%23563D7C.svg?style=for-the-badge&logo=bootstrap&logoColor=white
[Bootstrap-url]: https://getbootstrap.com/

[Capybara]: https://custom-icon-badges.demolab.com/badge/Capybara-F7F4EF?style=for-the-badge&logo=capybara
[Capybara-url]: https://www.patreon.com/capybara

[CircleCI]: https://img.shields.io/badge/circle%20ci-%23161616.svg?style=for-the-badge&logo=circleci&logoColor=white
[CircleCI-url]: https://circleci.com/developer

[CSS]: https://img.shields.io/badge/CSS-239120?&style=for-the-badge&logo=css3&logoColor=white
[CSS-url]: https://en.wikipedia.org/wiki/CSS

[Fly]: https://custom-icon-badges.demolab.com/badge/Fly-DCDCDC?style=for-the-badge&logo=fly-io
[Fly-url]: https://fly.io/

[Git Badge]: https://img.shields.io/badge/GIT-E44C30?style=for-the-badge&logo=git&logoColor=white
[Git-url]: https://git-scm.com/

[GitHub Badge]: https://img.shields.io/badge/GitHub-100000?style=for-the-badge&logo=github&logoColor=white
[GitHub-url]: https://github.com/<Username>/

[GitHub Actions]: https://img.shields.io/badge/github%20actions-%232671E5.svg?style=for-the-badge&logo=githubactions&logoColor=white
[GitHub Actions-url]: https://github.com/features/actions

[GraphQL]: https://img.shields.io/badge/-GraphQL-E10098?style=for-the-badge&logo=graphql&logoColor=white
[GraphQL-url]: https://graphql.org/

[Heroku]: https://img.shields.io/badge/Heroku-430098?style=for-the-badge&logo=heroku&logoColor=white
[Heroku-url]: https://www.heroku.com/

[Homebrew]: https://custom-icon-badges.demolab.com/badge/Homebrew-2e2a24?style=for-the-badge&logo=homebrew_logo
[Homebrew-url]: https://brew.sh/

[HTML5]: https://img.shields.io/badge/html5-%23E34F26.svg?style=for-the-badge&logo=html5&logoColor=white
[HTML5-url]: https://en.wikipedia.org/wiki/HTML5

[JavaScript]: https://img.shields.io/badge/javascript-%23323330.svg?style=for-the-badge&logo=javascript&logoColor=%23F7DF1E
[JavaScript-url]: https://www.javascript.com/

[jQuery]: https://img.shields.io/badge/jquery-%230769AD.svg?style=for-the-badge&logo=jquery&logoColor=white
[jQuery-url]: https://github.com/rails/jquery-rails

[LinkedIn Badge]: https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white
[LinkedIn-url]: https://www.linkedin.com/in/<Username>/

[MacOS]: https://img.shields.io/badge/mac%20os-000000?style=for-the-badge&logo=macos&logoColor=F0F0F0
[MacOS-url]: https://www.apple.com/macos

[Miro]: https://img.shields.io/badge/Miro-050038?style=for-the-badge&logo=Miro&logoColor=white
[Miro-url]: https://miro.com/

[Postgres]: https://img.shields.io/badge/postgres-%23316192.svg?style=for-the-badge&logo=postgresql&logoColor=white
[Postgres-url]: https://www.postgresql.org/

[PostgreSQL]: https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge&logo=postgresql&logoColor=white
[PostgreSQL-url]: https://www.postgresql.org/

[Postman]: https://img.shields.io/badge/Postman-FF6C37?style=for-the-badge&logo=postman&logoColor=white
[Postman-url]: https://web.postman.co/

[Rails]: https://img.shields.io/badge/rails-%23CC0000.svg?style=for-the-badge&logo=ruby-on-rails&logoColor=white
[Rails-url]: https://rubyonrails.org/

[Redis]: https://img.shields.io/badge/redis-%23DD0031.svg?&style=for-the-badge&logo=redis&logoColor=white
[Redis-url]: https://redis.io/

[Replit]: https://img.shields.io/badge/replit-667881?style=for-the-badge&logo=replit&logoColor=white
[Replit-url]: https://replit.com/

[RSpec]: https://custom-icon-badges.demolab.com/badge/RSpec-fffcf7?style=for-the-badge&logo=rspec
[RSpec-url]: https://rspec.info/

[RuboCop]: https://img.shields.io/badge/RuboCop-000?logo=rubocop&logoColor=fff&style=for-the-badge
[RuboCop-url]: https://docs.rubocop.org/rubocop-rails/index.html

[Ruby]: https://img.shields.io/badge/Ruby-000000?style=for-the-badge&logo=ruby&logoColor=CC342D
[Ruby-url]: https://www.ruby-lang.org/en/

[Slack]: https://img.shields.io/badge/Slack-4A154B?style=for-the-badge&logo=slack&logoColor=white
[Slack-url]: https://slack.com/trials?remote_promo=f4d95f0b&utm_medium=ppc&utm_source=google&utm_campaign=ppc_google_amer_en_brand_selfserve_discount&utm_term=Slack_Exact_._slack_._e_._c&utm_content=611662283461&gclid=Cj0KCQiA54KfBhCKARIsAJzSrdptOf7OUrgfeH0CWCC7LaOjR8arXoBnBMZjUSTJqmzTKvH6Jh-YXzAaAjfWEALw_wcB&gclsrc=aw.ds

[Tailwind]: https://img.shields.io/badge/tailwindcss-%2338B2AC.svg?style=for-the-badge&logo=tailwind-css&logoColor=white
[Tailwind-url]: https://tailwindcss.com/

[Visual Studio Code]: https://img.shields.io/badge/Visual%20Studio%20Code-0078d7.svg?style=for-the-badge&logo=visual-studio-code&logoColor=white
[Visual Studio Code-url]: https://code.visualstudio.com/

[XCode]: https://img.shields.io/badge/Xcode-007ACC?style=for-the-badge&logo=Xcode&logoColor=white
[XCode-url]: https://developer.apple.com/xcode/

[Zoom]: https://img.shields.io/badge/Zoom-2D8CFF?style=for-the-badge&logo=zoom&logoColor=white
[Zoom-url]: https://zoom.us/

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
