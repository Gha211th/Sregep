import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../data/models/study_session.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('study_focus.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int vesion) async {
    await db.execute('''
      CREATE TABLE session (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        subject TEXT NOT NULL,
        duration INTEGER NOT NULL,
        date TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertSession(StudySession session) async {
    final db = await instance.database;
    return await db.insert('session', session.toMap());
  }

  Future<List<StudySession>> getAllSession() async {
    final db = await instance.database;
    final result = await db.query('session', orderBy: 'date DESC');

    return result.map((json) => StudySession.fromMap(json)).toList();
  }
}
