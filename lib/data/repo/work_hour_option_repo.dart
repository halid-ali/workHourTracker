import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:work_hour_tracker/data/db_provider.dart';
import 'package:work_hour_tracker/data/model/work_hour_option_model.dart';

class WorkHourOptionRepository {
  static final _dbProvider = DbProvider.provider;

  static Stream<QuerySnapshot> getWorkHourOptions() {
    return _dbProvider.database
        .collection('workHourOptions')
        .snapshots(includeMetadataChanges: true);
  }

  static Future<WorkHourOptionModel> getWorkHourOption(String id) async {
    return _dbProvider.database
        .collection('workHourOptions')
        .doc(id)
        .get()
        .then<WorkHourOptionModel>((value) {
      return WorkHourOptionModel.fromJson(id, value.data());
    });
  }

  static Future<void> addWorkHourOption(
      WorkHourOptionModel workHourOption) async {
    await _dbProvider.database
        .collection('workHourOptions')
        .doc()
        .set(workHourOption.toJson());
  }

  static Future<void> updateWorkHourOption(
      WorkHourOptionModel workHourOption) async {
    await _dbProvider.database
        .collection('workHourOptions')
        .doc(workHourOption.id)
        .update(workHourOption.toJson());
  }

  static Future<void> deleteWorkHourOption(String id) async {
    await _dbProvider.database.collection('workHourOptions').doc(id).delete();
  }
}
