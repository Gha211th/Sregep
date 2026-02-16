import 'package:flutter/material.dart';
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

  Future<List<double>> getDailyStats({required String range}) async {
    final List<Map<String, dynamic>> maps = await _dbService.getStudyStats(
      range,
    );

    int expectedLength = 7;
    if (range == 'Bulan Ini') expectedLength = 31;
    if (range == 'Tahun Ini') expectedLength = 12;

    List<double> fullData = List.filled(expectedLength, 0.0);

    for (var row in maps) {
      try {
        String labelRaw = row['label'].toString();
        int index = -1;

        DateTime? date;
        try {
          date = DateTime.parse(labelRaw);
        } catch (_) {}

        if (range == 'Tahun Ini') {
          index = (date != null ? date.month : int.parse(labelRaw)) - 1;
        } else if (range == 'Bulan Ini') {
          index = (date != null ? date.day : int.parse(labelRaw)) - 1;
        } else {
          if (date != null) {
            index = date.weekday - 1;
          } else {
            index = int.parse(labelRaw);
          }
        }

        if (index >= 0 && index < expectedLength) {
          fullData[index] += (row['total'] as num).toDouble();
        }
      } catch (e) {
        debugPrint("Error mapping data $e for label: ${row['label']}");
      }
    }
    return fullData;
  }
}
