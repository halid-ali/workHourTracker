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
      onOpen: _onOpen,
    );
  }

  void _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys == ON');
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''CREATE TABLE options (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      UNIQUE(name))''');

    await db.execute('''CREATE TABLE settings (
      locale TEXT NOT NULL)''');

    await db.execute('''CREATE TABLE users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      username TEXT NOT NULL,
      password TEXT NOT NULL,
      UNIQUE(username))''');

    await db.execute('''CREATE TABLE workslots (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      userId INTEGER NOT NULL,
      optionId INTEGER NOT NULL,
      startTime INTEGER NOT NULL,
      stopTime INTEGER NOT NULL,
      breakDuration INTEGER NOT NULL,
      workDuration INTEGER NOT NULL,
      CONSTRAINT fk_user FOREIGN KEY (userId) REFERENCES users(id) ON DELETE CASCADE ON UPDATE NO ACTION,
      CONSTRAINT fk_option FOREIGN KEY (optionId) REFERENCES options(id) ON DELETE CASCADE ON UPDATE NO ACTION)''');
  }

  void _onOpen(Database db) async {}
}
