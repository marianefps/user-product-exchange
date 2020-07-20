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
