import 'package:flutter/material.dart';
import '../database/dbHelper.dart';
import '../timeTracker.dart';
import 'package:schedule_app_2021/database/timetrackerStrategy.dart';

class TimeTrackerApp extends StatefulWidget {
  final DateTime _selectedDate;
  TimeTrackerApp(this._selectedDate);
  @override
  _TimeTrackerAppState createState() => _TimeTrackerAppState();
}

class _TimeTrackerAppState extends State<TimeTrackerApp> {
  Future<List<dynamic>> timeTrackerList;
  TimeTracker weeklyFeedback = new TimeTracker();
  DbHelper dbHelper;
  TextEditingController goalContentController;
  TextEditingController resultContentController;
  TextEditingController reasonContentController;
  TextEditingController todoContentController;
  static const List<String> typeToString = [
    '영적',
    '지적',
    '사회적',
    '신체적',
    '잠',
    '기타',
    '버리는 시간'
  ];

  @override
  void initState() {
    super.initState();
    this.dbHelper = new DbHelper();
    dbHelper.setDatabaseStrategy(new TimeTrackerStrategy());
    timeTrackerList = dbHelper.getData(widget._selectedDate);
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
                      TimeTracker plan = snapshot.data[index];
                      return ListTile(
                        title: Container(
                          child: Row(
                            children: <Widget>[
                              SizedBox(
                                width: 18,
                                child: Text(typeToString[plan.type]),
                              ),
                              SizedBox(
                                width: 18,
                                child: Text(plan.goalTime.toString()),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              SizedBox(
                                width: 50,
                                child: Text(plan.spentTime.toString()),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              SizedBox(
                                width: 100,
                                child: Text(plan.improvement),
                              ),
                            ],
                          ),
                        ),
                        onTap: () async {
                          TimeTracker result = await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('수정'),
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
                            dbHelper.deleteData(result);
                          }
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
          future: timeTrackerList,
        ),
      ),
    );
  }
}
