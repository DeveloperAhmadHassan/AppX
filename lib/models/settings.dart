class Settings {
  bool? isDarkMode;
  bool? followingShows;
  bool? postAndStories;
  bool? pauseAll;
  bool? emailNotifications;

  Settings({
    this.isDarkMode,
    this.followingShows,
    this.postAndStories,
    this.pauseAll,
    this.emailNotifications,
  });

  Map<String, dynamic> toJson() {
    return {
      'isDarkMode': isDarkMode,
      'followingShows': followingShows,
      'postAndStories': postAndStories,
      'pauseAll': pauseAll,
      'emailNotifications': emailNotifications,
    };
  }

  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(
      isDarkMode: json['isDarkMode'],
      followingShows: json['followingShows'],
      postAndStories: json['postAndStories'],
      pauseAll: json['pauseAll'],
      emailNotifications: json['emailNotifications'],
    );
  }
}
