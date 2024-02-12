import 'package:flutter_test/flutter_test.dart';
import 'package:android_system_font/android_system_font.dart';
import 'package:android_system_font/android_system_font_platform_interface.dart';
import 'package:android_system_font/android_system_font_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockAndroidSystemFontPlatform
    with MockPlatformInterfaceMixin
    implements AndroidSystemFontPlatform {

  @override
  Future<String?> getFilePath() => Future.value('/system/fonts/Roboto-Regular.ttf');
}

void main() {
  final AndroidSystemFontPlatform initialPlatform = AndroidSystemFontPlatform.instance;

  test('$MethodChannelAndroidSystemFont is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelAndroidSystemFont>());
  });

  test('getFilePath', () async {
    AndroidSystemFont androidSystemFontPlugin = AndroidSystemFont();
    MockAndroidSystemFontPlatform fakePlatform = MockAndroidSystemFontPlatform();
    AndroidSystemFontPlatform.instance = fakePlatform;

    expect(await androidSystemFontPlugin.getFilePath(), '/system/fonts/Roboto-Regular.ttf');
  });
}
