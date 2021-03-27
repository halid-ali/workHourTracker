import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:work_hour_tracker/data/db_provider.dart';
import 'package:work_hour_tracker/data/model/settings_model.dart';

class SettingsRepository {
  static final _dbProvider = DbProvider.provider;

  static Stream<QuerySnapshot> getSettingsByUserId(String userId) {
    return _dbProvider.database
        .collection('settings')
        .where('userId', isEqualTo: userId)
        .snapshots(includeMetadataChanges: true);
  }

  static Future<SettingsModel> getSettings(String id) {
    return _dbProvider.database
        .collection('settings')
        .doc(id)
        .get()
        .then<SettingsModel>(
          (value) => SettingsModel.fromJson(id, value.data()),
        );
  }

  static Future<String> addSettings(SettingsModel settings) async {
    String id;
    await _dbProvider.database
        .collection('settings')
        .add(settings.toJson())
        .then((value) => id = value.id);

    return id;
  }

  static Future<void> updateSettings(SettingsModel settings) async {
    await _dbProvider.database
        .collection('settings')
        .doc(settings.id)
        .update(settings.toJson());
  }

  static Future<void> deleteSettings(String id) async {
    await _dbProvider.database.collection('settings').doc(id).delete();
  }
}
