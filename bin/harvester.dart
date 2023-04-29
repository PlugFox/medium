import 'dart:async';
import 'dart:io' as io;

import 'package:l/l.dart';
import 'package:medium/src/article.dart';
import 'package:medium/src/database.dart' as db;
import 'package:medium/src/scraper.dart';
import 'package:path/path.dart' as p;
import 'package:puppeteer/puppeteer.dart';

void main() => Future<void>(() async {
      const days = 15;
      final now = DateTime.now();

      // Init database
      final directory = p.joinAll([io.Directory.current.path, 'data']);
      io.Directory(directory).createSync(recursive: true);
      final database = db.Database(
        path: io.File(p.join(directory, 'db.sqlite')),
        logStatements: false,
      );

      // Init browser
      final browser = await puppeteer.launch(
        headless: true,
        defaultViewport: const DeviceViewport(
          width: 800,
          height: 2560,
          deviceScaleFactor: 1,
          isMobile: false,
          isLandscape: false,
          hasTouch: false,
        ),
        timeout: const Duration(seconds: 30),
        args: <String>['--no-sandbox', '--disable-setuid-sandbox'],
      );

      try {
        // Scrap articles
        final articles = await Stream<int>.fromIterable(
          Iterable.generate(days, (i) => days - i),
        )
            .asyncMap<Set<Article>>(
              (i) => Scraper.getArticles(
                now.subtract(Duration(days: i)),
                browser: browser,
              ),
            )
            .expand<Article>((e) => e)
            .toList()
            .then<Set<Article>>((articles) => articles.toSet());

        // Save articles
        final updated =
            db.Value<int>(DateTime.now().millisecondsSinceEpoch ~/ 1000);
        await database.batch(
          (batch) => batch.insertAll(
            database.article,
            (articles.toList()
                  ..sort((a, b) => a.published.compareTo(b.published)))
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
        l.i('Saved ${articles.length} articles');
        await Future<void>.delayed(const Duration(seconds: 5));
      } on Object catch (error, stackTrace) {
        l.e(
          'Failed to harvest articles: $error',
          stackTrace,
        );
        await Future<void>.delayed(const Duration(seconds: 1));
        rethrow;
      } finally {
        browser.close().ignore();
        database.close().ignore();
      }
    });
