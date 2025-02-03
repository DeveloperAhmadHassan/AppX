import 'package:flutter/material.dart';

import '_components/settings_item.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications", style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18
        )),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 30,),
            SettingsItem(title: "Following Shows", isSwitch: true),
            SettingsItem(title: "Post and Stories", isSwitch: true),
            SettingsItem(title: "Pause All", isSwitch: true),
            SettingsItem(title: "Email Notifications", isSwitch: true),
          ],
        ),
      )
    );
  }
}
