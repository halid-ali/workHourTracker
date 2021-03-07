import 'package:work_hour_tracker/utils/platform_info.dart';
import 'package:work_hour_tracker/utils/web_storage.dart';

import 'preferences.dart';

class Login {
  static bool isLogged() {
    bool result = false;

    if (PlatformInfo.isWeb()) {
      result = WebStorage.instance.userId != null;
    } else {
      Preferences.contains('userId').then((value) => result = value);
    }

    return result;
  }
}
