import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'android_system_font_platform_interface.dart';

/// An implementation of [AndroidSystemFontPlatform] that uses method channels.
class MethodChannelAndroidSystemFont extends AndroidSystemFontPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('android_system_font');

  @override
  Future<String?> getFilePath() async {
    final filePath = await methodChannel.invokeMethod<String>('getFilePath');
    return filePath;
  }
}
