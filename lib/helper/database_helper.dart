import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:intl/intl.dart'; // Import DateFormat

class ResponseWithDateTime {
  final String plateNumber;
  final String dayOfWeek;
  final String formattedDate;
  final String formattedTime;

  ResponseWithDateTime({
    required this.plateNumber,
    required this.dayOfWeek,
    required this.formattedDate,
    required this.formattedTime,
  });
}

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
    return await openDatabase(
      path,
      version: 2, // Increment the version number
      onCreate: _createTable,
      onUpgrade: _onUpgrade, // Add this callback
    );
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
      // Perform any necessary database schema changes here
      await db.execute('DROP TABLE IF EXISTS responses');
      await _createTable(db, newVersion);
    }
  }

  Future<void> _createTable(Database db, int version) async {
    // Create your database table(s) here
    await db.execute('''
      CREATE TABLE responses(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        responseData TEXT,
        timestamp INTEGER
      )
    ''');
  }

  Future<void> insertResponse(String responseData) async {
    final int timestamp = DateTime.now().millisecondsSinceEpoch;
    final Database db = await instance.database;
    await db.insert(
        'responses', {'responseData': responseData, 'timestamp': timestamp});
  }

  Future<List<ResponseWithDateTime>> getPlateNumbers() async {
    final Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'responses',
      orderBy: 'timestamp DESC', // Sort by timestamp in descending order
    );

    List<ResponseWithDateTime> responses = [];

    for (final map in maps) {
      final responseData = map['responseData'] as String;
      final responseMap = json.decode(responseData) as Map<String, dynamic>;

      final plateNumber = responseMap['plate_number'] as String;
      final timestampInMilliseconds = map['timestamp'];

      if (timestampInMilliseconds != null && timestampInMilliseconds is int) {
        final dateTime =
            DateTime.fromMillisecondsSinceEpoch(timestampInMilliseconds);
        final dayOfWeek =
            DateFormat('EEEE').format(dateTime); // Day of the week
        final formattedDate =
            DateFormat('yyyy-MM-dd').format(dateTime); // Formatted date
        final formattedTime =
            DateFormat('HH:mm:ss').format(dateTime); // Formatted time

        final responseWithDateTime = ResponseWithDateTime(
          plateNumber: plateNumber,
          dayOfWeek: dayOfWeek,
          formattedDate: formattedDate,
          formattedTime: formattedTime,
        );

        responses.add(responseWithDateTime);
      }
    }

    return responses;
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
