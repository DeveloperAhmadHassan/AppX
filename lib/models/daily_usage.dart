// usage_model.dart
class DailyUsage {
  final String date; // Format: YYYY-MM-DD
  int appOpenCount;
  int screenTimeSeconds;

  DailyUsage({
    required this.date,
    this.appOpenCount = 0,
    this.screenTimeSeconds = 0,
  });

  factory DailyUsage.fromJson(Map<String, dynamic> json) {
    return DailyUsage(
      date: json['date'],
      appOpenCount: json['appOpenCount'],
      screenTimeSeconds: json['screenTimeSeconds'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'appOpenCount': appOpenCount,
      'screenTimeSeconds': screenTimeSeconds,
    };
  }
}
