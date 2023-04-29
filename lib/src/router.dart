// Configure routes.
import 'dart:async';
import 'dart:convert';

import 'package:l/l.dart';
import 'package:medium/src/article.dart';
import 'package:medium/src/database.dart' as db;
import 'package:medium/src/scraper.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

db.Database get _$database => Zone.current[#database] as db.Database;

final $router = Router()
  ..all('/', _rootHandler)
  ..get('/health', _healthHandler)
  ..get('/harvest', _harvestHandler)
  ..get('/get', _getHandler);
//..get('/updates/<token>', _updatesHandler);

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

/// e.g. http://127.0.0.1:8080/harvest?date=2023-04-29
Future<Response> _harvestHandler(Request request) async {
  var articles = <Article>[];
  try {
    final dateFromParameters = request.url.queryParameters['date']
        ?.split('-')
        .map(int.tryParse)
        .whereType<int>()
        .toList();
    final date = dateFromParameters != null && dateFromParameters.length == 3
        ? DateTime.utc(
            dateFromParameters[0],
            dateFromParameters[1],
            dateFromParameters[2],
          )
        : DateTime.now().toUtc().subtract(const Duration(days: 1));
    articles = await Scraper.getArticles(date).then<List<Article>>(
      (v) => v.toList()..sort((a, b) => a.published.compareTo(b.published)),
    );
  } on Object catch (error, stackTrace) {
    l.e(error, stackTrace);
    //Timer(const Duration(seconds: 2), () => exit(2));
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
                created: updated,
                updated: updated,
              ),
            )
            .toList(growable: false),
        mode: db.InsertMode.insertOrReplace,
        //onConflict: db.DoUpdate(),
      ),
    );
  } on Object catch (error, stackTrace) {
    l.e(error, stackTrace);
    //Timer(const Duration(seconds: 2), () => exit(2));
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
    '{"data": {"message": "Saved ${articles.length} articles", "count": ${articles.length}}}',
    headers: <String, String>{
      'Content-Type': 'application/json;charset=utf-8',
    },
  );
}

Future<Response> _getHandler(Request request) async {
  var articles = <Article>[];
  try {
    final dateFromParameters = request.url.queryParameters['date']
        ?.split('-')
        .map(int.tryParse)
        .whereType<int>()
        .toList();
    final date = dateFromParameters != null && dateFromParameters.length == 3
        ? DateTime.utc(
            dateFromParameters[0],
            dateFromParameters[1],
            dateFromParameters[2],
          )
        : DateTime.now().toUtc().subtract(const Duration(days: 1));
    final from =
        DateTime(date.year, date.month, date.day).millisecondsSinceEpoch ~/
            1000;
    final to = from + 86400;
    final database = _$database;
    l.i('Start selecting articles from db');
    final articlesDB = await (database.select(database.article)
          ..where((tbl) => tbl.published.isBetweenValues(from, to))
          ..orderBy([
            (t) => db.OrderingTerm(
                  expression: t.published,
                  mode: db.OrderingMode.asc,
                )
          ])
          ..limit(500))
        .get();
    l.i('Selected ${articlesDB.length} articles');
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
        .toList();
    l.i('Articles from db mapped to Article class');
    articles.sort((a, b) => a.published.compareTo(b.published));
    l.i('Articles sorted');
  } on Object catch (error, stackTrace) {
    l.e(error, stackTrace);
    //Timer(const Duration(seconds: 2), () => exit(2));
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
    _encodeArticles(articles),
    headers: <String, String>{
      'Content-Type': 'application/json;charset=utf-8',
    },
  );
}

/*
/// Get last updates by `token` and `published`
Future<Response> _updatesHandler(Request request, String token) async {
  var articles = <Article>[];
  try {
    final database = _$database;
    final published = await (database.select(database.lastUpdate)
          ..where((tbl) => tbl.token.equals(token))
          ..limit(1))
        .getSingleOrNull()
        .then<int?>((r) => r?.published);
    final articlesDB = await (database.select(database.article)
          ..where((tbl) => tbl.published.isBiggerThanValue(published ?? 0))
          ..orderBy([
            (t) => db.OrderingTerm(
                  expression: t.published,
                  mode: db.OrderingMode.asc,
                )
          ])
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
        .toList()
      ..sort((a, b) => a.published.compareTo(b.published));
    if (articles.isNotEmpty) {
      final updated = articles.last.published.millisecondsSinceEpoch ~/ 1000;
      await database.into(database.lastUpdate).insert(
            db.LastUpdateCompanion.insert(
              token: token,
              published: updated,
            ),
            mode: db.InsertMode.insertOrReplace,
          );
    }
  } on Object catch (error, stackTrace) {
    l.e(error, stackTrace);
    //Timer(const Duration(seconds: 2), () => exit(2));
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
    _encodeArticles(articles),
    headers: <String, String>{
      'Content-Type': 'application/json;charset=utf-8',
    },
  );
}
 */

String _encodeArticles(List<Article> articles) {
  try {
    l.i('Start encoding articles');
    return jsonEncode(
      <String, Object?>{
        'data': <String, Object?>{
          'message': 'Received ${articles.length} articles',
          'articles': articles.map((e) => e.toJson()).toList(),
          'count': articles.length,
        }
      },
    );
  } on Object {
    l.i('Encoding articles failed');
    return '{"error":{"message": "Can not encode articles"}}';
  }
}
