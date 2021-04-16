import 'package:sqflite/sqflite.dart';

abstract class DatabaseStrategy {
  static Database _database;
  final String tableName = 'todos';

  DatabaseStrategy();

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDatabase();
    return _database;
  }

  Future<Database> initDatabase() async {
    return null;
  }

  Future<List<dynamic>> getData(var time) async {
    return null;
  }

  void deleteData(var plan) async {}

  void updateData(List plans, var currentPlan) async {}
  void updateOneData(var currentPlan) async {}

  void insertData(List plans) async {}
}
