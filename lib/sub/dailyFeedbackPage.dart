import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../class/dailyFeedback.dart';
import '../database/DailyFeedbackStrategy.dart';
import '../database/dbHelper.dart';

class DailyFeedbackApp extends StatefulWidget {
  final Future<Database> db;
  final DateTime _selectedDate;
  DailyFeedbackApp(this.db, this._selectedDate);

  @override
  _DailyFeedbackAppState createState() => _DailyFeedbackAppState();
}

class _DailyFeedbackAppState extends State<DailyFeedbackApp> {
  Future<List> feedbackList;
  DbHelper dbHelper;
  TextEditingController reviewContentController;
  TextEditingController todoContentController;
  TextEditingController diaryContentController;
  Map<int, String> weekString = {
    1: 'MON',
    2: 'TUE',
    3: "WED",
    4: 'THU',
    5: 'FRI',
    6: 'SAT',
    7: 'SUN'
  };

  @override
  void initState() {
    super.initState();
    this.dbHelper = new DbHelper();
    dbHelper.setDatabaseStrategy(new DailyFeedbackStrategy());
    feedbackList = dbHelper.getData(widget._selectedDate);
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
                    DailyFeedback dailyFeedback = snapshot.data[index];
                    return ListTile(
                      title: Text(weekString[dailyFeedback.weekday]),
                      subtitle: Container(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '리뷰',
                            style: TextStyle(color: Colors.blue),
                          ),
                          SizedBox(
                            // height: 50,
                            child: Text(
                              dailyFeedback.review,
                            ),
                          ),
                          Divider(
                            color: Colors.black,
                            thickness: 0.2,
                          ),
                          Text(
                            '앞으로 할 일',
                            style: TextStyle(color: Colors.blue),
                          ),
                          SizedBox(
                            child: Text(
                              dailyFeedback.todo,
                            ),
                          ),
                          Divider(
                            color: Colors.black,
                            thickness: 0.2,
                          ),
                          Text(
                            '일기',
                            style: TextStyle(color: Colors.blue),
                          ),
                          SizedBox(
                            child: Text(
                              dailyFeedback.diary,
                            ),
                          ),
                          Divider(
                            color: Colors.black,
                            thickness: 1.2,
                          ),
                        ],
                      )),
                      trailing: Text(dailyFeedback.date),
                      onTap: () async {
                        reviewContentController = new TextEditingController();
                        todoContentController = new TextEditingController();
                        diaryContentController = new TextEditingController();
                        DailyFeedback result = await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('수정하기'),
                                content: Column(
                                  children: <Widget>[
                                    Text(
                                      '리뷰',
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                    SizedBox(
                                      child: Text(dailyFeedback.review),
                                    ),
                                    TextField(
                                      controller: reviewContentController,
                                      keyboardType: TextInputType.text,
                                    ),
                                    Text(
                                      '앞으로 할 일',
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                    SizedBox(
                                      child: Text(dailyFeedback.todo),
                                    ),
                                    TextField(
                                      controller: todoContentController,
                                      keyboardType: TextInputType.text,
                                    ),
                                    Text(
                                      '일기',
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                    SizedBox(
                                      child: Text(dailyFeedback.diary),
                                    ),
                                    TextField(
                                      controller: diaryContentController,
                                      keyboardType: TextInputType.text,
                                    ),
                                  ],
                                ),
                                actions: <Widget>[
                                  FlatButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Cancle'),
                                  ),
                                  FlatButton(
                                    onPressed: () {
                                      if (reviewContentController.value.text !=
                                          '') {
                                        dailyFeedback.review =
                                            reviewContentController.value.text;
                                      }
                                      if (todoContentController.value.text !=
                                          '') {
                                        dailyFeedback.todo =
                                            todoContentController.value.text;
                                      }
                                      if (diaryContentController.value.text !=
                                          '') {
                                        dailyFeedback.diary =
                                            diaryContentController.value.text;
                                      }
                                      Navigator.of(context).pop(dailyFeedback);
                                    },
                                    child: Text('Save'),
                                  ),
                                ],
                              );
                            });
                        if (result != null) {
                          dbHelper.updateOneData(result);
                          await Future.delayed(const Duration(seconds: 1));
                          setState(() {
                            feedbackList =
                                dbHelper.getData(widget._selectedDate);
                          });
                        }
                      },
                    );
                  },
                  itemCount: snapshot.data.length,
                );
              } else
                return Text('No data');
          }
          return CircularProgressIndicator();
        },
        future: feedbackList,
      ),
    ));
  }
}
