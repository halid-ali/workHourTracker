import 'package:work_hour_tracker/data/dao/work_slot_dao.dart';
import 'package:work_hour_tracker/data/model/work_slot_model.dart';

class WorkSlotRepository {
  final workSlotDao = WorkSlotDao();

  Future<List<WorkSlot>> getWorkSlots() => workSlotDao.getWorkSlots();

  Future<WorkSlot> getWorkSlot(int id) => workSlotDao.getWorkSlot(id);

  Future addWorkSlot(WorkSlot workSlot) => workSlotDao.addWorkSlot(workSlot);

  Future updateWorkSlot(WorkSlot workSlot) =>
      workSlotDao.updateWorkSlot(workSlot);

  Future deleteWorkSlot(int id) => workSlotDao.deleteWorkSlot(id);
}
