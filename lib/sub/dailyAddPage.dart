import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class DailyAddApp extends StatefulWidget {
  final Future<Database> db;
  final DateTime _selectedDate;
  DailyAddApp(this.db, this._selectedDate);
  @override
  _DailyAddAppState createState() => _DailyAddAppState();
}

class _DailyAddAppState extends State<DailyAddApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(child: Text(widget._selectedDate.toString())),
      ),
    );
  }
}
