import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../class/plan.dart';
import 'databasestrategy.dart';

class PlanStrategy implements DatabaseStrategy {
  static Database _database;
  final String tableName = 'todos';

  PlanStrategy();

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDatabase();
    return _database;
  }

  Future<Database> initDatabase() async {
    return openDatabase(join(await getDatabasesPath(), 'planer_database.db'),
        onCreate: (db, version) {
      return db.execute(
          "CREATE TABLE todos(id INTEGER PRIMARY KEY AUTOINCREMENT, "
          "title TEXT, category TEXT, date TEXT, time INTEGER, week INTEGER, weeday INTEGER)");
    }, version: 1);
  }

  Future<List<Plan>> getData(var time) async {
    String date = Plan.makeDate(time.year, time.month, time.day);
    final db = await this.database;
    List<Map<String, dynamic>> maps = await db.rawQuery(
        'select title, date, time,category, id from todos where date=$date');
    List<Map<String, dynamic>> ret = new List();

    for (int i = 0; i < 24; ++i) {
      ret.add({'title': 'μμ', 'date': date, 'time': i, 'category': 'κΈ°ν'});
    }
    for (int i = 0; i < maps.length; ++i) {
      ret[maps[i]['time']] = maps[i];
    }
    return List.generate(ret.length, (i) {
      return Plan(
        title: ret[i]['title'],
        date: ret[i]['date'],
        time: ret[i]['time'],
        category: ret[i]['category'],
        id: ret[i]['id'],
      );
    });
  }

  void deleteData(var plan) async {
    await _database.delete('todos', where: 'id=?', whereArgs: [plan.id]);
  }

  void updateData(List plans, var currentPlan) async {
    if (plans == null) return;
    for (int i = 0; i < plans.length; ++i) {
      if (plans[i].title == null) return;

      await _database.delete('todos',
          where: 'date=? AND time=?',
          whereArgs: [plans[i].date, plans[i].time]);
      await _database.insert('todos', plans[i].toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await _database.delete('todos', where: 'id=?', whereArgs: [currentPlan.id]);
  }

  void updateOneData(var plan) async {}

  void insertData(List plans) async {
    if (plans == null) return;

    for (int i = 0; i < plans.length; ++i) {
      if (plans[i].title == null) return;
      await _database.delete('todos',
          where: 'date=? AND time=?',
          whereArgs: [plans[i].date, plans[i].time]);
      await _database.insert('todos', plans[i].toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }
}
