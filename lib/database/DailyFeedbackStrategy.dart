import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../dailyFeedback.dart';
import '../plan.dart';
import '../Goal.dart';
import 'databasestrategy.dart';

class DailyFeedbackStrategy implements DatabaseStrategy {
  static Database _database;
  final String tableName = 'daily';

  DailyFeedbackStrategy();

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDatabase();
    return _database;
  }

  Future<Database> initDatabase() async {
    return openDatabase(join(await getDatabasesPath(), 'planer_database.db'),
        onCreate: (db, version) {
      return db.execute(
          "CREATE TABLE $tableName(id INTEGER PRIMARY KEY AUTOINCREMENT, "
          "review TEXT, todo TEXT, date TEXT, diary TEXT, week INTEGER, weekday INTEGER)");
    }, version: 1);
  }

  Future<List<DailyFeedback>> getData(var time) async {
    int weekday = Goal.getweekNumber(time);
    int selectedYear = time.year;
    List<Map<String, dynamic>> maps = await _database.rawQuery(
        'select review, date, todo, diary, week, weekday, id from $tableName where weekday=${weekday}');
    maps.removeWhere((element) {
      int year = int.parse(element['date'].substring(0, 4));
      return selectedYear != year;
    });

    return List.generate(maps.length, (i) {
      return DailyFeedback(
          id: maps[i]['id'],
          review: maps[i]['review'],
          date: maps[i]['date'],
          todo: maps[i]['todo'],
          diary: maps[i]['diary'],
          week: maps[i]['week'],
          weekday: maps[i]['weekday']);
    });
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

  void insertData(List plans) async {
    if (plans == null) return;

    for (int i = 0; i < plans.length; ++i) {
      if (plans[i].title == null) return;
      await _database
          .delete(tableName, where: 'date=?', whereArgs: [plans[i].date]);
      await _database.insert(tableName, plans[i].toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }
}
