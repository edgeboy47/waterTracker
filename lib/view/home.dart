import 'package:flutter/material.dart';
import 'package:water_tracker/data/database.dart';
import 'dart:async';

class MyScaffold extends StatefulWidget {
  @override
  State<MyScaffold> createState() => _MyScaffoldState();
}

class _MyScaffoldState extends State<MyScaffold> {
  WaterDatabase waterDatabase;
  int _waterToday;
  Future<List<Map<String, dynamic>>> _listForCurrentDay;

  @override
  void initState() {
    super.initState();
    waterDatabase = WaterDatabase();
    _init().then((onValue) {
      _setTotalForDay();
    });
  }

  void _setTotalForDay() {
    waterDatabase.getTotalForCurrentDay().then((val) {
      setState(() {
        _waterToday = val == null ? 0 : val;
      });
    });
    _listForCurrentDay = waterDatabase.getListForCurrentDay();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Appbar')),
        body: Column(
          children: <Widget>[
            Center(
                child: Text(
              '$_waterToday',
              style: TextStyle(fontSize: 24.0),
              textAlign: TextAlign.center,
            )),
            FutureBuilder(future: _listForCurrentDay, builder: _listBuilder)
          ],
        ),
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

  Widget _listBuilder(BuildContext context, AsyncSnapshot snapshot) {
    switch (snapshot.connectionState) {
      case ConnectionState.none:
        print("ConnectionState is none");
        break;

      case ConnectionState.active:
        print("ConnectionState is active");
        break;

      case ConnectionState.waiting:
        print("ConnectionState is waiting");
        return CircularProgressIndicator();
        break;

      case ConnectionState.done:
        print("ConnectionState is done");
        if (snapshot.hasData) {
          final List<Map<String, dynamic>> values = snapshot.data;

          return Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: values.length,
                  itemBuilder: (ctx, index) {
                    return ListTile(title: Text("$index"));
                  }));
        }
        break;
    }
    return Container(
      child: Text("Failed to retrieve list of water"),
    );
  }
}
