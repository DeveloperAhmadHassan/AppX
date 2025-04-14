import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loopyfeed/pages/settings_page/report_a_problem_page.dart';

import '_components/settings_item.dart';
import 'help_center_page.dart';

class HelpAndSupportPage extends StatelessWidget {
  const HelpAndSupportPage({super.key});

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
        systemOverlayStyle: SystemUiOverlayStyle.light,
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
            SettingsItem(title: "Report a problem", morePadding: false, onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => ReportAProblemPage()));
            },),
            SettingsItem(title: "Help Center", morePadding: false, onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => HelpCenterPage()));
            },),
          ],
        ),
      ),
    );
  }
}
