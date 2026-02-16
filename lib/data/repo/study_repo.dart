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
        int index = 0;
        if (range == 'Tahun Ini') {
          index = int.parse(row['label']) - 1;
        } else if (range == 'Bulan Ini') {
          index = int.parse(row['label']) - 1;
        } else {
          index = maps.indexOf(row);
        }

        if (index >= 0 && index < expectedLength) {
          fullData[index] = (row['total'] as num).toDouble();
        }
      } catch (e) {
        print("error parsing data index");
      }
    }
    return fullData;
  }
}
