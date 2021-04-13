import 'package:flutter/material.dart';
import 'package:schedule_app_2021/database/weeklyFeedbackStrategy.dart';
import '../database/dbHelper.dart';
import '../weeklyFeedback.dart';
import '../Goal.dart';

class WeeklyFeedbackApp extends StatefulWidget {
  final DateTime _selectedDate;
  WeeklyFeedbackApp(this._selectedDate);
  @override
  _WeeklyFeedbackAppState createState() => _WeeklyFeedbackAppState();
}

class _WeeklyFeedbackAppState extends State<WeeklyFeedbackApp> {
  Future<List<dynamic>> weeklyfeedbackList;
  WeeklyFeedback weeklyFeedback = new WeeklyFeedback();
  DbHelper dbHelper;
  TextEditingController goalContentController;
  TextEditingController resultContentController;
  TextEditingController reasonContentController;
  TextEditingController todoContentController;

  @override
  void initState() {
    super.initState();
    this.dbHelper = new DbHelper();
    dbHelper.setDatabaseStrategy(new WeeklyFeedbackStrategy());
    weeklyfeedbackList = dbHelper.getData(widget._selectedDate);
    weeklyFeedback.goal = '없음';
    weeklyFeedback.result = '없음';
    weeklyFeedback.reason = '없음';
    weeklyFeedback.todo = '없음';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: Center(
        child: FutureBuilder(
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              weeklyFeedback = snapshot.data[0];
              return Column(
                children: <Widget>[
                  Card(
                    child: Text(weeklyFeedback.goal),
                  ),
                  Card(
                    child: Text(weeklyFeedback.result),
                  ),
                  Card(
                    child: Text(weeklyFeedback.reason),
                  ),
                  Card(
                    child: Text(weeklyFeedback.todo),
                  ),
                ],
              );
            }
            return Text('No data');
          },
          future: weeklyfeedbackList,
        ),
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          goalContentController = new TextEditingController();
          resultContentController = new TextEditingController();
          reasonContentController = new TextEditingController();
          todoContentController = new TextEditingController();
          WeeklyFeedback result = await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('수정하기'),
                  content: Column(
                    children: <Widget>[
                      Text(
                        '목표',
                        style: TextStyle(color: Colors.blue),
                      ),
                      SizedBox(
                        child: Text(weeklyFeedback.goal),
                      ),
                      TextField(
                        controller: goalContentController,
                        keyboardType: TextInputType.text,
                      ),
                      Text(
                        '결과',
                        style: TextStyle(color: Colors.blue),
                      ),
                      SizedBox(
                        child: Text(weeklyFeedback.result),
                      ),
                      TextField(
                        controller: resultContentController,
                        keyboardType: TextInputType.text,
                      ),
                      Text(
                        '원인 분석',
                        style: TextStyle(color: Colors.blue),
                      ),
                      SizedBox(
                        child: Text(weeklyFeedback.reason),
                      ),
                      TextField(
                        controller: reasonContentController,
                        keyboardType: TextInputType.text,
                      ),
                      Text(
                        '계속 해야할 것 버려야할 것',
                        style: TextStyle(color: Colors.blue),
                      ),
                      SizedBox(
                        child: Text(weeklyFeedback.todo),
                      ),
                      TextField(
                        controller: todoContentController,
                        keyboardType: TextInputType.text,
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('취소'),
                    ),
                    FlatButton(
                      onPressed: () {
                        if (goalContentController.value.text != '') {
                          weeklyFeedback.goal =
                              goalContentController.value.text;
                        }
                        if (resultContentController.value.text != '') {
                          weeklyFeedback.result =
                              resultContentController.value.text;
                        }
                        if (reasonContentController.value.text != '') {
                          weeklyFeedback.reason =
                              reasonContentController.value.text;
                        }
                        if (todoContentController.value.text != '') {
                          weeklyFeedback.todo =
                              todoContentController.value.text;
                        }
                        Navigator.of(context).pop(weeklyFeedback);
                      },
                      child: Text('저장'),
                    ),
                  ],
                );
              });
          if (result != null) {
            if (result.week == null || result.year == null) {
              result.week = Goal.getweekNumber(widget._selectedDate);
              result.year = widget._selectedDate.year;
            }
            dbHelper.updateOneData(result);
            setState(() {
              weeklyfeedbackList = dbHelper.getData(widget._selectedDate);
            });
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
