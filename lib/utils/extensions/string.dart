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

extension AuthValidation on String {
  bool get isValidEmail {
    final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return regex.hasMatch(this);
  }
}


extension DateFormatExtension on String {
  String toFormattedDate() {
    DateTime watchedDate = DateTime.parse(this);
    DateTime currentDate = DateTime.now();

    watchedDate = DateTime(watchedDate.year, watchedDate.month, watchedDate.day);
    currentDate = DateTime(currentDate.year, currentDate.month, currentDate.day);

    if (watchedDate.isAtSameMomentAs(currentDate)) {
      return "Today";
    }

    if (watchedDate.isBefore(currentDate) && watchedDate.isAfter(currentDate.subtract(Duration(days: 1)))) {
      return "Yesterday";
    }

    int daysDifference = currentDate.difference(watchedDate).inDays;

    return daysDifference > 1 ? "$daysDifference days ago" : "$daysDifference day ago";
  }
}

extension TimeConversion on String {
  Duration toDuration() {
    final parts = split(':');
    final minutes = int.parse(parts[0]);
    final seconds = int.parse(parts[1]);
    return Duration(minutes: minutes, seconds: seconds);
  }

  int toSeconds() {
    final parts = split(':');
    final minutes = int.parse(parts[0]);
    final seconds = int.parse(parts[1]);
    return (minutes * 60) + seconds;
  }
}
