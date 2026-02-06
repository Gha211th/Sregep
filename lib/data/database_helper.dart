import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
 static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('sregep_productivity.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
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
  }

  Future<int> insertStudyRecord(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert('study_records', row);
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query('study_records', orderBy: 'date DESC');
  }

  Future<List<Map<String, dynamic>>> getSubjectStats() async {
    final db = await instance.database;
    return await db.rawQuery('''
      SELECT subject, SUM(duration) as total_duration
      FROM study_records
      GROUP BY subject
      ORDER BY total_duration DESC
    ''');
  }

  Future<List<double>> getDailyStats() async {
    final db = await instance.database;
    final List<double> dailyDurations = List.filled(7, 0.0);
    final List<Map<String, dynamic>> maps = await db.query('study_records');

    for (var row in maps) {
      try {
        DateTime date = DateTime.parse(row['date']);
        int dayIndex = date.weekday - 1;

        if (dayIndex >= 0 && dayIndex < 7) {
          dailyDurations[dayIndex] += row['duration'].toDouble();
        }
      } catch (e) {
        print('error parsing date: $e');
      }
    }
    return dailyDurations;
  }
}
