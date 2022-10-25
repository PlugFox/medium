// Configure routes.
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:l/l.dart';
import 'package:medium/src/article.dart';
import 'package:medium/src/database.dart' as db;
import 'package:medium/src/scraper.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

db.Database get _$database => Zone.current[#database] as db.Database;

final $router = Router()
  ..get('/', _rootHandler)
  ..get('/health', _healthHandler)
  ..get('/harvest', _harvestHandler)
  ..get('/get', _getHandler)
  ..get('/updates/<token>', _updatesHandler)
  ..all('/*', _rootHandler);

Response _rootHandler(Request request) => Response.badRequest(
      body: jsonEncode(
        <String, Object?>{
          'error': <String, Object?>{'message': 'Bad Request'},
          'stack_trace': StackTrace.current.toString(),
        },
      ),
      headers: <String, String>{
        'Content-Type': 'application/json;charset=utf-8',
      },
    );

Response _healthHandler(Request request) => Response.ok(
      jsonEncode(
        <String, Object?>{
          'data': <String, Object?>{
            // todo: database healthcheck
            'message': 'Everything fine',
            'status': 'ok'
          }
        },
      ),
      headers: <String, String>{
        'Content-Type': 'application/json;charset=utf-8',
      },
    );

Future<Response> _harvestHandler(Request request) async {
  var articles = <Article>{};
  try {
    final dateFromParameters = request.url.queryParameters['date'];
    final date = (dateFromParameters != null
            ? DateTime.tryParse(dateFromParameters)
            : null) ??
        DateTime.now().subtract(const Duration(days: 1));
    articles = await Scraper.getArticles(date);
  } on Object catch (error, stackTrace) {
    Timer(const Duration(seconds: 2), () => exit(2));
    return Response.internalServerError(
      body: jsonEncode(
        <String, Object?>{
          'error': <String, Object?>{
            'message': error.toString(),
            'stack_trace': stackTrace.toString(),
          }
        },
      ),
      headers: <String, String>{
        'Content-Type': 'application/json;charset=utf-8',
      },
    );
  }
  l.i('Founded ${articles.length} articles');

  if (articles.isEmpty) {
    return Response.ok(
      jsonEncode(
        <String, Object?>{
          'data': <String, Object?>{
            'message': 'No articles found',
            'articles': <String>[],
            'count': 0,
          }
        },
      ),
      headers: <String, String>{
        'Content-Type': 'application/json;charset=utf-8',
      },
    );
  }

  try {
    final database = _$database;
    // Save articles
    final updated =
        db.Value<int>(DateTime.now().millisecondsSinceEpoch ~/ 1000);
    await database.batch(
      (batch) => batch.insertAll(
        database.article,
        articles
            .map<db.ArticleCompanion>(
              (e) => db.ArticleCompanion.insert(
                id: e.id,
                uri: e.uri,
                title: e.title,
                excerpt: e.excerpt,
                published: e.published.millisecondsSinceEpoch ~/ 1000,
                author: e.author,
                blog: e.blog,
                android: e.android,
                ios: e.ios,
                updated: updated,
              ),
            )
            .toList(growable: false),
        mode: db.InsertMode.insertOrReplace,
        //onConflict: db.DoUpdate(),
      ),
    );
  } on Object catch (error, stackTrace) {
    Timer(const Duration(seconds: 2), () => exit(2));
    return Response.internalServerError(
      body: jsonEncode(
        <String, Object?>{
          'error': <String, Object?>{
            'message': error.toString(),
            'stack_trace': stackTrace.toString(),
          }
        },
      ),
      headers: <String, String>{
        'Content-Type': 'application/json;charset=utf-8',
      },
    );
  }
  l.i('Saved ${articles.length} articles');

  return Response.ok(
    jsonEncode(
      <String, Object?>{
        'data': <String, Object?>{
          'message': 'Saved ${articles.length} articles',
          'articles': articles.toList(growable: false),
          'count': articles.length,
        }
      },
    ),
    headers: <String, String>{
      'Content-Type': 'application/json;charset=utf-8',
    },
  );
}

Future<Response> _getHandler(Request request) async {
  var articles = <Article>{};
  try {
    final dateFromParameters = request.url.queryParameters['date'];
    final date = (dateFromParameters != null
            ? DateTime.tryParse(dateFromParameters)
            : null) ??
        DateTime.now().subtract(const Duration(days: 1));
    final from =
        DateTime(date.year, date.month, date.day).millisecondsSinceEpoch ~/
            1000;
    final to = from + 86400;
    final database = _$database;
    final articlesDB = await (database.select(database.article)
          ..where(
            (tbl) => tbl.published
                .isBetween(db.Variable<int>(from), db.Variable<int>(to)),
          )
          ..limit(500))
        .get();
    articles = articlesDB
        .map<Article>(
          (e) => Article(
            id: e.id,
            uri: e.uri,
            title: e.title,
            excerpt: e.excerpt,
            published: DateTime.fromMillisecondsSinceEpoch(e.published * 1000),
            author: e.author,
            blog: e.blog,
            android: e.android,
            ios: e.ios,
          ),
        )
        .toSet();
  } on Object catch (error, stackTrace) {
    Timer(const Duration(seconds: 2), () => exit(2));
    return Response.internalServerError(
      body: jsonEncode(
        <String, Object?>{
          'error': <String, Object?>{
            'message': error.toString(),
            'stack_trace': stackTrace.toString(),
          }
        },
      ),
      headers: <String, String>{
        'Content-Type': 'application/json;charset=utf-8',
      },
    );
  }

  return Response.ok(
    jsonEncode(
      <String, Object?>{
        'data': <String, Object?>{
          'message': 'Received ${articles.length} articles',
          'articles': articles.toList(growable: false),
          'count': articles.length,
        }
      },
    ),
    headers: <String, String>{
      'Content-Type': 'application/json;charset=utf-8',
    },
  );
}

/// Get last updates by `token` and `published`
FutureOr<Response> _updatesHandler(Request request, String token) =>
    Response.badRequest(
      body: jsonEncode(
        <String, Object?>{
          'error': <String, Object?>{'message': 'Unimplemented'},
          'stack_trace': StackTrace.current.toString(),
        },
      ),
      headers: <String, String>{
        'Content-Type': 'application/json;charset=utf-8',
      },
    );
