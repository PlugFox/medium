import 'dart:async';
import 'dart:io' as io;

import 'package:args/args.dart';
import 'package:l/l.dart';
import 'package:medium/src/database.dart' as db;
import 'package:medium/src/router.dart';
import 'package:medium/src/runner.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as p;
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';

void main(List<String> args) {
  // ignore: avoid_print
  print('Starting server');
  final parser = ArgParser()..addOption('data', abbr: 'd');
  final data = parser.parse(args)['data'] as String? ??
      io.Platform.environment['DATA'] ??
      p.join(io.Directory.current.path, 'data');

  io.Directory(data).createSync(recursive: true);

  final $serverDatabase = db.Database(
    path: io.File(p.join(data, 'db.sqlite')),
    logStatements: true,
  );

  runZoned<void>(
    () => l.capture(
      () => runner<ServerConfig>(
        initialization: () async {
          final stopwatch = Stopwatch()..start();

          // Use any available host or container IP (usually `0.0.0.0`).
          final ip = io.InternetAddress.anyIPv4;

          // For running in containers, we respect the PORT environment variable.
          final port = int.parse(io.Platform.environment['PORT'] ?? '8080');

          // Configure a pipeline that logs requests.
          final httpHandler = const Pipeline()
              //.addMiddleware(exceptionResponse())
              .addMiddleware(
                logRequests(
                  logger: (msg, isError) => isError ? l.e(msg) : l.i(msg),
                ),
              )
              //.addMiddleware(authMiddleware)
              .addHandler($router);

          // Запуск http сервера
          final httpServer = await serve(
            httpHandler,
            ip,
            port,
            shared: false,
          );

          l.i(
            'Server started in ${(stopwatch..stop()).elapsedMilliseconds} ms '
            'at http://${httpServer.address.host}:${httpServer.port}',
          );

          return ServerConfig(
            servers: <io.HttpServer>[
              httpServer,
            ],
          );
        },
        onError: (error, stackTrace) async {
          l.e('Top level error: $error', stackTrace);
        },
        onShutdown: (config) async {
          l.i('Shutting down server');
          $serverDatabase.close().ignore();
          try {
            await Future.wait<void>(config.servers.map((s) => s.close()))
                .timeout(const Duration(seconds: 5));
          } on TimeoutException {
            await Future.wait<void>(
              config.servers.map((s) => s.close(force: true)),
            ).timeout(const Duration(seconds: 5));
          }
        },
      ),
      const LogOptions(
        handlePrint: true,
        outputInRelease: true,
      ),
    ),
    zoneValues: <Symbol, Object?>{
      #database: $serverDatabase,
    },
  );
}

@immutable
class ServerConfig {
  final List<io.HttpServer> servers;
  const ServerConfig({
    required this.servers,
  });
}
