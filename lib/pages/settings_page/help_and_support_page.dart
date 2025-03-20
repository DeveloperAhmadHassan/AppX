import 'package:flutter/material.dart';

import '_components/settings_item.dart';

class HelpAndSupportPage extends StatelessWidget {
  const HelpAndSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Help and Support", style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18
        )),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 30,),
            SettingsItem(title: "Report a problem", morePadding: false,),
            SettingsItem(title: "Help Center", morePadding: false,),
          ],
        ),
      ),
    );
  }
}
