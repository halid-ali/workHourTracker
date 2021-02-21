import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider {
  Database _database;

  DatabaseProvider._();

  static final DatabaseProvider dbProvider = DatabaseProvider._();

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String dbPath = join(directory.path, 'app.db');

    return await openDatabase(
      dbPath,
      version: 1,
      onConfigure: _onConfigure,
      onCreate: _onCreate,
      onOpen: (db) async {},
    );
  }

  void _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys == ON');
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''CREATE TABLE options (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT)''');

    await db.execute('''CREATE TABLE settings (
      locale TEXT)''');

    await db.execute('''CREATE TABLE workslots (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      optionId INTEGER,
      startTime INTEGER,
      stopTime INTEGER,
      breakDuration INTEGER,
      workDuration INTEGER)''');
  }
}
