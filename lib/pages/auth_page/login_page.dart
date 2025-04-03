import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loopyfeed/utils/components/full_logo.dart';

import '../../pages/settings_page/help_and_support_page.dart';
import '../../utils/constants.dart';
import '../../utils/extensions/color.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

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
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 30,),
            FullLogo(),
            SizedBox(height: 130,),
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Login to", style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                  color: HexColor.fromHex("#F8FFE0").withValues(alpha: 3.0)
                )),
                SizedBox(width: 7,),
                Image.asset(AppConstants.iconsSecondaryLogo, fit: BoxFit.contain,)
              ],
            ),
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
            SizedBox(height: 80,),
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
      padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 13.0),
      decoration: BoxDecoration(
        color: HexColor.fromHex("#E1FF8B"),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.black, size: 23),
          Expanded(
            child: Center(
              child: Text(
                "Continue With $title",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

}
