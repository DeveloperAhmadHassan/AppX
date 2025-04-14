import 'package:loopyfeed/utils/enums.dart';

class Settings {
  THEME? theme;
  bool? followingShows;
  bool? postAndStories;
  bool? pauseAll;
  bool? emailNotifications;

  Settings({
    this.theme,
    this.followingShows,
    this.postAndStories,
    this.pauseAll,
    this.emailNotifications,
  });

  Map<String, dynamic> toJson() {
    return {
      'theme': theme?.toString(), // convert enum to string
      'followingShows': followingShows,
      'postAndStories': postAndStories,
      'pauseAll': pauseAll,
      'emailNotifications': emailNotifications,
    };
  }

  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(
      theme: json['theme'] != null
          ? THEME.values.firstWhere(
            (e) => e.toString() == json['theme'],
        orElse: () => THEME.defaultValue, // Replace with your default
      )
          : null,
      followingShows: json['followingShows'],
      postAndStories: json['postAndStories'],
      pauseAll: json['pauseAll'],
      emailNotifications: json['emailNotifications'],
    );
  }
}
