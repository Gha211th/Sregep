import 'dart:async';
import 'package:flutter/material.dart';
import '../data/database_helper.dart';
import '../data/models/study_session.dart';
import 'package:intl/intl.dart';

class TimerProvider with ChangeNotifier {
  Timer? _timer;
  int _secondRemaining = 25 * 60;
  bool _isRunning = false;
  String _selectedSubject = 'Mapel Default';

  int get secondRemaining => _secondRemaining;
  bool get isRunning => _isRunning;
  String get selectedSubject => _selectedSubject;

  void setSubject(String subject) {
    _selectedSubject = subject;
    notifyListeners();
  }

  void startTimer() {
    if (_isRunning) return;
    _isRunning = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondRemaining > 0) {
        _secondRemaining--;
        notifyListeners();
      } else {
        stopTimer(isFinished: true);
      }
    });
  }

  void stopTimer({bool isFinished = false}) {
    _timer?.cancel();
    _isRunning = false;

    if (isFinished) {
      _saveSessionToDatabase();
      _secondRemaining = 25 * 60;
    }
    notifyListeners();
  }

  Future<void> _saveSessionToDatabase() async {
    int durationInMinutes = 25;
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    StudySession newSession = StudySession(
      subject: _selectedSubject,
      duration: durationInMinutes,
      date: today,
    );

    await DatabaseHelper.instance.insertSession(newSession);
    print("Sesi Belajar $_selectedSubject berhasil disimpan!");
  }
}
