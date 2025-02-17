import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:heroapp/pages/auth_page/login_page.dart';
import 'package:heroapp/pages/menu_page/watch_history_page.dart';
import 'package:heroapp/pages/settings_page/settings_page.dart';
import 'package:heroapp/pages/side_page/liked_videos_page.dart';
import 'package:heroapp/utils/components/gradient_divider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';
import '../utils/constants.dart';
import '../utils/extensions/color.dart';
import 'navigation_tab_controller.dart';

class MenuDashboardPage extends StatefulWidget {
  const MenuDashboardPage({super.key});

  @override
  _MenuDashboardPageState createState() => _MenuDashboardPageState();
}

class _MenuDashboardPageState extends State<MenuDashboardPage> with SingleTickerProviderStateMixin {
  bool isCollapsed = true;
  late double screenWidth, screenHeight;
  final Duration duration = const Duration(milliseconds: 300);
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _menuScaleAnimation;
  late Animation<Offset> _slideAnimation;
  User? user;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: duration);
    _scaleAnimation = Tween<double>(begin: 1, end: 1).animate(_controller);
    _menuScaleAnimation = Tween<double>(begin: 0.5, end: 1).animate(_controller);
    _slideAnimation = Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0)).animate(_controller);
    _loadUserData();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
    print("Here");
    await getUserFromLocal();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    screenHeight = size.height;
    screenWidth = size.width;

    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Stack(
        children: <Widget>[
          menu(context),
          dashboard(context),
        ],
      ),
    );
  }

  Widget menu(context) {
    return SlideTransition(
      position: _slideAnimation,
      child: ScaleTransition(
        scale: _menuScaleAnimation,
        child: Padding(
          padding: const EdgeInsets.only(left: 25.0, top: 60.0),
          child: Align(
            alignment: Alignment.topLeft,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _isLoading ? CircularProgressIndicator() : Column(
                  children: [
                    Container(
                      width: 120.0,
                      height: 120.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 4.0,
                        ),
                      ),
                      child: ClipOval(
                        child: (user != null && user!.imagePath!.contains('assets/')) || user?.imagePath == null || user == null
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
                    ),
                    SizedBox(height: 10,),
                    Text("Hello, ${user?.name ?? "User"}!",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold
                        )),
                  ],
                ),
                OutlinedButton.icon(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage())),
                  icon: const Icon(Icons.add, color: Colors.white, size: 24, weight: 700,),
                  label: const Text('Login', style: TextStyle(
                    color: Colors.white,
                    fontSize: 22
                  ),),
                  iconAlignment: IconAlignment.start,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: Colors.white,
                      width: 3.0,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                GradientDivider(),
                SizedBox(height: 20),
                menuItem(Icons.favorite_border_outlined, "Liked Videos", onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const LikedVideosPage()));
                }),
                SizedBox(height: 20),
                menuItem(FontAwesomeIcons.list, "Categories", onPressed: (){
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsPage()));
                }),
                SizedBox(height: 20),
                menuItem(Icons.history, "Watch History", onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const WatchHistoryPage()));
                }),
                SizedBox(height: 30),
                GradientDivider(),
                SizedBox(height: 30),
                menuItem(Icons.settings, "Settings", onPressed: () async {
                  var result = await Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsPage()));

                  if (!mounted) return;

                  setState(() {
                    if(result == true){
                      _loadUserData();
                    }
                  });
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget dashboard(context) {
    return AnimatedPositioned(
      duration: duration,
      top: isCollapsed ? 0 : 0.5 * screenWidth,
      bottom: isCollapsed ? 0 : 0.2 * screenWidth,
      left: isCollapsed ? 0 : 0.80 * screenWidth,
      right: isCollapsed ? 0 : -0.2 * screenWidth,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          decoration: BoxDecoration(
            color: HexColor.fromHex(AppConstants.primaryColor),
            borderRadius: BorderRadius.all(Radius.circular(isCollapsed ? 0 : 40)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                offset: Offset(0, 8),
                blurRadius: 10,
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                offset: Offset(-7, 0),
                blurRadius: 10,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(isCollapsed ? 0 : 40)),
            child: NavigationTabController(
              onSideMenuClick: () {
                setState(() {
                  if (isCollapsed) {
                    _controller.forward();
                  } else {
                    _controller.reverse();
                  }

                  isCollapsed = !isCollapsed;
                });
              },
              isCollapsed: isCollapsed,
            ),
          ),
        ),
      ),
    );
  }

  Widget menuItem(IconData icon, String title, {GestureTapCallback? onPressed}){
    return InkWell(
      onTap: (){
        onPressed?.call();
      },
      child: Row(
        children: [
          Icon(icon, size: 25, color: Colors.white,),
          SizedBox(width: 20,),
          SizedBox(
            width: 180,
            child: Text(title, style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w500,
              color: Colors.white
            )),
          ),
          Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
                color: HexColor.fromHex(AppConstants.primaryColor),
                borderRadius: BorderRadius.circular(100)
            ),
            child: Icon(Icons.navigate_next),
          ),
        ],
      ),
    );
  }
}