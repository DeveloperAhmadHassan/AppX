import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/daily_usage.dart';

class UsageRepository {
  static const String _key = 'daily_usage_map';

  static Future<Map<String, DailyUsage>> loadUsageMap() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    if (jsonString == null) return {};

    final Map<String, dynamic> rawMap = jsonDecode(jsonString);
    return rawMap.map((key, value) => MapEntry(
      key,
      DailyUsage.fromJson(value),
    ));
  }

  static Future<void> saveUsageMap(Map<String, DailyUsage> usageMap) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(
      usageMap.map((key, value) => MapEntry(key, value.toJson())),
    );
    await prefs.setString(_key, jsonString);
  }
}
