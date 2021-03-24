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
  TextEditingController contentController;
  var category = ['영적', '지적', '사회적', '신체적', '잠', '버림'];
  int _year;
  int _month;
  int _day;
  int _startTime;
  int _endTime;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    contentController = new TextEditingController();
    _year = DateTime.now().year;
    _month = DateTime.now().month;
    _day = DateTime.now().day;
    _startTime = DateTime.now().hour;
    _endTime = DateTime.now().hour + 1;
  }

  Widget _buildChips() {
    List<Widget> chips = new List();
    for (int i = 0; i < category.length; ++i) {
      ChoiceChip choiceChip = ChoiceChip(
        selected: _selectedIndex == i,
        label: Text(
          category[i],
          style: TextStyle(color: Colors.white),
        ),
        //avatar: FlutterLogo(),
        //elevation: 10,
        //pressElevation: 5,
        //shadowColor: Colors.teal,
        //backgroundColor: Colors.black54,
        //selectedColor: Colors.blue,
        onSelected: (bool selected) {
          setState(() {
            if (selected) {
              _selectedIndex = i;
            }
          });
        },
      );
      chips.add(Padding(
        padding: EdgeInsets.symmetric(horizontal: 3),
        child: choiceChip,
      ));
    }
    return ListView(
      scrollDirection: Axis.horizontal,
      children: chips,
      shrinkWrap: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Plan 추가'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: <Widget>[
            Text('카테고리 설정'),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 30,
              child: _buildChips(),
            ),
            SizedBox(
              height: 20,
            ),
            Text(_year.toString() + '년'),
            Slider(
              value: _year.toDouble(),
              min: 2021,
              max: 2025,
              divisions: 5,
              label: _year.toString(),
              onChanged: (value) {
                setState(() {
                  _year = value.toInt();
                });
              },
            ),
            Text(_month.toString() + '월'),
            Slider(
              value: _month.toDouble(),
              min: 1,
              max: 12,
              divisions: 12,
              label: _month.toString(),
              onChanged: (value) {
                setState(() {
                  _month = value.toInt();
                });
              },
            ),
            Text(_day.toString() + '일'),
            Slider(
              value: _day.toDouble(),
              min: 1,
              max: 31,
              divisions: 31,
              label: _day.toString(),
              onChanged: (value) {
                setState(() {
                  _day = value.toInt();
                });
              },
            ),
            Text('시작 시간 ' + _startTime.toString() + '시'),
            Slider(
              value: _startTime.toDouble(),
              min: 0,
              max: 23,
              divisions: 24,
              label: _startTime.toString(),
              onChanged: (value) {
                setState(() {
                  _startTime = value.toInt();
                });
              },
            ),
            Text('끝나는 시간 ' + _endTime.toString() + '시'),
            Slider(
              value: _endTime.toDouble(),
              min: 0,
              max: 23,
              divisions: 24,
              label: _endTime.toString(),
              onChanged: (value) {
                setState(() {
                  _endTime = value.toInt();
                });
              },
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: contentController,
                decoration: InputDecoration(labelText: '내용'),
              ),
            ),
            RaisedButton(
              onPressed: () {
                List<Plan> ret = List();
                for (int i = _startTime; i < _endTime; ++i) {
                  Plan plan = Plan(
                    category: category[_selectedIndex],
                    title: contentController.value.text,
                    date:
                        _year.toString() + _month.toString() + _day.toString(),
                    time: i,
                  );
                  ret.add(plan);
                }
                Navigator.of(context).pop(ret);
              },
              child: Text('저장하기'),
            )
          ],
        ),
      ),
    );
  }
}
