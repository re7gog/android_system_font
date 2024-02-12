
import 'android_system_font_platform_interface.dart';

class AndroidSystemFont {
  Future<String?> getFilePath() {
    return AndroidSystemFontPlatform.instance.getFilePath();
  }
}
