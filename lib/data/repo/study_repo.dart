import 'package:sregep_productivity_app/data/database_helper.dart';

class StudyRepository {
  final _dbService = DatabaseService.instance;

  Future<int> insertStudyRecord(Map<String, dynamic> row) async {
    final db = await _dbService.database;
    return await db.insert('study_records', row);
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    final db = await _dbService.database;
    return await db.query('study_records', orderBy: 'date DESC');
  }

  Future<List<Map<String, dynamic>>> getSubjectStats() async {
    final db = await _dbService.database;
    return await db.rawQuery('''
      SELECT subject, SUM(duration) as total_duration
      FROM study_records
      GROUP BY subject
      ORDER BY total_duration DESC
    ''');
  }

  Future<List<double>> getDailyStats() async {
    final db = await _dbService.database;
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
        print('Error parsing date: $e');
      }
    }
    return dailyDurations;
  }
}
