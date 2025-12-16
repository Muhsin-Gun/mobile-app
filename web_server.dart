import 'dart:io';
import 'dart:convert';

void main() async {
  final port = int.fromEnvironment('PORT', defaultValue: 5000);
  final server = await HttpServer.bind('0.0.0.0', port);
  print('CrypTex Trading Server running at http://0.0.0.0:$port/');

  await for (final request in server) {
    handleRequest(request);
  }
}

Future<void> handleRequest(HttpRequest request) async {
  String path = request.uri.path;
  if (path == '/') path = '/index.html';

  final file = File('build/web$path');
  
  if (await file.exists()) {
    final contentType = getContentType(path);
    request.response.headers.contentType = contentType;
    request.response.headers.add('Cache-Control', 'no-cache');
    request.response.headers.add('Access-Control-Allow-Origin', '*');
    await request.response.addStream(file.openRead());
  } else {
    final indexFile = File('build/web/index.html');
    if (await indexFile.exists()) {
      request.response.headers.contentType = ContentType.html;
      request.response.headers.add('Cache-Control', 'no-cache');
      request.response.headers.add('Access-Control-Allow-Origin', '*');
      await request.response.addStream(indexFile.openRead());
    } else {
      request.response.statusCode = HttpStatus.notFound;
      request.response.write('Not Found');
    }
  }
  
  await request.response.close();
}

ContentType getContentType(String path) {
  if (path.endsWith('.html')) return ContentType.html;
  if (path.endsWith('.css')) return ContentType('text', 'css');
  if (path.endsWith('.js')) return ContentType('application', 'javascript');
  if (path.endsWith('.json')) return ContentType.json;
  if (path.endsWith('.png')) return ContentType('image', 'png');
  if (path.endsWith('.jpg') || path.endsWith('.jpeg')) return ContentType('image', 'jpeg');
  if (path.endsWith('.gif')) return ContentType('image', 'gif');
  if (path.endsWith('.svg')) return ContentType('image', 'svg+xml');
  if (path.endsWith('.ico')) return ContentType('image', 'x-icon');
  if (path.endsWith('.woff')) return ContentType('font', 'woff');
  if (path.endsWith('.woff2')) return ContentType('font', 'woff2');
  if (path.endsWith('.ttf')) return ContentType('font', 'ttf');
  if (path.endsWith('.otf')) return ContentType('font', 'otf');
  return ContentType.binary;
}
