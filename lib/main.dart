import 'package:flutter/material.dart';
import 'sub/dailyAddPage.dart';
import 'sub/dailyFeedbackPage.dart';
import 'sub/monthlyFeedbackPage.dart';
import 'sub/weeklyFeedbackPage.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'addPlanner.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Future<Database> database = initDatabase();
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => MainPage(database),
        '/add': (context) => AddPlanner(database)
      },
    );
  }

  Future<Database> initDatabase() async {
    return openDatabase(join(await getDatabasesPath(), 'planer_database.db'),
        onCreate: (db, version) {
      return db
          .execute("CREATE TABLE todos(id INTEGER PRIMARY KEY AUTOINCREMENT, "
              "title TEXT, category TEXT, date TEXT, time INTEGER)");
    }, version: 1);
  }
}

class MainPage extends StatefulWidget {
  final Future<Database> db;
  MainPage(this.db);
  @override
  State<StatefulWidget> createState() => _MainPage();
}

class _MainPage extends State<MainPage> with SingleTickerProviderStateMixin {
  TabController controller;
  DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 4, vsync: this);
    _selectedDate = DateTime.now();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Time Planner'),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Future<DateTime> selected = showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime(2015),
                  lastDate: DateTime(2025),
                  builder: (BuildContext context, Widget child) {
                    return Theme(
                      data: ThemeData.light(),
                      child: child,
                    );
                  });
              selected.then((dateTime) {
                setState(() {
                  _selectedDate = dateTime;
                });
              });
            },
            child: Text('날짜바꾸기'),
          )
        ],
      ),
      body: TabBarView(
        children: <Widget>[
          DailyAddApp(widget.db, _selectedDate),
          DailyFeedbackApp(),
          WeeklyFeedbackApp(),
          MonthlyFeedbackApp()
        ],
        controller: controller,
      ),
      bottomNavigationBar: TabBar(
        tabs: <Tab>[
          Tab(
            icon: Icon(Icons.calendar_today_outlined, color: Colors.black),
          ),
          Tab(
              icon: Image.asset(
            'repo/images/feedback.png',
            width: 24,
            height: 24,
          )),
          Tab(
              icon: Image.asset(
            'repo/images/week.png',
            width: 24,
            height: 24,
          )),
          Tab(
              icon: Image.asset(
            'repo/images/calendar.png',
            width: 24,
            height: 24,
          )),
        ],
        controller: controller,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final todo = await Navigator.of(context).pushNamed('/add');
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
