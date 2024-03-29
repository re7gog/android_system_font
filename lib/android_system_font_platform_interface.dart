import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'android_system_font_method_channel.dart';

abstract class AndroidSystemFontPlatform extends PlatformInterface {
  /// Constructs a AndroidSystemFontPlatform.
  AndroidSystemFontPlatform() : super(token: _token);

  static final Object _token = Object();

  static AndroidSystemFontPlatform _instance = MethodChannelAndroidSystemFont();

  /// The default instance of [AndroidSystemFontPlatform] to use.
  ///
  /// Defaults to [MethodChannelAndroidSystemFont].
  static AndroidSystemFontPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [AndroidSystemFontPlatform] when
  /// they register themselves.
  static set instance(AndroidSystemFontPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getFilePath() {
    throw UnimplementedError('getFilePath() has not been implemented.');
  }
}
