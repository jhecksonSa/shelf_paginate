## shelf_paginate

Create a paging based on a json array
Inspirated by express-paginate and horse-paginate

## Usage

On get the HEADER must have x-paginate = true
limit = x - registration limit per page
page = x - current page that shelf_paginate will return
 

```dart
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_paginate/shelf_paginate.dart';

const API_URL = 'www.api_shelf_paginate.com/start?page=1&limit=2';
const Map<String, Object?> header = {'x-paginate': 'true'};

void main() async {
  var handler =
      const Pipeline()
        .addMiddleware(logRequests())
        .addMiddleware(shelPaginate(maxlimit: 100))
        .addHandler(_paginateRequest);

  var server = await shelf_io.serve(handler, 'localhost', 8080);

  print('Serving at http://${server.address.host}:${server.port}');
}

Response _paginateRequest(Request request) =>
      return Response.ok([
        {
          "id": 1,
          "name": "Messi",
          "club": "PSG",
        },
        {
          "id": 2,
          "name": "Mbappé",
          "club": "PSG",
        },
        {
          "id": 3,
          "name": "Mohamed Salah",
          "club": "Liverpool",                    
        },
        {
          "id": 4,
          "name": "Cristiano Ronaldo",
          "club": "Manchester United",                    
        },
        {
          "id": 5,
          "name": "Griezmann",
          "club": "Atlético Madrid",          
        },
        {
          "id": 6,
          "name": "Pogba",
          "club": "Juventus",          
        }
      ]);
    });
```

## Project credit

[Create A pagination middleware with Node.js](https://medium.com/learnfactory-nigeria/create-a-pagination-middleware-with-node-js-fe4ec5dca80f)
[express_paginate](https://github.com/expressjs/express-paginate)
[horse_paginate](https://github.com/academiadocodigo/Horse-Paginate)



