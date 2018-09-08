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

  @override
    void initState() {
      waterDatabase = WaterDatabase();
      _init();
      super.initState();
    }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Appbar')),
        body: Center(
            child: Text(
          'Test',
          style: TextStyle(fontSize: 24.0),
          textAlign: TextAlign.center,
        )));
  }

  void _init() async{
    await waterDatabase.init();
    await waterDatabase.dailyTotal();
  }
}
