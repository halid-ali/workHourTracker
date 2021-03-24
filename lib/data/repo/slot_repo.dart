import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:work_hour_tracker/data/db_provider.dart';
import 'package:work_hour_tracker/data/model/slot_model.dart';

class SlotRepository {
  static final _dbProvider = DbProvider.provider;

  static Stream<QuerySnapshot> getWorkHourSlotsByUser(String userId) {
    return _dbProvider.database
        .collection('workHourSlots')
        .where('userId', isEqualTo: userId)
        .snapshots(includeMetadataChanges: true);
  }

  static Stream<QuerySnapshot> getWorkHourSlotsByDate(Timestamp startTime) {
    return _dbProvider.database
        .collection('workHourSlots')
        .where('startTime', isGreaterThanOrEqualTo: startTime)
        .snapshots(includeMetadataChanges: true);
  }

  static Future<void> addWorkHourSlot(SlotModel workHourSlot) async {
    await _dbProvider.database
        .collection('workHourSlots')
        .doc()
        .set(workHourSlot.toJson());
  }

  static Future<void> updateWorkHourSlot(SlotModel workHourSlot) async {
    await _dbProvider.database
        .collection('workHourSlots')
        .doc(workHourSlot.id)
        .update(workHourSlot.toJson());
  }

  static Future<void> deleteWorkHourSlot(String id) async {
    await _dbProvider.database.collection('workHourSlots').doc(id).delete();
  }
}
