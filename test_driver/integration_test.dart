import 'dart:io';

import 'package:integration_test/integration_test_driver_extended.dart';

/// Saves each screenshot the test takes to `store/screenshots/<SCREENSHOT_DIR>/`.
Future<void> main() {
  final dir = Platform.environment['SCREENSHOT_DIR'] ?? 'device';
  return integrationDriver(
    onScreenshot: (name, bytes, [args]) async {
      final file = File('store/screenshots/$dir/$name.png');
      await file.create(recursive: true);
      await file.writeAsBytes(bytes);
      return true;
    },
  );
}
