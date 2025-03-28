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
                  Text(
                    (user?.bio?.length ?? 0) > 30 ? '${user?.bio?.substring(0, 30)}...' : user?.bio ?? "Bio",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Theme.of(context).brightness == Brightness.dark ? Colors.white70 : Colors.black54,
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 1,
                    softWrap: false,
                  ),
                  SizedBox(height: 10,),
                  Center(
                    child: FilledButton.icon(
                      onPressed: () async {
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
                      icon: const Icon(Icons.navigate_next, size: 22,),
                      label: Padding(
                        padding: const EdgeInsets.only(left: 3.0),
                        child: Text('Add Details', style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700
                        ),textAlign: TextAlign.center,),
                      ),
                      iconAlignment: IconAlignment.end,
                      style: ButtonStyle(
                        minimumSize: WidgetStateProperty.all(Size(0, 35)),
                      ),
                    ),
                  ),
                  SizedBox(height: 30,),
                ],
              ),
            ),
            SizedBox(height: 15,),
            _isSettingsLoading ? CircularProgressIndicator() : Column(
              children: [
                SettingsItem(
                  icon: Icons.contrast,
                  title: "Dark Mode",
                  iconSize: 23.0,
                  isSwitch: true,
                  isSwitched: settings?.isDarkMode ?? widget.isDarkMode,
                  onToggle: (value) {
                    onSwitchChanged("Dark Mode", value);
                    widget.onSwitchChanged("Dark Mode", value);
                  }
                ),
                SizedBox(height: 10,),
                SettingsItem(icon: FontAwesomeIcons.bell, title: "Notifications",iconSize: 21.0, onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationsPage()));
                }),
                SizedBox(height: 10,),
                SettingsItem(icon: Icons.help_outline_rounded, title: "Help and Support", iconSize: 25.0, onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => HelpAndSupportPage()));
                }),
                SizedBox(height: 10,),
                SettingsItem(icon: FontAwesomeIcons.fileLines, title: "Terms of Use", onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => TermsOfUsePage()));
                }),
                SizedBox(height: 10,),
                SettingsItem(icon: Icons.privacy_tip_outlined, title: "Privacy Policy",iconSize: 25.0, onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => PrivacyPolicyPage()));
                }),
                SizedBox(height: 10,),
                SettingsItem(icon: Icons.info_outline_rounded, title: "About", iconSize: 26.0, onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AboutPage()));
                }),
                SizedBox(height: 10,),
                Padding(
                  padding: EdgeInsets.only(left: 2.0),
                  child: SettingsItem(icon: Icons.logout_rounded, title: "Logout", iconSize: 25.0, onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LogoutPage()));
                  }),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

