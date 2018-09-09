import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';

// Singleton wrapper class for the database
class WaterDatabase{
  static final WaterDatabase _database = WaterDatabase._internal();
  Database _db;

  factory WaterDatabase() => _database;

  WaterDatabase._internal();

  Future<void> init() async{
    if(_db == null){
      try{
        Directory directory = await getApplicationDocumentsDirectory();
        String path = join(directory.path, "water.db");
        _db = await openDatabase(
          path,
          version: 1,
          onCreate: _onCreate
        );
        print("Database opened at $path");
      } catch(e){ print("Error creating database: $e");}
    }
  }

  Future<void> _onCreate(Database db, int version) async{
    try{
      await db.execute(
        '''
        Create TABLE Water (
          DateTime Text Primary Key,
          Amount Integer Not Null
        )
        ''');
        print("Database created");
    } catch(e){ print("Failed to create database: $e");}

  }

  Future<void> insert(DateTime dt, int amount) async{
    try{
      _open();
      await _db.rawInsert(
        '''
        Insert into Water (DateTime, Amount)
        Values ("${dt.toIso8601String()}", $amount)
        '''
      );
      print("Record inserted");
    
    } catch(e){print("Failed to insert record: $e");}
  }

  Future<int> dailyTotal() async{
    try{
      _open();
      final datePattern = DateTime.now().toIso8601String().substring(0, 10) + '%';
      var result = await _db.rawQuery(
        '''
        Select SUM(Amount)
        From Water
        Where DateTime Like "$datePattern"
        '''
      );
      return result[0]["SUM(Amount)"];
    } catch(e){ 
      print("Failed to retrieve daily amount");
      return null;
    }
  }

  Future<void> remove(DateTime dt) async{
    try{
      _open();
      final dateTime = dt.toIso8601String();
      await _db.rawDelete(
        '''
        Delete from Water
        Where DateTime = "$dateTime"
        '''
      );
      print("Deleted record");
    } catch(e){
      print("Failed to delete record: $e");
    }
  }

  Future<List<Map<String, int>>> select(DateTime dateTime) async{
    try{
      _open();
      final result = await _db.rawQuery(
        '''
        Select *
        From Water
        Where DateTime = "$dateTime"
        '''
      );
      return result;
    } catch(e){
      print("Query Failed: $e");
      return null;
    }
  }

  Future<void> _open() async{
    if(!_db.isOpen){ await this.init();}
  }
}