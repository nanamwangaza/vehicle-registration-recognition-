import 'dart:convert';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _database;
  static final DBHelper instance = DBHelper._privateConstructor();

  DBHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final String path = join(await getDatabasesPath(), 'your_database_name.db');
    return await openDatabase(path, version: 1, onCreate: _createTable);
  }

  Future<void> _createTable(Database db, int version) async {
    // Create your database table(s) here
    await db.execute('''
      CREATE TABLE responses(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        responseData TEXT
      )
    ''');
  }

  Future<void> insertResponse(String responseData) async {
    final Database db = await instance.database;
    await db.insert('responses', {'responseData': responseData});
  }


 Future<List<String>> getPlateNumbers() async {
  final Database db = await instance.database;
  final List<Map<String, dynamic>> maps = await db.query('responses');
  
  List<String> plateNumbers = [];

  for (final map in maps) {
    final responseData = map['responseData'] as String;
    final responseMap = json.decode(responseData) as Map<String, dynamic>;
    
    final plateNumber = responseMap['plate_number'] as String;
    plateNumbers.add(plateNumber);
  }

  return plateNumbers;
}


  Future<void> deleteResponse(String responseData) async {
    final db = await database;
    await db.delete(
      'responses',
      where: 'responseData = ?',
      whereArgs: [responseData],
    );
  }
}

