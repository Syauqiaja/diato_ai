import 'dart:convert';
import 'dart:io';

import 'package:diato_ai/core/di/injection.dart';
import 'package:diato_ai/core/routes/route.dart';
import 'package:diato_ai/features/scanner/presentation/scanner_detail_screen.dart';
import 'package:diato_ai/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'sample_scan_image.dart';

/// Walks through the main screens and captures one screenshot of each for the
/// App Store and Google Play listings.
///
/// Run per device, for example:
///   SCREENSHOT_DIR=iphone flutter drive --driver=test_driver/integration_test.dart \
///     --target=integration_test/store_screenshots_test.dart -d DEVICE_ID
///
/// The scan screenshot uploads a real image to the production API, which stores
/// a scan record.
void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

  testWidgets('store screenshots', (tester) async {
    await setupInjection();
    await tester.pumpWidget(const MyApp());

    if (defaultTargetPlatform == TargetPlatform.android) {
      await binding.convertFlutterSurfaceToImage();
    }

    // Screens load from the network, so wait in real time rather than
    // pumpAndSettle, which never settles while the video player animates.
    Future<void> shot(String name, {int seconds = 5}) async {
      for (var i = 0; i < seconds * 10; i++) {
        await tester.pump(const Duration(milliseconds: 100));
        await Future<void>.delayed(const Duration(milliseconds: 100));
      }
      await binding.takeScreenshot(name);
    }

    await shot('01_home', seconds: 8);

    final image = File('${Directory.systemTemp.path}/sample_scan.jpg');
    await image.writeAsBytes(base64Decode(sampleScanImageBase64));
    AppRoutes.router.pushNamed(ScannerDetailScreen.routeName, extra: image.path);
    await shot('02_scan_result', seconds: 10);
    AppRoutes.router.pop();

    AppRoutes.router.go('/explore');
    await shot('03_explore');

    AppRoutes.router.push('/content-detail/1');
    await shot('04_content');
    AppRoutes.router.pop();

    AppRoutes.router.go('/map');
    await shot('05_map', seconds: 8);

    AppRoutes.router.go('/diatom-calculator');
    await shot('06_calculator');

    AppRoutes.router.push('/settings');
    await shot('07_about');
  });
}
