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

  @override
  void initState() {
    super.initState();
    planList = getPlans();
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
                          plan.category,
                          style: TextStyle(fontSize: 20),
                        ),
                        subtitle: Container(
                          child: Row(
                            children: <Widget>[
                              Text(plan.title),
                              Text(plan.time.toString())
                            ],
                          ),
                        ),
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
      );
    });
  }
}
