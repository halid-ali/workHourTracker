import 'package:work_hour_tracker/utils/platform_info.dart';
import 'package:work_hour_tracker/utils/web_storage.dart';

import 'preferences.dart';

class Logout {
  static void logout() {
    if (PlatformInfo.isWeb()) {
      WebStorage.instance.userId = null;
    } else {
      Preferences.clear();
    }
  }
}
