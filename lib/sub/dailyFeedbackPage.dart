import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../dailyFeedback.dart';
import '../database/DailyFeedbackStrategy.dart';
import '../plan.dart';
import '../Goal.dart';
import '../database/dbHelper.dart';
import '../database/databasestrategy.dart';

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
                      title: Container(child: Text(dailyFeedback.diary)),
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
                                    TextField(
                                      controller: reviewContentController,
                                      keyboardType: TextInputType.text,
                                    )
                                  ],
                                ),
                                actions: <Widget>[
                                  FlatButton(
                                    onPressed: () {
                                      dailyFeedback.review =
                                          reviewContentController.value.text;
                                      Navigator.of(context).pop(dailyFeedback);
                                    },
                                    child: Text('예'),
                                  )
                                ],
                              );
                            });
                        if (result != null) {
                          dbHelper.updateOneData(result);
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
