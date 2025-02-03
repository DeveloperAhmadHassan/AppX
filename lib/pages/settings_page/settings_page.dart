import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:heroapp/pages/profile_page/add_details_page.dart';
import 'package:heroapp/pages/settings_page/_components/settings_item.dart';
import 'package:heroapp/pages/settings_page/about_page.dart';
import 'package:heroapp/pages/settings_page/help_and_support_page.dart';
import 'package:heroapp/pages/auth_page/logout_page.dart';
import 'package:heroapp/pages/settings_page/notifications_page.dart';
import 'package:heroapp/pages/settings_page/privacy_policy_page.dart';
import 'package:heroapp/pages/settings_page/terms_of_use_page.dart';
import 'package:heroapp/utils/constants.dart';
import 'package:heroapp/utils/extensions/color.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/user.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}
class _SettingsPageState extends State<SettingsPage> {
  User? user;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> getUserFromLocal() async {
    setState(() {
      _isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString('user');
    if (userJson != null) {
      Map<String, dynamic> userMap = jsonDecode(userJson);
      setState(() {
        user = User.fromJson(userMap);
        _isLoading = false;
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _loadUserData() async {
    await getUserFromLocal();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Settings", style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold
        ),),
        backgroundColor: HexColor.fromHex(AppConstants.primaryColor),
        leading: IconButton(
          icon: Icon(Icons.arrow_back,),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              color: HexColor.fromHex(AppConstants.primaryColor),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 20,),
                  !_isLoading
                      ? Container(
                    width: 100.0,
                    height: 100.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.black,
                        width: 4.0,
                      ),
                    ),
                    child: ClipOval(
                      child: (user != null && user!.imagePath!.contains('assets/')) || user?.imagePath == null
                        ? Image.asset (
                          'assets/profile/p_a.jpg',
                          width: 100.0,
                          height: 100.0,
                          fit: BoxFit.cover,
                        ) : Image.file (
                          File(user!.imagePath ?? ""),
                          width: 100.0,
                          height: 100.0,
                          fit: BoxFit.cover,
                      ),
                    ),
                  )
                      : CircularProgressIndicator(),
                  SizedBox(height: 10,),
                  Text(user?.name ?? "Your Name", style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18
                  )),
                  Text(user?.bio ?? "Your Designation", style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14
                  )),
                  SizedBox(height: 10,),
                  InkWell(
                    onTap: () async {
                      var result = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddDetailsPage()),
                      );

                      if (!mounted) return;

                      setState(() {
                        if (result == true) {
                          _loadUserData();
                        }
                      });
                    },
                    child: Center(
                      child: Container(
                        width: 120,
                        padding: EdgeInsets.only(left: 13.0, right: 0.0, top: 5.0, bottom: 5.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.black
                        ),
                        child: Row(
                          children: [
                            Text('Add Details', style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold
                            )),
                            SizedBox(width: 2,),
                            const Icon(Icons.navigate_next, color: Colors.white, size: 24, weight: 700,)
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30,),
                ],
              ),
            ),
            SizedBox(height: 35,),
            SettingsItem(icon: FontAwesomeIcons.circleHalfStroke, title: "Dark Mode", isSwitch: true),
            SettingsItem(icon: FontAwesomeIcons.bell, title: "Notifications", onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationsPage()));
            }),
            SettingsItem(icon: Icons.help_outline_rounded, title: "Help and Support", onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => HelpAndSupportPage()));
            }),
            SettingsItem(icon: FontAwesomeIcons.fileLines, title: "Terms of Use", onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => TermsOfUsePage()));
            }),
            SettingsItem(icon: FontAwesomeIcons.circleCheck, title: "Privacy Policy", onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => PrivacyPolicyPage()));
            }),
            SettingsItem(icon: Icons.info_outline_rounded, title: "About", onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => AboutPage()));
            }),
            SettingsItem(icon: Icons.logout_rounded, title: "Logout", onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => LogoutPage()));
            }),
          ],
        ),
      ),
    );
  }
}

