import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'navigation_tab_controller.dart';
import '../pages/auth_page/login_page.dart';
import '../pages/carousel_page/_components/globals.dart';
import '../pages/side_page/categories_page/categories_page.dart';
import '../pages/side_page/watch_history_page/watch_history_page.dart';
import '../pages/profile_page/add_details_page.dart';
import '../pages/settings_page/settings_page.dart';
import '../pages/side_page/liked_videos_page/liked_videos_page.dart';
import '../utils/components/gradient_divider.dart';
import '../models/reel.dart';
import '../models/user.dart';
import '../utils/assets.dart';
import '../utils/constants.dart';
import '../utils/extensions/color.dart';

class MenuDashboardPage extends StatefulWidget {
  final bool isDarkMode;
  final Function(String, bool) onSwitchChanged;

  const MenuDashboardPage({super.key, required this.isDarkMode, required this.onSwitchChanged});


  @override
  State<MenuDashboardPage> createState() => _MenuDashboardPageState();
}

class _MenuDashboardPageState extends State<MenuDashboardPage> with TickerProviderStateMixin {
  bool isCollapsed = true;
  late double screenWidth, screenHeight;
  final Duration duration = const Duration(milliseconds: 300);
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _menuScaleAnimation;
  late Animation<Offset> _slideAnimation;
  User? user;
  bool _isLoading = false;
  late TabController _tabController;
  Reel? _selectedReel;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: duration);
    _scaleAnimation = Tween<double>(begin: 1, end: 1).animate(_controller);
    _menuScaleAnimation = Tween<double>(begin: 0.5, end: 1).animate(_controller);
    _slideAnimation = Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0)).animate(_controller);
    _tabController = TabController(length: 3, vsync: this, initialIndex: 2);
    _loadUserData();
  }

  void _handleReelSelected(Reel? reel) {
    setState(() {
      _selectedReel = reel;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _tabController.dispose();
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
    await getUserFromLocal();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    screenHeight = size.height;
    screenWidth = size.width;

    return Scaffold(
        backgroundColor: Theme.of(context).brightness == Brightness.dark ? Colors.black : HexColor.fromHex(AppConstants.primaryColor),
        body: Stack(
          children: <Widget>[
            menu(context),
            dashboard(context),
          ],
        ),
      );
  }

  Widget menu(BuildContext context) {
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
                    InkWell(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AddDetailsPage())),
                      child: Container(
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
                    ),
                    SizedBox(height: 10,),
                    Text("Hello, ${user?.name ?? "User"}!",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                      )),
                  ],
                ),
                OutlinedButton.icon(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage())),
                  icon: const Icon(Icons.add, size: 24, weight: 700,),
                  label: const Text('Login', style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold
                  ),),
                  iconAlignment: IconAlignment.start,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                      width: 2.0,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 0.0),
                  ),
                ),
                SizedBox(height: 30),
                GradientDivider(),
                SizedBox(height: 30),
                menuItem(icon: FontAwesomeIcons.heart, title: "Liked Videos", onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => LikedVideosPage(
                    tabController: _tabController,
                    onReelSelected: _handleReelSelected,
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
                  )));
                }),
                SizedBox(height: 20),
                menuItem(icon: FontAwesomeIcons.list, title: "Categories", onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const CategoriesPage()));
                }),
                SizedBox(height: 20),
                menuItem(icon: FontAwesomeIcons.clockRotateLeft, title: "Watch History", onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => WatchHistoryPage()));
                }),
                SizedBox(height: 30),
                GradientDivider(),
                SizedBox(height: 30),
                menuItem(title: "Settings", svgIcon: SvgPicture.asset(
                  Assets.iconsSettings,
                    semanticsLabel: 'Settings Logo',
                    height: 24,
                    width: 24,
                    colorFilter: ColorFilter.mode(Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black, BlendMode.srcIn),
                  ),
                  onPressed: () async {
                  var result = await Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage(
                    isDarkMode: widget.isDarkMode,
                    onSwitchChanged: widget.onSwitchChanged,
                  )));

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

  Widget dashboard(BuildContext context) {
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
              tabController: _tabController,
              handleReelSelected: _handleReelSelected,
              selectedReel: _selectedReel,
              onSideMenuClick: () {
                setState(() {
                  if (isCollapsed) {
                    _controller.forward();
                    videoPlayerController.pause();
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

  Widget menuItem({IconData? icon, required String title, GestureTapCallback? onPressed, SvgPicture? svgIcon}){
    return InkWell(
      onTap: (){
        onPressed?.call();
      },
      child: Row(
        children: [
          icon != null
            ? Icon(icon, size: 20)
            : svgIcon ?? Container(),
          SizedBox(width: icon != null ? 20 : 15,),
          SizedBox(
            width: 160,
            child: Text(title, style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              // color: Colors.white
            )),
          ),
          Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark ? Colors.blueGrey[300] : HexColor.fromHex(AppConstants.primaryColor),
              borderRadius: BorderRadius.circular(100)
            ),
            child: Icon(Icons.navigate_next),
          ),
        ],
      ),
    );
  }
}