import 'package:cloud_firestore/cloud_firestore.dart';

class DbProvider {
  DbProvider._();

  static final DbProvider provider = DbProvider._();
  static FirebaseFirestore _database = FirebaseFirestore.instance;

  FirebaseFirestore get database => _database;
}
