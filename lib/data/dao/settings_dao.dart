import 'package:work_hour_tracker/data/database.dart';
import 'package:work_hour_tracker/data/model/settings_model.dart';

class SettingsDao {
  final dbProvider = DatabaseProvider.dbProvider;

  Future<Settings> getSettings() async {
    final db = await dbProvider.database;
    var result = await db.query('settings');

    return result.isNotEmpty ? Settings.fromJson(result.first) : null;
  }

  Future<int> updateSettings(Settings settings) async {
    final db = await dbProvider.database;
    var result = await db.update('settings', settings.toJson());

    return result;
  }
}
