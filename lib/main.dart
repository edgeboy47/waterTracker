import 'dart:async';

import 'package:flutter/material.dart';
import 'package:water_tracker/data/database.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Water Tracker',
      home: MyScaffold(),
    );
  }
}

class MyScaffold extends StatefulWidget {
  @override
  State<MyScaffold> createState() => _MyScaffoldState();
}

class _MyScaffoldState extends State<MyScaffold> {
  WaterDatabase waterDatabase;
  int _waterToday;

  @override
  void initState() {
    super.initState();
    waterDatabase = WaterDatabase();
    _init().then((onValue) {
      _setTotalForDay();
    });
  }

  void _setTotalForDay() {
    waterDatabase.getTotalForDay().then((val) {
      setState(() {
        _waterToday = val == null ? 0 : val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Appbar')),
        body: Center(
            child: Text(
          '$_waterToday',
          style: TextStyle(fontSize: 24.0),
          textAlign: TextAlign.center,
        )),
        floatingActionButton:
            FloatingActionButton(onPressed: _onPress, child: Icon(Icons.add)));
  }

  Future<void> _init() async {
    await waterDatabase.init();
  }

  void _onPress() {
    waterDatabase.insert(DateTime.now(), 12).then((onValue) {
      _setTotalForDay();
    });
  }
}
