import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:work_hour_tracker/data/db_provider.dart';
import 'package:work_hour_tracker/data/model/option_model.dart';

class OptionRepository {
  static final _dbProvider = DbProvider.provider;

  static Stream<QuerySnapshot> getWorkHourOptions() {
    return _dbProvider.database
        .collection('workHourOptions')
        .snapshots(includeMetadataChanges: true);
  }

  static Future<OptionModel> getWorkHourOption(String id) async {
    return _dbProvider.database
        .collection('workHourOptions')
        .doc(id)
        .get()
        .then<OptionModel>((value) {
      return OptionModel.fromJson(id, value.data());
    });
  }

  static Future<String> addWorkHourOption(OptionModel workHourOption) async {
    String id;
    await _dbProvider.database
        .collection('workHourOptions')
        .add(workHourOption.toJson())
        .then((value) => id = value.id);

    return id;
  }

  static Future<void> updateWorkHourOption(OptionModel workHourOption) async {
    await _dbProvider.database
        .collection('workHourOptions')
        .doc(workHourOption.id)
        .update(workHourOption.toJson());
  }

  static Future<void> deleteWorkHourOption(String id) async {
    await _dbProvider.database.collection('workHourOptions').doc(id).delete();
  }
}
