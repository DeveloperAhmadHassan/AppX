import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loopyfeed/pages/settings_page/theme_page.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
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
import '../../utils/constants.dart';
import 'package:loopyfeed/utils/enums.dart';

class SettingsPage extends StatefulWidget {
  final THEME theme;
  final Function(String, THEME) onSwitchChanged;
  const SettingsPage({super.key, required this.theme, required this.onSwitchChanged});

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
          theme: THEME.dark,
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
      }
    });

    saveSettingsToLocal();
  }

  void changeTheme(THEME value) {
    setState(() {
     settings?.theme = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).brightness == Brightness.dark ? HexColor.fromHex(AppConstants.primaryColor) : HexColor.fromHex(AppConstants.primaryColor),
        leading: Container(
          margin: EdgeInsets.only(left: 3),
          child: IconButton(
            icon: Icon(Icons.arrow_back,size: 34, color: HexColor.fromHex(AppConstants.primaryBlack),),
            onPressed: () {
              Navigator.pop(context, true);
            },
          ),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(bottom: 20.0),
              color: Theme.of(context).brightness == Brightness.dark ? HexColor.fromHex(AppConstants.primaryColor) : HexColor.fromHex(AppConstants.primaryColor),
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  "settings",
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: HexColor.fromHex(AppConstants.primaryBlack),
                  ),
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.only(left: 0.0, bottom: 30.0),
              color: Theme.of(context).brightness == Brightness.dark ? HexColor.fromHex(AppConstants.primaryColor) : HexColor.fromHex(AppConstants.primaryColor),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20,),
                  !_isLoading
                      ? Container(
                    width: 120.0,
                    height: 120.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: (user != null && user!.imagePath!.contains('assets/')) || user?.imagePath == null ? null : Border.all(
                        color: Theme.of(context).brightness == Brightness.dark ? HexColor.fromHex(AppConstants.primaryBlack) : HexColor.fromHex(AppConstants.primaryBlack),
                        width: 4.0,
                      ),
                    ),
                    child: ClipOval(
                      child: (user != null && user!.imagePath!.contains('assets/')) || user?.imagePath == null
                        ? Container(
                          height: 100,
                          padding: EdgeInsets.all(8),
                          margin: EdgeInsets.all(4),
                          width: 100,
                          // color: Colors.black,
                          child: SvgPicture.asset(Assets.iconsSettingsUser, height: 10, width: 10,)
                        ) : Image.file (
                          File(user!.imagePath ?? ""),
                          width: 120.0,
                          height: 120.0,
                          fit: BoxFit.cover,
                      ),
                    ),
                  ) : CircularProgressIndicator(),
                  SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.only(left: 0.0, top: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 13.0),
                          child: Text(user?.name ?? "User", style: TextStyle(
                            // fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: HexColor.fromHex(AppConstants.primaryBlack)
                          )),
                        ),
                        SizedBox(height: 5,),
                        FilledButton.icon(
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
                          icon: Icon(Icons.navigate_next, size: 30, color: HexColor.fromHex(AppConstants.primaryWhite),),
                          label: Padding(
                            padding: const EdgeInsets.only(left: 7.0),
                            child: Text('Edit Details', style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),textAlign: TextAlign.center,),
                          ),
                          iconAlignment: IconAlignment.end,
                          style: ButtonStyle(
                              minimumSize: WidgetStateProperty.all(Size(0, 50)),
                              padding: WidgetStateProperty.all(EdgeInsets.symmetric(horizontal: 13.0))
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 30,),
                ],
              ),
            ),
            _isSettingsLoading ? CircularProgressIndicator() : Column(
              children: [
                SizedBox(height: 35,),
                SettingsItem(icon: Icons.contrast, title: "Display", iconSize: 23.0, onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ThemePage(theme: widget.theme, onToggle: (value) {
                      // onSwitchChanged("Theme", value == THEME.dark ? true : false);
                      widget.onSwitchChanged("Theme", value);
                      changeTheme(value);
                    },)));
                  },
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

