import 'databasestrategy.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  DatabaseStrategy databaseStrategy;

  void setDatabaseStrategy(DatabaseStrategy databaseStrategy) {
    this.databaseStrategy = databaseStrategy;
  }

  Future<Database> initDatabase() async {
    return databaseStrategy.initDatabase();
  }

  Future<List<dynamic>> getData(var time) async {
    return databaseStrategy.getData(time);
  }

  void deleteData(var plan) async {
    databaseStrategy.deleteData(plan);
  }

  void updateData(List plans, var currentPlan) async {
    databaseStrategy.updateData(plans, currentPlan);
  }

  void insertData(List plans) async {
    databaseStrategy.insertData(plans);
  }
}
