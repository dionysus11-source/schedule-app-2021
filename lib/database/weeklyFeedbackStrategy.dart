import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../class/Goal.dart';
import '../class/weeklyFeedback.dart';
import 'databasestrategy.dart';

class WeeklyFeedbackStrategy implements DatabaseStrategy {
  static Database _database;
  final String tableName = 'weekly';

  WeeklyFeedbackStrategy();

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDatabase();
    return _database;
  }

  Future<Database> initDatabase() async {
    return openDatabase(join(await getDatabasesPath(), 'weeklyFeedback.db'),
        onCreate: (db, version) {
      return db.execute(
          "CREATE TABLE $tableName(id INTEGER PRIMARY KEY AUTOINCREMENT, "
          "goal TEXT, result TEXT, reason TEXT, todo TEXT, week INTEGER, year INTEGER)");
    }, version: 1);
  }

  Future<List<WeeklyFeedback>> getData(var time) async {
    int week = Goal.getweekNumber(time);
    int year = time.year;
    final db = await this.database;
    List<Map<String, dynamic>> maps = await db.rawQuery(
        'select goal , result , reason, todo , week, year, id from $tableName where week=$week and year=$year');
    if (maps.length > 0) {
      return List.generate(maps.length, (i) {
        return WeeklyFeedback(
          goal: maps[i]['goal'],
          result: maps[i]['result'],
          reason: maps[i]['reason'],
          todo: maps[i]['todo'],
          week: maps[i]['week'],
          year: maps[i]['year'],
          id: maps[i]['id'],
        );
      });
    } else
      return null;
  }

  void deleteData(var plan) async {
    await _database.delete(tableName, where: 'id=?', whereArgs: [plan.id]);
  }

  void updateData(List plans, var currentPlan) async {
    if (plans == null) return;
    for (int i = 0; i < plans.length; ++i) {
      if (plans[i].review == null ||
          plans[i].todo == null ||
          plans[i].diary == null) return;

      await _database.update(tableName, plans[i].toMap(),
          where: 'date=?', whereArgs: [plans[i].date]);
    }
  }

  void updateOneData(var plan) async {
    if (plan == null) return;
    await _database.delete(tableName,
        where: 'week=? AND year=?', whereArgs: [plan.week, plan.year]);
    await _database.insert(tableName, plan.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  void insertData(List plans) async {
    if (plans == null) return;

    for (int i = 0; i < plans.length; ++i) {
      await _database.delete(tableName,
          where: 'week=? AND year=?',
          whereArgs: [plans[i].week, plans[i].year]);
      await _database.insert(tableName, plans[i].toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }
}
