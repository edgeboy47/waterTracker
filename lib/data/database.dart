import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';

// Singleton class for the database
class WaterDatabase{
  static final WaterDatabase _database = WaterDatabase._internal();
  Database _db;

  factory WaterDatabase() => _database;

  WaterDatabase._internal();

  Future init() async{
    if(_db == null){
      try{
        Directory directory = await getApplicationDocumentsDirectory();
        String path = join(directory.path, "water.db");
        _db = await openDatabase(
          path,
          version: 1,
          onCreate: _onCreate
        );
        print("Database created at $path");
      } catch(e){ print("Error creating database: " + e);}
    }
  }

  Future _onCreate(Database db, int version) async{
    await db.execute(
      '''
      Create TABLE Water (
        DateTime Text Primary Key,
        Amount Integer Not Null
      )
      ''');
  }

  Future insert(DateTime dt, int amount) async{
    try{
      if(_db.isOpen){
        print("DB is open");
        await _db.rawInsert(
          '''
          Insert into Water (DateTime, Amount)
          Values ("${dt.toIso8601String()}", $amount)
          '''
        );
        print("Record inserted");
      }
    } catch(e){print("Failed to insert record");}
  }

  Future dailyTotal() async{
    try{
      var result = await _db.rawQuery(
        '''
        Select * from Water
        '''
      );
      print(result);
    } catch(e){print("Failed to retrieve daily amount");}
  }
}