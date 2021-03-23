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
  var category = ['영적', '지적', '사회적', '신체적', '잠'];
  int _year;
  int _month;
  int _day;
  int _selectedIndex = -1;

  @override
  void initState() {
    super.initState();
    _year = DateTime.now().year;
    _month = DateTime.now().month;
    _day = DateTime.now().day;
  }

  Widget _buildChips() {
    List<Widget> chips = new List();
    print(category.length);

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
        padding: EdgeInsets.symmetric(horizontal: 10),
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
            Text(_year.toString()),
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
            )
          ],
        ),
      ),
    );
  }
}
