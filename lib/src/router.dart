// Configure routes.
import 'package:medium/src/scraper.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

final $router = Router()
  ..get('/', _rootHandler)
  ..get('/image.png', _imageHandler);

Response _rootHandler(Request req) => Response.ok('Hello, World!\n');

Future<Response> _imageHandler(Request request) async {
  final images = await getImages();

  return Response.ok(
    images.first,
    headers: <String, String>{
      'Content-Type': 'image/png',
      'Content-Length': images.first.length.toString(),
    },
  );
}
