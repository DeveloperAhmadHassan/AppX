import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:loopyfeed/utils/enums.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '_components/settings_item.dart';
import '../../../models/settings.dart';


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
          theme: THEME.dark,
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
      }
    });

    saveSettingsToLocal();
  }

  Future<void> _loadSettingsData() async {
    await getSettingsFromLocal();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back,size: 34,),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 25.0),
              child: Text(
                "notifications",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
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
