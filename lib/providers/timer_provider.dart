import 'dart:async';
import 'package:flutter/material.dart';

class TimerProvider with ChangeNotifier {
  Timer? _timer;
  int _remainingSeconds = 1500;
  bool _isRunning = false;
  String _selectedSubject = 'MTK';
  int _currentSeconds = 0;

  int get remainingSeconds => _remainingSeconds;
  bool get isRunning => _isRunning;
  String get selectedSubject => _selectedSubject;
  double get progress => _remainingSeconds / 1500;
  int get currentSeconds => _currentSeconds;

  String get timeString {
    int minutes = _remainingSeconds ~/ 60;
    int seconds = _remainingSeconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  void selectSubject(String subject) {
    if (!_isRunning) {
      _selectedSubject = subject;
      notifyListeners();
    }
  }

  void startTimer() {
    if (!_isRunning) {
      _isRunning = true;
      notifyListeners();
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
          _currentSeconds++;
          notifyListeners();
        } else {
          stopTimer();
        }
      });
    }
  }

  void stopTimer() {
    _timer?.cancel();
    _isRunning = false;
    notifyListeners();
  }

  void restartTimer() {
    _isRunning = false;
    _currentSeconds = 0;
    _remainingSeconds = 1500;
    notifyListeners();  
  }
}
