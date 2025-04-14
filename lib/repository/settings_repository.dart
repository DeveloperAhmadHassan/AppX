import 'dart:convert';
import 'package:loopyfeed/models/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/enums.dart';

class SettingsRepository {
  static const String _key = 'settings';

  static Future<Settings?> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    if (jsonString == null) return null;

    final Map<String, dynamic> json = jsonDecode(jsonString);
    return Settings.fromJson(json);
  }

  static Future<void> saveSettings(Settings settings) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(settings.toJson());
    await prefs.setString(_key, jsonString);
  }

  static Future<THEME?> getTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    if (jsonString == null) return null;

    final Map<String, dynamic> json = jsonDecode(jsonString);
    final String? themeString = json['theme'];
    if (themeString == null) return null;

    return THEME.values.firstWhere(
          (e) => e.toString() == themeString,
      orElse: () => THEME.defaultValue,
    );
  }
}
