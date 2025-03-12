import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../pages/profile_page/add_details_page.dart';
import '../../pages/settings_page/_components/settings_item.dart';
import '../../pages/settings_page/about_page.dart';
import '../../pages/settings_page/help_and_support_page.dart';
import '../../pages/auth_page/logout_page.dart';
import '../../pages/settings_page/notifications_page.dart';
import '../../pages/settings_page/privacy_policy_page.dart';
import '../../pages/settings_page/terms_of_use_page.dart';
import '../../utils/extensions/color.dart';
import '../../models/settings.dart';
import '../../models/user.dart';
import '../../utils/assets.dart';

class SettingsPage extends StatefulWidget {
  final bool isDarkMode;
  final Function(String, bool) onSwitchChanged;
  const SettingsPage({super.key, required this.isDarkMode, required this.onSwitchChanged});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}
class _SettingsPageState extends State<SettingsPage> {
  User? user;
  Settings? settings;
  bool _isLoading = false;
  bool _isSettingsLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadSettingsData();
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

  Future<void> getSettingsFromLocal() async {
    setState(() {
      _isSettingsLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? settingsJson = prefs.getString('settings');

    if (settingsJson != null && settingsJson != "null") {
      Map<String, dynamic> settingsMap = jsonDecode(settingsJson);
      setState(() {
        settings = Settings.fromJson(settingsMap);
        _isSettingsLoading = false;
      });
    } else {
      setState(() {
        settings = Settings(
          followingShows: true,
          postAndStories: true,
          pauseAll: false,
          emailNotifications: true,
          isDarkMode: true,
        );
        _isSettingsLoading = false;
      });
    }
  }

  Future<void> saveSettingsToLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String settingsJson = jsonEncode(settings?.toJson());
    await prefs.setString('settings', settingsJson);
  }

  Future<void> _loadSettingsData() async {
    await getSettingsFromLocal();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Settings", style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold
        ),),
        backgroundColor: Theme.of(context).brightness == Brightness.dark ? Colors.black : HexColor.fromHex("#ADF7E3"),
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
              color: Theme.of(context).brightness == Brightness.dark ? Colors.black : HexColor.fromHex("#ADF7E3"),
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
                        color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                        width: 4.0,
                      ),
                    ),
                    child: ClipOval(
                      child: (user != null && user!.imagePath!.contains('assets/')) || user?.imagePath == null
                        ? Image.asset (
                          Assets.profilePA,
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
                  ) : CircularProgressIndicator(),
                  SizedBox(height: 10,),
                  Text(user?.name ?? "Your Name", style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18
                  )),
                  Text(user?.bio ?? "Bio", style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Theme.of(context).brightness == Brightness.dark ? Colors.white70 : Colors.black54
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
                        width: 155,
                        padding: EdgeInsets.only(left: 13.0, right: 0.0, top: 5.0, bottom: 5.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 4.0),
                              child: Text('Add Details', style: TextStyle(
                                color: Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w700
                              )),
                            ),
                            Spacer(),
                            Icon(
                              Icons.navigate_next,
                              size: 24,
                              color: Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white,
                              weight: 700,
                            ),
                            SizedBox(width: 5,)
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
            _isSettingsLoading ? CircularProgressIndicator() : Column(
              children: [
                SettingsItem(
                  icon: FontAwesomeIcons.circleHalfStroke,
                  title: "Dark Mode",
                  isSwitch: true,
                  isSwitched: settings?.isDarkMode ?? widget.isDarkMode,
                  onToggle: (value) {
                    onSwitchChanged("Dark Mode", value);
                    widget.onSwitchChanged("Dark Mode", value);
                  }
                ),
                SizedBox(height: 10,),
                SettingsItem(icon: FontAwesomeIcons.bell, title: "Notifications", onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationsPage()));
                }),
                SizedBox(height: 10,),
                SettingsItem(icon: Icons.help_outline_rounded, title: "Help and Support", onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => HelpAndSupportPage()));
                }),
                SizedBox(height: 10,),
                SettingsItem(icon: FontAwesomeIcons.fileLines, title: "Terms of Use", onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => TermsOfUsePage()));
                }),
                SizedBox(height: 10,),
                SettingsItem(icon: FontAwesomeIcons.circleCheck, title: "Privacy Policy", onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => PrivacyPolicyPage()));
                }),
                SizedBox(height: 10,),
                SettingsItem(icon: Icons.info_outline_rounded, title: "About", onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AboutPage()));
                }),
                SizedBox(height: 10,),
                SettingsItem(icon: Icons.logout_rounded, title: "Logout", onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => LogoutPage()));
                }),
              ],
            )
          ],
        ),
      ),
    );
  }
}

