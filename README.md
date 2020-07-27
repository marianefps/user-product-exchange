# User Exchange


- [API](#api)
  - [Users](#users)
    - [Create User](#create-user)
    - [Update User](#update-user)
    - [Make User on Vacation](#make-user-on-vacation)
    - [Make User return vacation](#make-user-return-vacation)
    - [Exchange Inventory](#exchange-inventory)
  - [Report](#report)
    - [Percentage users on vacation](#percentage-users-on-vacation)
    - [Percentage users working](#percentage-users-working)
    - [Average users equipment](#average-users-equipment)
    - [Total price equipments on vacation](#total-price-equipments-on-vacation)


## API

### Users

#### Create User

`POST /api/users`
`Content-Type: application/json`

Example:

```json
{
  "user": {
    "name": "Jane Doe",
    "username": "Janed",
    "email": "janed@email.com",
    "birth_date": "22/01/2000",
    "country": "br",
    "inventories_attributes": [{
     	"product": "notebook" ,
      "quantity": 20
    }]
  }
}
```

products available: `notebook`, `desktop_gamer`, `laser_printer`, `smartphone` and `mouse`

##### Return

Success return http status `:created`

On Failure return http status `:unprocessable_entity`

#### Update User

`POST /api/users/:id`

`Content-Type: application/json`

Example:

```json
{
  "user": {
    "country": "br"
  }
}
```

OBS: it's allowed to update only the country field

##### Return

Success return http status `:no_content`

On Failure return http status `:unprocessable_entity`

On User not found retun http status `:not_found`


#### Make User on Vacation

`POST /api/users/:id/on_vacation`

`Content-Type: application/json`

##### Return

Success return http status `:no_content`

On Failure return http status `:unprocessable_entity`

On User not found retun http status `:not_found`

#### Make User return vacation

`POST /api/users/:id/return_vacation`

`Content-Type: application/json`

##### Return

Success return http status `:no_content`

On Failure return http status `:unprocessable_entity`

On User not found retun http status `:not_found`


#### Exchange Inventory

`POST /api/users/:id/exchange`

`Content-Type: application/json`

```json
{
  "products_requester": [
    {"product": "desktop_gamer", "quantity": 1 }
  ],
  "receiver": 4,
  "products_receiver": [
    {"product": "notebook", "quantity": 1 },
    {"product": "smartphone", "quantity": 1 }
  ]
}
```

Note: the exchange must obey when the equipment price sum sticks to the table below:


| Product       | Quantity |
| ------------- |:--------:|
| desktop_gamer | 252      |
| notebook      | 202      |
| laser_printer | 126      |
| smartphone    | 50       |
| mouse         | 20       |


##### Return

Success return http status `:ok`

Failure return http status `:unprocessable_entity` with body example:

```json
{
  "message": [
    "Requester doesn't have the products"
  ]
}
```

On Requester or Receiver not found retun http status `:not_found`


### Report

#### Percentage users on vacation


`GET /api/reports/percentage_users_on_vacation`

`Content-Type: application/json`

##### Return

Success return http status `:ok` with body

```json
{
 "percentage_users_on_vacation": 25
}
```

#### Percentage users working


`GET /api/reports/percentage_users_working`

`Content-Type: application/json`

##### Return

Success return http status `:ok` with body

```json
{
  "percentage_users_working": 75
}
```

#### Average users equipment


`GET /api/reports/avg_users_equipment`

`Content-Type: application/json`

##### Return

Success return http status `:ok` with body

```json
{
  "avg_users_equipment": {
    "desktop_gamer": 15,
    "notebook": 20,
    "laser_printer": 50,
    "smartphone": 30,
    "mouse": 10
  }
}
```

#### Total price equipments on vacation


`GET /api/reports/total_price_equipments_on_vacation`

`Content-Type: application/json`

##### Return

Success return http status `:ok` with body

```json
{
  "total_price_equipments_on_vacation": 872
}
```
