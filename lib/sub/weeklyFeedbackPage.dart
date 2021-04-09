import 'package:flutter/material.dart';
import 'package:schedule_app_2021/database/weeklyFeedbackStrategy.dart';
import '../database/dbHelper.dart';
import '../weeklyFeedback.dart';

class WeeklyFeedbackApp extends StatefulWidget {
  final DateTime _selectedDate;
  WeeklyFeedbackApp(this._selectedDate);
  @override
  _WeeklyFeedbackAppState createState() => _WeeklyFeedbackAppState();
}

class _WeeklyFeedbackAppState extends State<WeeklyFeedbackApp> {
  Future<List> weeklyfeedbackList;
  DbHelper dbHelper;

  @override
  void initState() {
    super.initState();
    this.dbHelper = new DbHelper();
    dbHelper.setDatabaseStrategy(new WeeklyFeedbackStrategy());
    weeklyfeedbackList = dbHelper.getData(widget._selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(child: Center()),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {},
        child: Icon(Icons.add),
      ),
    );
  }
}
