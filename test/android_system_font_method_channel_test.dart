import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:android_system_font/android_system_font_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelAndroidSystemFont platform = MethodChannelAndroidSystemFont();
  const MethodChannel channel = MethodChannel('android_system_font');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '/system/fonts/Roboto-Regular.ttf';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('getFilePath', () async {
    expect(await platform.getFilePath(), '/system/fonts/Roboto-Regular.ttf');
  });
}
