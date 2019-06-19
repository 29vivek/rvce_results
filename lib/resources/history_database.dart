import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart' show getApplicationDocumentsDirectory;
import 'package:path/path.dart' show join;
import 'dart:io' show Directory;
import 'package:rvce_results/models/student_model.dart';

class HistoryDatabase {

  static final String _databaseName = 'History.db';
  static final int _databaseVersion = 1;

  static final String _tableName = 'Data';
  static final String columnUsn = 'USN';
  static final String columnName = 'NAME';
  static final String columnSemester = 'SEMESTER';
  static final String columnSgpa = 'SGPA';

  static Database _database;

  HistoryDatabase._privateConstructor();
  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  static final HistoryDatabase _instance = HistoryDatabase._privateConstructor();
  static HistoryDatabase get instance => _instance; 

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName (
        $columnUsn TEXT PRIMARY KEY,
        $columnName TEXT NOT NULL,
        $columnSemester INT NOT NULL, 
        $columnSgpa REAL NOT NULL
      )
    ''');
  }

  Future<void> insert(Student student) async {
    var dbClient = await database;
    await dbClient.insert(
      _tableName, 
      student.inFormatForDb(),
      conflictAlgorithm: ConflictAlgorithm.replace,
      );
  }

  Future<void> clearAllEntries() async {
    var dbClient = await database;
    await dbClient.delete(_tableName);
  }

  Future<List<Map<String, dynamic>>> getAllData() async {
    var dbClient = await database;
    return dbClient.query(_tableName);
  }

  Future<void> clearSingleRow(String usn) async {
    var dbClient = await database;
    await dbClient.delete(_tableName, where: 'USN = ?', whereArgs: [usn]);
  }

}