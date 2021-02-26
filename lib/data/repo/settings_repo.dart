import 'package:work_hour_tracker/data/dao/settings_dao.dart';
import 'package:work_hour_tracker/data/model/settings_model.dart';

class SettingsRepository {
  final settingsDao = SettingsDao();

  Future<Settings> getSettings() => settingsDao.getSettings();

  Future updateSettings(Settings user) => settingsDao.updateSettings(user);
}
