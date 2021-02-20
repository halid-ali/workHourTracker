import 'package:flutter/foundation.dart' show kIsWeb;

class PlatformInfo {
  static bool isWeb() {
    return kIsWeb;
  }
}
