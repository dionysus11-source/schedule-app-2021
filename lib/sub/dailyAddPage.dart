import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../plan.dart';

class DailyAddApp extends StatefulWidget {
  final Future<Database> db;
  final DateTime _selectedDate;
  DailyAddApp(this.db, this._selectedDate);
  @override
  _DailyAddAppState createState() => _DailyAddAppState();
}

class _DailyAddAppState extends State<DailyAddApp> {
  Future<List<Plan>> planList;
  Map<String, Color> categoryColor;

  @override
  void initState() {
    super.initState();
    planList = getPlans();
    categoryColor = {
      '영적': Colors.purple,
      '지적': Colors.pink,
      '사회적': Colors.brown,
      '신체적': Colors.yellow,
      '잠': Colors.blue,
      '버림': Colors.orange
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: FutureBuilder(
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return CircularProgressIndicator();
              case ConnectionState.waiting:
                return CircularProgressIndicator();
              case ConnectionState.active:
                return CircularProgressIndicator();
              case ConnectionState.done:
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemBuilder: (context, index) {
                      Plan plan = snapshot.data[index];
                      return ListTile(
                        title: Text(
                          plan.time.toString(),
                          style: TextStyle(fontSize: 20),
                        ),
                        subtitle: Container(
                          child: Row(
                            children: <Widget>[
                              Text(plan.category),
                              Text(plan.title),
                            ],
                          ),
                        ),
                        tileColor: categoryColor[plan.category],
                        onLongPress: () async {
                          Plan result = await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('${plan.time} : ${plan.title}'),
                                  content: Text('삭제 하시겠습니까?'),
                                  actions: <Widget>[
                                    FlatButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(plan);
                                      },
                                      child: Text('예'),
                                    ),
                                    FlatButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('아니오'),
                                    )
                                  ],
                                );
                              });
                          if (result != null) {
                            _deletePlan(result);
                          }
                        },
                        onTap: () async {
                          final todo = await Navigator.of(context)
                              .pushNamed('/add', arguments: plan);
                          _updatePlan(todo, plan);
                        },
                      );
                    },
                    itemCount: snapshot.data.length,
                  );
                } else {
                  return Text('No data');
                }
            }
            return CircularProgressIndicator();
          },
          future: planList,
        ),
      ),
    );
  }

  Future<List<Plan>> getPlans() async {
    final Database database = await widget.db;
    final List<Map<String, dynamic>> maps = await database.query('todos');
    return List.generate(maps.length, (i) {
      return Plan(
        title: maps[i]['title'],
        date: maps[i]['date'],
        time: maps[i]['time'],
        category: maps[i]['category'],
        id: maps[i]['id'],
      );
    });
  }

  void _deletePlan(Plan plan) async {
    final Database database = await widget.db;
    await database.delete('todos', where: 'id=?', whereArgs: [plan.id]);
    setState(() {
      planList = getPlans();
    });
  }

  void _updatePlan(List plans, Plan currentPlan) async {
    final Database database = await widget.db;
    if (plans == null) {
      return;
    }
    for (int i = 0; i < plans.length; ++i) {
      if (plans[i].title == null) {
        return;
      }
      final Database database = await widget.db;
      await database.insert('todos', plans[i].toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await database.delete('todos', where: 'id=?', whereArgs: [currentPlan.id]);
    setState(() {
      planList = getPlans();
    });
  }
}
