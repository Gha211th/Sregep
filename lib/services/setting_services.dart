import 'package:shared_preferences/shared_preferences.dart';

class SettingServices {
  static const String _timerKey = "default_timer_minutes";
  static const String _accentColorKey = "accent_color";
  static const String _displayNameKey = "display_name";

  // TIMER SETTING
  Future<void> setTimerDuration(int minutes) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_timerKey, minutes);
  }

  Future<int> getTimerDuration() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_timerKey) ?? 25;
  }

  // COLOR SETTING
  Future<void> setAccentColor(int colorValue) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_accentColorKey, colorValue);
  }

  Future<int> getAccentColor() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_accentColorKey) ?? 0xFF2196F3;
  }

  // DISPLAY NAME SETTING
  Future<void> setDisplayName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_displayNameKey, name);
  }

  // Future<String> _getDisplayName() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   return prefs.getString(_displayNameKey) ?? "Your";
  // }
}
