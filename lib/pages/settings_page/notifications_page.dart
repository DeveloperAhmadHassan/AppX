import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:heroapp/models/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '_components/settings_item.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  bool _isLoading = false;
  Settings? settings;

  @override
  void initState() {
    super.initState();
    _loadSettingsData();
  }

  Future<void> getSettingsFromLocal() async {
    setState(() {
      _isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? settingsJson = prefs.getString('settings');

    if (settingsJson != null && settingsJson != "null") {
      Map<String, dynamic> settingsMap = jsonDecode(settingsJson);
      setState(() {
        settings = Settings.fromJson(settingsMap);
        _isLoading = false;
      });
    } else {
      setState(() {
        settings = Settings(
          followingShows: true,
          postAndStories: true,
          pauseAll: false,
          emailNotifications: true,
          isDarkMode: false,
        );
        _isLoading = false;
      });
    }
  }

  Future<void> saveSettingsToLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String settingsJson = jsonEncode(settings?.toJson());
    await prefs.setString('settings', settingsJson);
  }

  void onSwitchChanged(String settingName, bool value) {
    setState(() {
      if (settingName == "Following Shows") {
        settings?.followingShows = value;
      } else if (settingName == "Post and Stories") {
        settings?.postAndStories = value;
      } else if (settingName == "Pause All") {
        settings?.pauseAll = value;
      } else if (settingName == "Email Notifications") {
        settings?.emailNotifications = value;
      } else if (settingName == "Dark Mode") {
        settings?.isDarkMode = value;
      }
    });

    saveSettingsToLocal();
  }

  Future<void> _loadSettingsData() async {
    print("Here");
    await getSettingsFromLocal();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Notifications",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.black,
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10),
            SettingsItem(
              title: "Following Shows",
              isSwitch: true,
              isSwitched: settings?.followingShows ?? false,
              onToggle: (value) => onSwitchChanged("Following Shows", value),
            ),
            SettingsItem(
              title: "Post and Stories",
              isSwitch: true,
              isSwitched: settings?.postAndStories ?? false,
              onToggle: (value) => onSwitchChanged("Post and Stories", value),
            ),
            SettingsItem(
              title: "Pause All",
              isSwitch: true,
              isSwitched: settings?.pauseAll ?? false,
              onToggle: (value) => onSwitchChanged("Pause All", value),
            ),
            SettingsItem(
              title: "Email Notifications",
              isSwitch: true,
              isSwitched: settings?.emailNotifications ?? false,
              onToggle: (value) => onSwitchChanged("Email Notifications", value),
            ),
          ],
        ),
      ),
    );
  }
}
