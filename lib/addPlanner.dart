import 'package:flutter/material.dart';
import 'package:sqflite/sqlite_api.dart';
import 'plan.dart';

class AddPlanner extends StatefulWidget {
  final Future<Database> db;
  AddPlanner(this.db);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AddPlanner();
  }
}

class _AddPlanner extends State<AddPlanner> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Plan 추가'),
      ),
      body: Container(
        child: Center(
          child: Column(
            children: <Widget>[],
          ),
        ),
      ),
    );
  }
}
