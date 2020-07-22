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

#### Update User

`POST /api/users/:id`
`Content-Type: application/json`

Example:


obs somente country

#### Exchange Inventory

`POST /api/users/:id/product_exchange`
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
