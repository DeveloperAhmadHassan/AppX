import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../pages/settings_page/help_and_support_page.dart';
import '../../utils/constants.dart';
import '../../utils/extensions/color.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login", style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18
        )),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 30,),
            Center(
              child: Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: HexColor.fromHex(AppConstants.primaryColor)
                ),
              ),
            ),
            SizedBox(height: 130,),
            Text("Login to AppX", style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22
            )),
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width - 10,
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  children: [
                    SizedBox(height: 20,),
                    loginOption(FontAwesomeIcons.google, "Google"),
                    SizedBox(height: 20,),
                    loginOption(FontAwesomeIcons.facebook, "Facebook"),
                    SizedBox(height: 20,),
                    loginOption(FontAwesomeIcons.instagram, "Instagram"),
                    SizedBox(height: 20,),
                    loginOption(FontAwesomeIcons.xTwitter, "X"),
                    SizedBox(height: 20,),
                  ],
                ),
              ),
            ),
            SizedBox(height: 150,),
            InkWell(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => HelpAndSupportPage())),
              child: Center(
                child: Text("Need Help? Visit our help center", style: TextStyle(
                  fontWeight: FontWeight.bold
                )),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget loginOption(IconData icon, String title) {
    return Container(
      padding: EdgeInsets.all(13.0),
      decoration: BoxDecoration(
          color: HexColor.fromHex(AppConstants.primaryColor),
          borderRadius: BorderRadius.circular(10)
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.black, size: 20,),
          SizedBox(width: 30,),
          Center(child: Text("Continue With $title",style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16
          ) ,textAlign: TextAlign.center,))
        ],
      ),
    );
  }
}
