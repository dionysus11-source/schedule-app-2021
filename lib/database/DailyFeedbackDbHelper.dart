import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../dailyFeedback.dart';
import '../plan.dart';
import 'databasestrategy.dart';

class DailyFeedbackDbHelper implements DatabaseStrategy {
  static Database _database;
  final String tableName = 'daily';

  DailyFeedbackDbHelper();

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
          "review TEXT, todo TEXT, date TEXT, diary TEXT)");
    }, version: 1);
  }

  Future<List<DailyFeedback>> getData(var time) async {
    String date = Plan.makeDate(time.year, time.month, time.day);
    List<Map<String, dynamic>> maps = await _database.rawQuery(
        'select review, date, todo, diary, id from $tableName where date=${date}');

    return List.generate(maps.length, (i) {
      return DailyFeedback(
        id: maps[i]['id'],
        review: maps[i]['review'],
        date: maps[i]['date'],
        todo: maps[i]['todo'],
        diary: maps[i]['diary'],
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
