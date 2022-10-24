import 'dart:async';

import 'package:path/path.dart' as p;
import 'package:puppeteer/puppeteer.dart';

void main() => getImages();

Future<List<List<int>>> getImages() async {
  const headless = true;
  const tags = <String>['flutter']; // 'dart'
  final now = DateTime.now();

  // Download the Chromium binaries, launch it and connect to the "DevTools"
  final browser = await puppeteer.launch(
    headless: headless,
    defaultViewport: const DeviceViewport(
      width: 800,
      height: 1280,
      deviceScaleFactor: 1,
      isMobile: true,
      isLandscape: false,
      hasTouch: true,
    ),
    timeout: const Duration(seconds: 30),
    args: <String>['--no-sandbox', '--disable-setuid-sandbox'],
  );

  final images = <List<int>>[];
  try {
    for (final tag in tags) {
      final image = await scrapTag(
        browser,
        tag,
        year: now.year,
        month: now.month,
        //day: now.day,
      );
      images.add(image);
    }

    return images;
  } on Object {
    rethrow;
  } finally {
    // Gracefully close the browser's process
    await browser.close();
  }
}

Future<List<int>> scrapTag(
  Browser browser,
  String tag, {
  int? year,
  int? month,
  int? day,
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
      await Future<void>.delayed(const Duration(seconds: 2));
    }
  }

  await autoScroll();

  // For this example, we force the "screen" media-type because sometime
  // CSS rules with "@media print" can change the look of the page.
  await page.emulateMediaType(MediaType.screen);

  // Ensure that the element is loaded
  const selector = '.js-postStream';
  await page.waitForSelector(selector);
  final content = await page.$(selector);

  /*
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

  final screenshot = await content.screenshot(format: ScreenshotFormat.png);

  page.close().ignore();

  return screenshot;
}
