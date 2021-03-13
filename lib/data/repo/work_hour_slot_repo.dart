import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:work_hour_tracker/data/db_provider.dart';
import 'package:work_hour_tracker/data/model/work_hour_slot_model.dart';

class WorkHourSlotRepository {
  static final _dbProvider = DbProvider.provider;

  static Stream<QuerySnapshot> getWorkHourSlotsByUser(String userId) {
    return _dbProvider.database
        .collection('workHourSlots')
        .where('userId', isEqualTo: userId)
        .snapshots(includeMetadataChanges: true);
  }

  static Stream<QuerySnapshot> getWorkHourSlotsByDate(
      DateTime startDate, DateTime endDate) {
    return _dbProvider.database
        .collection('workHourSlots')
        .where('startDate', isGreaterThanOrEqualTo: startDate)
        .where('endDate', isLessThanOrEqualTo: endDate)
        .snapshots(includeMetadataChanges: true);
  }

  static Future<WorkHourSlotModel> getWorkHourSlot(String id) async {
    return _dbProvider.database
        .collection('workHourSlots')
        .doc(id)
        .get()
        .then<WorkHourSlotModel>((value) {
      return WorkHourSlotModel.fromJson(id, value.data());
    });
  }

  static Future<void> addWorkHourSlot(WorkHourSlotModel workHourSlot) async {
    await _dbProvider.database
        .collection('workHourSlots')
        .doc()
        .set(workHourSlot.toJson());
  }

  static Future<void> updateWorkHourSlot(WorkHourSlotModel workHourSlot) async {
    await _dbProvider.database
        .collection('workHourSlots')
        .doc(workHourSlot.id)
        .update(workHourSlot.toJson());
  }

  static Future<void> deleteWorkHourSlot(String id) async {
    await _dbProvider.database.collection('workHourSlots').doc(id).delete();
  }
}
