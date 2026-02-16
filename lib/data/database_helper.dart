import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;

  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('sregep_productivity.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE study_records (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        subject TEXT NOT NULL,
        duration INTEGER NOT NULL,
        date TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE todos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        task TEXT NOT NULL,
        date TEXT NOT NULL,
        is_completed INTEGER NOT NULL DEFAULT 0
      )
    ''');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS todos (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          task TEXT NOT NULL,
          date TEXT NOT NULL,
          is_completed INTEGER NOT NULL DEFAULT 0
        )
      ''');
    }
  }

  Future<List<Map<String, dynamic>>> getStudyStats(String range) async {
    final db = await database;
    String query;

    if (range == 'Tahun Ini') {
      query = '''
      SELECT strftime('%m', date) as label, SUM(duration) as total 
      FROM study_records 
      WHERE date >= date('now', 'start of year')
      GROUP BY label 
      ORDER BY label ASC
    ''';
    } else if (range == 'Bulan Ini') {
      query = '''
      SELECT strftime('%d', date) as label, SUM(duration) as total 
      FROM study_records 
      WHERE date >= date('now', 'start of month')
      GROUP BY label 
      ORDER BY label ASC
    ''';
    } else {
      query = '''
      SELECT date as label, SUM(duration) as total 
      FROM study_records 
      WHERE date >= date('now', '-7 days')
      GROUP BY label 
      ORDER BY label ASC
    ''';
    }

    return await db.rawQuery(query);
  }
}
