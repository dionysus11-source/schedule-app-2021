import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../class/dailyFeedback.dart';
import '../class/plan.dart';
import '../class/Goal.dart';
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
    return openDatabase(join(await getDatabasesPath(), 'dailyFeedback.db'),
        onCreate: (db, version) {
      return db.execute(
          "CREATE TABLE $tableName(id INTEGER PRIMARY KEY AUTOINCREMENT, "
          "review TEXT, todo TEXT, date TEXT, diary TEXT, week INTEGER, weekday INTEGER)");
    }, version: 1);
  }

  Future<List<DailyFeedback>> getData(var time) async {
    int weekday = time.weekday - 1;
    DateTime mondayDate = time.subtract(Duration(days: weekday));
    int week = Goal.getweekNumber(time);
    int selectedYear = time.year;
    final db = await this.database;
    List<Map<String, dynamic>> maps = await db.rawQuery(
        'select review, date, todo, diary, week, weekday, id from $tableName where week=$week');
    maps.removeWhere((element) {
      int year = int.parse(element['date'].substring(0, 4));
      return selectedYear != year;
    });
    List<Map<String, dynamic>> ret = new List();
    for (int i = 0; i < 7; ++i) {
      DateTime today = mondayDate.add(Duration(days: i));
      ret.add({
        'review': '없음',
        'date': Plan.makeDate(today.year, today.month, today.day),
        'todo': '없음',
        'diary': '없음',
        'week': week,
        'weekday': i + 1,
      });
    }
    for (int i = 0; i < maps.length; ++i) {
      ret[maps[i]['weekday'] - 1]['review'] = maps[i]['review'];
      ret[maps[i]['weekday'] - 1]['todo'] = maps[i]['todo'];
      ret[maps[i]['weekday'] - 1]['diary'] = maps[i]['diary'];
    }
    return List.generate(ret.length, (i) {
      return DailyFeedback(
        review: ret[i]['review'],
        date: ret[i]['date'],
        todo: ret[i]['todo'],
        diary: ret[i]['diary'],
        week: ret[i]['week'],
        weekday: ret[i]['weekday'],
        id: ret[i]['id'],
      );
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

  void updateOneData(var input) async {
    if (input == null) return;
    await _database.delete(tableName, where: 'date=?', whereArgs: [input.date]);
    await _database.insert(tableName, input.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
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
