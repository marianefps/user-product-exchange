# User Exchange

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

Success return http status created

On Failure return http status :unprocessable_entity

#### Update User

`POST /api/users/:id`

`Content-Type: application/json`

Example:

```json
"user": {
  "country": "br"
}
```

OBS: it's allowed to update only the country field

##### Return

Success return http status :ok

On Failure return http status :unprocessable_entity
On User not found retun http status :not_found


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

##### Return

Success return http status :ok

Failure return http status :unprocessable_entity

with body example:

```json
"message": [
  "Requester doesn't have the products"
]

```

On Requester or Receiver not found retun http status :not_found
