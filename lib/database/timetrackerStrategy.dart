import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../class/timeTracker.dart';
import '../class/weekCalculator.dart';
import 'databasestrategy.dart';

class TimeTrackerStrategy implements DatabaseStrategy {
  static Database _database;
  final String tableName = 'timetracker';

  TimeTrackerStrategy();

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDatabase();
    return _database;
  }

  Future<Database> initDatabase() async {
    return openDatabase(join(await getDatabasesPath(), 'timetracker.db'),
        onCreate: (db, version) {
      return db.execute(
          "CREATE TABLE $tableName(id INTEGER PRIMARY KEY AUTOINCREMENT, "
          "type INTEGER, goalTime INTEGER,  reason TEXT, improvement TEXT, week INNTEGER, year INTEGER)");
    }, version: 1);
  }

  Future<List<TimeTracker>> getData(var time) async {
    int week = WeekCalculator.getweekNumber(time);
    int year = time.year;
    final db = await this.database;
    List<Map<String, dynamic>> maps = await db.rawQuery(
        'select type, goalTime, reason, improvement, week, year, id from $tableName where week=$week and year=$year');
    List<TimeTracker> ret = List.generate(6, (i) {
      return TimeTracker(
        type: i,
        goalTime: 7,
        reason: '없음',
        improvement: '없음',
        week: week,
        year: year,
      );
    });
    for (int i = 0; i < maps.length; ++i) {
      int type = maps[i]['type'];
      ret[type].goalTime = maps[i]['goalTime'];
      ret[type].reason = maps[i]['reason'];
      ret[type].improvement = maps[i]['improvement'];
      ret[type].id = maps[i]['id'];
    }
    return ret;
  }

  void deleteData(var plan) async {
    await _database.delete(tableName, where: 'id=?', whereArgs: [plan.id]);
  }

  void updateData(List plans, var currentPlan) async {
    if (plans == null) return;
    for (int i = 0; i < plans.length; ++i) {
      if (plans[i].type == null ||
          plans[i].goalTime == null ||
          plans[i].spentTime == null) return;

      await _database.update(tableName, plans[i].toMap(),
          where: 'week=? and year=?',
          whereArgs: [plans[i].week, plans[i].year]);
    }
  }

  void updateOneData(var plan) async {
    if (plan == null) return;
    await _database.delete(tableName,
        where: 'week=? AND year=? AND type=?',
        whereArgs: [plan.week, plan.year, plan.type]);
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
