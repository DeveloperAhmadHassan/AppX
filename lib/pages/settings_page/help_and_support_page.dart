import 'package:flutter/material.dart';

import '_components/settings_item.dart';

class HelpAndSupportPage extends StatelessWidget {
  const HelpAndSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 25.0),
              child: Text("help & support", style: Theme.of(context).textTheme.headlineSmall),
            ),
            SizedBox(height: 30,),
            SettingsItem(title: "Report a problem", morePadding: false,),
            SettingsItem(title: "Help Center", morePadding: false,),
          ],
        ),
      ),
    );
  }
}
