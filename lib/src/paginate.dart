import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:shelf/shelf.dart';

Middleware shelfPaginate({int limit = 10, int maxLimit = 50}) {
  return (Handler innerHandle) {
    return (request) {
      return Future.sync(() => innerHandle(request)).then((response) {
        if (request.headers.containsKey('x-paginate') &&
            (request.headers['x-paginate']!.toLowerCase() == 'true')) {
          return _paginate(
            response,
            int.tryParse(request.url.queryParameters['page'] ?? 'page') ?? 1,
            int.tryParse(request.url.queryParameters['limit'] ?? 'limit') ?? limit,
            maxLimit,
          );
        }

        return response;
      });
    };
  };
}

FutureOr<Response> _paginate(Response response, int page, int limit, int maxLimit) async {
  dynamic body = json.decode(await response.readAsString());

  if (body is Map) throw Exception('shelf-paginate: expected `List` but `Map` informed');

  Map<String, dynamic> newBody = {};

  if (page < 1) page = 1;

  if (limit < 0) limit = 0;

  if (limit > maxLimit) limit = maxLimit;

  final int bodyLength = body.length;
  int endIndex = min(page * limit, bodyLength);
  final int startIndex = (page - 1) * limit;

  if (startIndex >= bodyLength) throw Exception('shelf-paginate: page not exists');

  if (endIndex < bodyLength) {
    newBody.addAll({
      'next': {
        'page': page + 1,
        'limit': limit,
      }
    });
  }

  if (startIndex > 0) {
    newBody.addAll({
      'previous': {
        'page': page - 1,
        'limit': limit,
      }
    });
  }

  newBody.addAll({'results': body.sublist(startIndex, endIndex)});

  return response.change(body: jsonEncode(newBody));
}
