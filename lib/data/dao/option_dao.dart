import 'package:work_hour_tracker/data/database.dart';
import 'package:work_hour_tracker/data/model/option_model.dart';

class OptionDao {
  final dbProvider = DatabaseProvider.dbProvider;

  Future<int> addOption(Option option) async {
    final db = await dbProvider.database;
    var result = await db.insert('options', option.toJson());

    return result;
  }

  Future<List<Option>> getOptions() async {
    final db = await dbProvider.database;
    var result = await db.query('options');

    List<Option> options =
        result.isNotEmpty ? result.map((u) => Option.fromJson(u)).toList() : [];
    return options;
  }

  Future<Option> getOption(int id) async {
    final db = await dbProvider.database;
    var result = await db.query(
      'options',
      where: 'id = ?',
      whereArgs: <dynamic>[id],
    );

    return result.isNotEmpty ? Option.fromJson(result.first) : null;
  }

  Future<int> updateOption(Option option) async {
    final db = await dbProvider.database;
    var result = await db.update(
      'options',
      option.toJson(),
      where: 'id = ?',
      whereArgs: <int>[option.id],
    );

    return result;
  }

  Future<int> deleteOption(int id) async {
    final db = await dbProvider.database;
    var result = await db.delete(
      'options',
      where: 'id = ?',
      whereArgs: <dynamic>[id],
    );

    return result;
  }
}
