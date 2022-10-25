import 'dart:async';
import 'dart:io' as io;

import 'package:html/dom.dart' as html;
import 'package:html/parser.dart' as html show parse;
import 'package:http/http.dart';
import 'package:l/l.dart';
import 'package:medium/src/article.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as p;
import 'package:puppeteer/puppeteer.dart';

@sealed
abstract class Scraper {
  Scraper._();

  static Future<Set<Article>> getArticles(
    DateTime date, {
    final Browser? browser,
  }) async {
    final headless =
        io.Platform.environment['HEADLESS']?.toLowerCase() != 'false';

    final tags = io.Platform.environment['TAGS']
            ?.split(',')
            .map((e) => e.trim().toLowerCase())
            .toList(growable: false) ??
        <String>['flutter', 'dart'];

    // Download the Chromium binaries, launch it and connect to the "DevTools"
    final internalBrowser = browser ??
        await puppeteer.launch(
          headless: headless,
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

    final articles = <Article>{};
    try {
      for (final tag in tags) {
        final newArticles = await _scrapTag(
          browser: internalBrowser,
          tag: tag,
          year: date.year,
          month: date.month,
          day: date.day,
        );
        articles.addAll(newArticles);
      }

      l.i('Found ${articles.length} articles');
      return articles;
    } on Object catch (error, stackTrace) {
      l.e(
        'Failed to scrap articles: $error',
        StackTrace.fromString(
          'Successful scrapped: ${articles.length}\n'
          'Error: ${Error.safeToString(error)}\n'
          '$stackTrace',
        ),
      );
      rethrow;
    } finally {
      if (browser == null) {
        Timer(
          const Duration(milliseconds: 3),
          () => internalBrowser.close().ignore(),
        );
      }
    }
  }

  static Future<List<Article>> _scrapTag({
    required Browser browser,
    required String tag,
    required int year,
    required int month,
    required int day,
  }) async {
    // Open a new tab
    final page = await browser.newPage();

    final uri = Uri.parse(
      p.normalize(
        p.joinAll(<String>[
          'https://medium.com',
          'tag',
          tag,
          'archive',
          ...<int?>[year, month, day]
              .takeWhile((value) => value != null)
              .map<String>((value) => value.toString().padLeft(2, '0')),
        ]),
      ),
    );

    // Go to a page and wait to be fully loaded
    // e.g. https://medium.com/tag/dart/archive
    await page.goto(
      uri.toString(),
      wait: Until.networkIdle,
      timeout: const Duration(seconds: 30),
    );

    /* Future<void> autoScroll() => page.evaluate<void>('''
      async () => {
        await new Promise((resolve) => {
          var totalHeight = 0;
          var distance = 100;
          var timer = setInterval(() => {
              var scrollHeight = document.body.scrollHeight;
              window.scrollBy(0, distance);
              totalHeight += distance;

              if(totalHeight >= scrollHeight - window.innerHeight){
                  clearInterval(timer);
                  resolve();
              }
          }, 100);
        });
      }
      '''); */

    Future<void> autoScroll() async {
      var previousHeight = 0;
      while (true) {
        final newHeight = await page
            .evaluate<int>('document.body.scrollHeight - window.innerHeight')
            .timeout(const Duration(seconds: 30));
        if (newHeight == previousHeight) break;
        previousHeight = newHeight;
        await page
            .evaluate<void>('window.scrollTo(0, document.body.scrollHeight)')
            .timeout(const Duration(seconds: 30));
        await Future<void>.delayed(const Duration(milliseconds: 1000));
      }
    }

    await autoScroll();

    const selector = '.js-postStream .postArticle-readMore a';
    await page.waitForSelector(selector);
    final hrefs = await page
        .evaluate<List<Object?>>(
          'Array.from(document.querySelectorAll("$selector"))'
          '.map(x => x.href).filter(x => !!x)',
        )
        .then<List<Uri>>(
          (l) => l
              .whereType<String>()
              .where((e) => e.isNotEmpty)
              .map<String>((e) => e.trim())
              .map<Uri?>(Uri.tryParse)
              .whereType<Uri>()
              .toList(),
        );

    final articles = <Article>[];
    final client = Client();
    final published = DateTime(year, month, day).toUtc().toIso8601String();
    for (final href in hrefs) {
      // Open a new tab
      //final page = await browser.newPage();
      try {
        /* await page.goto(
          href,
          wait: Until.networkIdle,
          timeout: const Duration(seconds: 30),
        );
        final documentHtml =
            await page.evaluate<String>('document.documentElement.outerHTML'); */
        final documentHtml =
            await client.get(href).then<String>((rsp) => rsp.body);
        if (documentHtml.isEmpty) continue;
        final document = html.parse(documentHtml);
        final article = _articleFromHead(document.head, href, published);
        articles.add(article);
      } on Object catch (error, stackTrace) {
        l.w(
          'Can not extract article from url: $error',
          StackTrace.fromString(
            'Href: $href\n'
            'Error: ${Error.safeToString(error)}\n'
            '$stackTrace',
          ),
        );
      } finally {
        //page.close().ignore();
      }
    }
    client.close();

    /* final outerHTML =
        await page.evaluate<String>('document.documentElement.outerHTML'); */

    //final document = parse(content);

    /*
    // Ensure that the element is loaded
    const selector = '.js-postStream';
    await page.waitForSelector(selector);
    final content = await page.$(selector);
    await page.waitForSelector('.postArticle-content');
    final articlesRaw = await content.$$('.postArticle-content');
    */

    /*
    // For this example, we force the "screen" media-type because sometime
    // CSS rules with "@media print" can change the look of the page.
    await page.emulateMediaType(MediaType.screen);
    await io.Directory('example').create(recursive: true);
    await page.pdf(
      format: PaperFormat.a4,
      printBackground: true,
      output: io.File('example/$tag.pdf').openWrite(),
      pageRanges: '1',
    );
    await page
        .screenshot(format: ScreenshotFormat.png, fullPage: true)
        .then(io.File('example/$tag.png').writeAsBytes);
    await io.File('example/$tag.png').writeAsBytes(screenshot);
    */

    //final screenshot = await content.screenshot(format: ScreenshotFormat.png);

    page.close().ignore();

    return articles;
  }

  static Article _articleFromHead(
    html.Element? head,
    Uri url,
    String published,
  ) {
    if (head == null) throw ArgumentError.notNull('head');
    final metas = head.getElementsByTagName('meta');
    final properties = <String, String>{
      for (final meta in metas)
        meta.attributes['property'] ?? meta.attributes['name'] ?? 'unknown':
            meta.attributes['content'] ?? meta.attributes['value'] ?? '',
      '_id': <String>[url.host, ...url.pathSegments]
          .map<String>((e) => e.trim().toLowerCase())
          .where((e) => e.isNotEmpty)
          .map<String>((e) => e.hashCode.toRadixString(36))
          .join('-'),
      '_url': url.toString(),
      '_published': published,
    };

    String select(List<String> tags) =>
        tags.map((tag) => properties[tag]).whereType<String>().first;

    DateTime selectDate(List<String> tags) => tags
        .map((tag) => properties[tag])
        .whereType<String>()
        .map<DateTime?>(DateTime.tryParse)
        .whereType<DateTime>()
        .first;

    return Article(
      id: select(
        <String>[
          'article:id',
          'id',
          '_id',
        ],
      ),
      uri: select(
        <String>[
          'al:web:url',
          'og:url',
          'url',
          '_url',
        ],
      ),
      title: select(
        <String>[
          'og:title',
          'article:title',
          'twitter:title',
          'title',
          '_title',
        ],
      ),
      excerpt: select(
        <String>[
          'article:excerpt',
          'og:description',
          'description',
          'twitter:description',
          'title',
          'twitter:title',
          'og:title',
          'article:title',
          '_excerpt',
          '_description',
          '_title',
        ],
      ),
      published: selectDate(
        <String>[
          'article:published_time',
          'og:article:published_time',
          'twitter:tile:info2:text',
          'published',
          '_published',
        ],
      ),
      author: select(
        <String>[
          'author',
          'og:article:author',
          'article:author',
          'twitter:site',
          'twitter:creator',
          'twitter:tile:info1:text',
          '_author',
          '_creator',
          '_publisher',
        ],
      ),
      blog: select(
        <String>[
          'article:author',
          'article:publisher',
          'og:article:publisher',
          'author',
          'twitter:site',
          'twitter:creator',
          '_blog',
          '_publisher',
          '_creator',
          '_author',
        ],
      ),
      android: select(
        <String>[
          'al:android:url',
          'twitter:app:url:android',
          'al:web:url',
          'og:url',
          'url',
          '_url',
        ],
      ),
      ios: select(
        <String>[
          'al:ios:url',
          'twitter:app:url:iphone',
          'al:web:url',
          'og:url',
          'url',
          '_url',
        ],
      ),
    );
  }
}
