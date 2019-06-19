import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart' show getApplicationDocumentsDirectory;
import 'package:path/path.dart' show join;
import 'dart:io' show Directory;
import 'package:rvce_results/models/student_model.dart';

class HistoryDatabase {
  HistoryDatabase._privateConstructor();
  // private generative constructor to implement the singleton pattern
  // can also achieve the pattern using factory constructor(when a constructor need not create a new instance of the class) as
  // factory HistoryDatabase() { return _instance; }
  // create as HistoryDatabase db = HistoryDatabase() -> when you want to hide that the class is a singleton

  static final String _databaseName = 'History.db';
  static final int _databaseVersion = 1;

  static final String _tableName = 'Data';

  static final String columnUsn = 'USN';
  static final String columnName = 'NAME';
  static final String columnSemester = 'SEMESTER';
  static final String columnSgpa = 'SGPA';

  static Database _database;
  // one instance of the database
  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the database the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  static final HistoryDatabase _instance = HistoryDatabase._privateConstructor();
  static HistoryDatabase get instance => _instance;
  // single instance of the class is maintained all over the app.

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
    // await dbClient.rawInsert
    // await dbClient.rawInsert('INSERT INTO $_tableName'
    //  '(${HistoryDatabase.columnUsn}, ${HistoryDatabase.columnName}, ${HistoryDatabase.columnSemester}, ${HistoryDatabase.columnSgpa})'
    //  'VALUES (?, ?, ?, ?)', [student.quickResult[HistoryDatabase.columnUsn], student.quickResult[HistoryDatabase.columnName], student.quickResult[HistoryDatabase.columnSemester], student.quickResult[HistoryDatabase.columnSgpa]]);
    // strings spanning over multiple lines are concatenated.
    await dbClient.insert(
      _tableName, 
      student.inFormatForDb(),
      conflictAlgorithm: ConflictAlgorithm.replace,
      );
  }

  Future<void> clearAllEntries() async {
    var dbClient = await database;
    // await dbClient.rawQuery('DELETE FROM $_tableName');
    // can also use TRUNCATE TABLE tablename for faster performance
    await dbClient.delete(_tableName);
  }

  Future<List<Map<String, dynamic>>> getAllData() async {
    var dbClient = await database;
    // return dbClient.rawQuery('SELECT * from $_tableName');
    return dbClient.query(_tableName);
    // return the future itself for the future builder
  }

  Future<void> clearSingleRow(String usn) async {
    var dbClient = await database;
    // await dbClient.rawDelete('DELETE FROM $_tableName WHERE USN = ?', [usn]);
    await dbClient.delete(_tableName, where: 'USN = ?', whereArgs: [usn]);
  }
  
  // Future<void> closeDatabase() async {
  //   var dbClient = await database;
  //   dbClient.close();
  // }

}