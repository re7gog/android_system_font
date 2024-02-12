// This is a basic Flutter integration test.
//
// Since integration tests run in a full Flutter application, they can interact
// with the host side of a plugin implementation, unlike Dart unit tests.
//
// For more information about Flutter integration tests, please see
// https://docs.flutter.dev/cookbook/testing/integration/introduction


import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:android_system_font/android_system_font.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('getFilePath test', (WidgetTester tester) async {
    final AndroidSystemFont plugin = AndroidSystemFont();
    final String? filePath = await plugin.getFilePath();
    // The version string depends on the host platform running the test, so
    // just assert that some non-empty string is returned.
    expect(filePath?.isNotEmpty, true);
    final bool isPath = filePath!.startsWith("/system/fonts/") ||
        filePath.startsWith("/product/fonts/");
    expect(isPath, true);
  });
}
