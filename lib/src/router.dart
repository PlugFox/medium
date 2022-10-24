// Configure routes.
import 'dart:convert';
import 'dart:io';

import 'package:medium/src/scraper.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

final $router = Router()
  ..get('/', _rootHandler)
  ..get('/image.png', _imageHandler);

Response _rootHandler(Request req) => Response.ok('Hello, World!\n');

Future<Response> _imageHandler(Request request) async {
  final date = DateTime.now().subtract(const Duration(days: 1));
  final articles = await Scraper.getArticles(date);
  return Response.ok(
    jsonEncode(<String, Object?>{'data': articles}),
    headers: <String, String>{
      'Content-Type': ContentType.json.mimeType,
    },
  );
}
