import 'package:flutter/material.dart';
import '../database/dbHelper.dart';
import '../timeTracker.dart';
import 'package:schedule_app_2021/database/timetrackerStrategy.dart';
import '../database/PlanStrategy.dart';

class TimeTrackerApp extends StatefulWidget {
  final DateTime _selectedDate;
  TimeTrackerApp(this._selectedDate);
  @override
  _TimeTrackerAppState createState() => _TimeTrackerAppState();
}

class _TimeTrackerAppState extends State<TimeTrackerApp> {
  Future<List<dynamic>> timeTrackerList;
  Future<List> spentTime;
  TimeTracker weeklyFeedback = new TimeTracker();
  DbHelper dbHelper;
  List sTime;
  TextEditingController goaltimeEditingController;
  TextEditingController reasonEditingController;
  TextEditingController improvementEditingController;
  static const List<String> typeToString = [
    '영적',
    '지적',
    '사회적',
    '신체적',
    '잠',
    '기타',
    '버림'
  ];
  static const Map<String, int> stringtoType = {
    '영적': 0,
    '지적': 1,
    '사회적': 2,
    '신체적': 3,
    '잠': 4,
    '기타': 5,
    '버림': 6
  };

  Future<List> getTime(var time) async {
    List ret = List.filled(stringtoType.length, 0);
    DbHelper dbHelper = new DbHelper();
    dbHelper.setDatabaseStrategy(new PlanStrategy());
    DateTime mondayDate = time.subtract(Duration(days: time.weekday - 1));
    for (int i = 0; i < 7; ++i) {
      DateTime today = mondayDate.add(Duration(days: i));
      List<dynamic> planList = await dbHelper.getData(today);
      for (int j = 0; j < planList.length; ++j) {
        int type = stringtoType[planList[j].category];
        ++ret[type];
      }
    }
    return ret;
  }

  @override
  void initState() {
    super.initState();
    this.dbHelper = new DbHelper();
    dbHelper.setDatabaseStrategy(new TimeTrackerStrategy());
    sTime = List.filled(stringtoType.length, 0);
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
                      return Card(
                          elevation: 5,
                          margin: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          child: ListTile(
                            leading: CircleAvatar(
                                radius: 25,
                                child: FittedBox(
                                    child: Text(typeToString[plan.type]))),
                            title: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(
                                    child: Text(
                                      '목표 : ' + plan.goalTime.toString(),
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                  ),
                                  SizedBox(
                                    child: Text(
                                      '사용시간 : ' + sTime[index].toString(),
                                      //plan.spentTime.toString(),
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                  ),
                                  SizedBox(
                                    child: Text(
                                      '달성율 : ' +
                                          (((sTime[index] / plan.goalTime) *
                                                  100))
                                              .toStringAsFixed(0) +
                                          '%',
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                  ),
                                  Divider(
                                    color: Colors.black,
                                    thickness: 0.2,
                                  ),
                                  SizedBox(
                                    child: Text(
                                      '원인 분석',
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                  ),
                                  SizedBox(
                                    child: Text(plan.reason),
                                  ),
                                  Divider(
                                    color: Colors.black,
                                    thickness: 0.2,
                                  ),
                                  SizedBox(
                                    child: Text(
                                      '다음주 할 일',
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                  ),
                                  SizedBox(
                                    child: Text(plan.improvement),
                                  ),
                                  Divider(
                                    color: Colors.black,
                                    thickness: 0.2,
                                  ),
                                ],
                              ),
                            ),
                            onTap: () async {
                              goaltimeEditingController =
                                  TextEditingController();
                              reasonEditingController = TextEditingController();
                              improvementEditingController =
                                  TextEditingController();
                              TimeTracker result = await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('수정'),
                                      content: Column(
                                        children: [
                                          Text('목표시간 :' +
                                              plan.goalTime.toString()),
                                          TextField(
                                            controller:
                                                goaltimeEditingController,
                                            keyboardType: TextInputType.number,
                                          ),
                                          Text('원인 분석:' + plan.reason),
                                          TextField(
                                            controller: reasonEditingController,
                                            keyboardType: TextInputType.text,
                                          ),
                                          Text(
                                              '다음주에 적용할 것:' + plan.improvement),
                                          TextField(
                                            controller:
                                                improvementEditingController,
                                            keyboardType: TextInputType.text,
                                          ),
                                        ],
                                      ),
                                      actions: <Widget>[
                                        FlatButton(
                                          onPressed: () {
                                            if (goaltimeEditingController
                                                    .value.text !=
                                                '') {
                                              plan.goalTime = int.parse(
                                                  goaltimeEditingController
                                                      .value.text);
                                            }
                                            if (reasonEditingController
                                                    .value.text !=
                                                '') {
                                              plan.reason =
                                                  reasonEditingController
                                                      .value.text;
                                            }
                                            if (improvementEditingController
                                                    .value.text !=
                                                '') {
                                              plan.improvement =
                                                  improvementEditingController
                                                      .value.text;
                                            }
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
                                dbHelper.updateOneData(result);
                                await Future.delayed(
                                    const Duration(seconds: 1));
                                setState(() {
                                  timeTrackerList =
                                      dbHelper.getData(widget._selectedDate);
                                });
                              }
                            },
                          ));
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          spentTime = getTime(widget._selectedDate);
          spentTime.then((value) {
            setState(() {
              sTime = value;
            });
          });
        },
        child: Icon(Icons.refresh),
      ),
    );
  }
}
