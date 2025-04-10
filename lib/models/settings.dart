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
      'theme': theme,
      'followingShows': followingShows,
      'postAndStories': postAndStories,
      'pauseAll': pauseAll,
      'emailNotifications': emailNotifications,
    };
  }

  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(
      theme: json['theme'],
      followingShows: json['followingShows'],
      postAndStories: json['postAndStories'],
      pauseAll: json['pauseAll'],
      emailNotifications: json['emailNotifications'],
    );
  }
}
