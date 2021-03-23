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
  int _selectedIndex = -1;

  @override
  void initState() {
    super.initState();
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
      print(choiceChip);
      chips.add(Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: choiceChip,
      ));
    }
    print(chips[0]);
    var test = ListView(
      scrollDirection: Axis.horizontal,
      children: chips,
      shrinkWrap: true,
    );
    return test;
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
            Container(
              height: 30,
              child: _buildChips(),
            )
          ],
        ),
      ),
    );
  }
}
