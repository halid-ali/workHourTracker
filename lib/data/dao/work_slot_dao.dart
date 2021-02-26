import 'package:work_hour_tracker/data/database.dart';
import 'package:work_hour_tracker/data/model/work_slot_model.dart';

class WorkSlotDao {
  final dbProvider = DatabaseProvider.dbProvider;

  Future<int> addWorkSlot(WorkSlot workSlot) async {
    final db = await dbProvider.database;
    var result = await db.insert('workSlots', workSlot.toJson());

    return result;
  }

  Future<List<WorkSlot>> getWorkSlots() async {
    final db = await dbProvider.database;
    var result = await db.query('workSlots');

    List<WorkSlot> workSlots = result.isNotEmpty
        ? result.map((u) => WorkSlot.fromJson(u)).toList()
        : [];
    return workSlots;
  }

  Future<WorkSlot> getWorkSlot(int id) async {
    final db = await dbProvider.database;
    var result = await db.query(
      'workSlots',
      where: 'id = ?',
      whereArgs: <dynamic>[id],
    );

    return result.isNotEmpty ? WorkSlot.fromJson(result.first) : null;
  }

  Future<int> updateWorkSlot(WorkSlot workSlot) async {
    final db = await dbProvider.database;
    var result = await db.update(
      'workSlots',
      workSlot.toJson(),
      where: 'id = ?',
      whereArgs: <int>[workSlot.id],
    );

    return result;
  }

  Future<int> deleteWorkSlot(int id) async {
    final db = await dbProvider.database;
    var result = await db.delete(
      'workSlots',
      where: 'id = ?',
      whereArgs: <dynamic>[id],
    );

    return result;
  }
}
