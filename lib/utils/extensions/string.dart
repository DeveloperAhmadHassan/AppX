import 'package:intl/intl.dart';

extension NumberFormatting on String {
  String get formattedNumber {
    double number = double.tryParse(this) ?? 0;

    if (number >= 1e9) {
      return '${(number / 1e9).toStringAsFixed(1)}B';
    } else if (number >= 1e6) {
      return '${(number / 1e6).toStringAsFixed(1)}M';
    } else if (number >= 1e3) {
      return '${(number / 1e3).toStringAsFixed(1)}K';
    } else {
      return number.toStringAsFixed(0);
    }
  }
}

extension DateFormatExtension on String {
  String toFormattedDate() {
    DateTime watchedDate = DateTime.parse(this); // Convert string to DateTime
    DateTime currentDate = DateTime.now();

    // Remove time part for comparison (just compare the date)
    watchedDate = DateTime(watchedDate.year, watchedDate.month, watchedDate.day);
    currentDate = DateTime(currentDate.year, currentDate.month, currentDate.day);

    // If the date is today
    if (watchedDate.isAtSameMomentAs(currentDate)) {
      return "Today";
    }

    // If the date is yesterday
    if (watchedDate.isBefore(currentDate) && watchedDate.isAfter(currentDate.subtract(Duration(days: 1)))) {
      return "Yesterday";
    }

    // Calculate the difference in days
    int daysDifference = currentDate.difference(watchedDate).inDays;

    // If the difference is more than 1 day, show the number of days ago
    return "$daysDifference days ago";
  }
}

