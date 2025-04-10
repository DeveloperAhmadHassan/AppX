import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loopyfeed/pages/auth_page/login_signup_page.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../pages/side_page/saved_videos_page/saved_videos_page.dart';
import '../pages/auth_page/login_page.dart';
import '../pages/carousel_page/_components/globals.dart';
import '../pages/side_page/categories_page/categories_page.dart';
import '../pages/side_page/watch_history_page/watch_history_page.dart';
import '../pages/profile_page/add_details_page.dart';
import '../pages/settings_page/settings_page.dart';
import '../pages/side_page/liked_videos_page/liked_videos_page.dart';
import '../models/reel.dart';
import '../models/user.dart';
import '../utils/assets.dart';
import '../utils/constants.dart';
import '../utils/enums.dart';
import '../utils/extensions/color.dart';

import 'navigation_tab_controller.dart';

class MenuDashboardPage extends StatefulWidget {
  final THEME theme;
  final Function(String, THEME) onSwitchChanged;

  const MenuDashboardPage({super.key, required this.theme, required this.onSwitchChanged});


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
  int _selectedIndex = 0;


  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: duration);
    _scaleAnimation = Tween<double>(begin: 1, end: 1).animate(_controller);
    _menuScaleAnimation = Tween<double>(begin: 0.5, end: 1).animate(_controller);
    _slideAnimation = Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0)).animate(_controller);
    _tabController = TabController(length: 3, vsync: this, initialIndex: 2);
    _loadUserData();

    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index;
      });
      print("Selected Index: ${_tabController.index}");
    });

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.black,
        systemNavigationBarIconBrightness: Brightness.light
    ));
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
        // appBar: AppBar(
        //   toolbarHeight: 0,
        // ),
        backgroundColor: Theme.of(context).brightness == Brightness.dark ? HexColor.fromHex(AppConstants.primaryBlack) : HexColor.fromHex(AppConstants.primaryWhite),
        body: Stack(
          clipBehavior: Clip.hardEdge,
          children: <Widget>[
            menu(context),
            dashboard(context),
          ],
        ),
      );
  }

  Widget menu(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.black,
        systemNavigationBarIconBrightness: Brightness.light
    ));
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
                SizedBox(height: 30,),
                Text("menu", style: Theme.of(context).textTheme.headlineLarge,),
                SizedBox(height: 70,),
                _isLoading ? CircularProgressIndicator() : SizedBox(
                  width: 300,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AddDetailsPage())),
                        child: Container(
                          width: 100.0,
                          height: 100.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: user?.imagePath == null || user == null ? null : Border.all(
                              color: Theme.of(context).brightness == Brightness.dark ? HexColor.fromHex(AppConstants.primaryWhite) : HexColor.fromHex(AppConstants.primaryBlack),
                              width: 4.0,
                            ),
                          ),
                          child: ClipOval(
                            child: (user != null && user!.imagePath!.contains('assets/')) || user?.imagePath == null || user == null
                                ? Icon(Symbols.account_circle, size: 100, weight: 300,) : Image.file (
                              File(user!.imagePath ?? ""),
                              width: 100.0,
                              height: 100.0,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text("Hello, ${user?.name ?? "User"}!",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Outfit'
                          ), textAlign: TextAlign.center,),
                      ),
                      SizedBox(height: 15,),
                      OutlinedButton.icon(
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => LoginSignupPage())),
                        icon: const Icon(Icons.add, size: 24, weight: 700,),
                        label: Padding(
                          padding: const EdgeInsets.only(right: 4.0),
                          child: const Text('Login', style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold
                          ),),
                        ),
                        iconAlignment: IconAlignment.start,
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: Theme.of(context).brightness == Brightness.dark ? HexColor.fromHex(AppConstants.primaryWhite) : HexColor.fromHex(AppConstants.primaryBlack),
                            width: 3.0,
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 0.0),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                // GradientDivider(),
                SizedBox(height: 30),
                menuItem(icon: Icons.favorite_border_rounded, size: 28, title: "Liked Videos", onPressed: (){
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
                menuItem(icon: FontAwesomeIcons.list, title: "Categories", size: 23, givePadding: true, onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const CategoriesPage()));
                }),
                SizedBox(height: 20),
                menuItem(icon: Icons.history, title: "Watch History", size: 29, onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => WatchHistoryPage(
                    tabController: _tabController,
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
                menuItem(icon: Icons.bookmark_border_rounded, size: 28, title: "Saved Videos", onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SavedVideosPage(
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
                // GradientDivider(),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      child: menuItem(title: "Settings", givePadding: true, svgIcon: SvgPicture.asset(
                        Assets.iconsSettings,
                        semanticsLabel: 'Settings Logo',
                        height: 24,
                        width: 24,
                        colorFilter: ColorFilter.mode(Theme.of(context).brightness == Brightness.dark ? HexColor.fromHex(AppConstants.primaryWhite) : HexColor.fromHex(AppConstants.primaryBlack), BlendMode.srcIn),
                      ),
                          onPressed: () async {
                            var result = await Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage(
                              theme: widget.theme,
                              onSwitchChanged: widget.onSwitchChanged,
                            )));

                            if (!mounted) return;

                            setState(() {
                              if(result == true){
                                _loadUserData();
                              }
                            });
                          }),
                    ),
                  )),
                // SizedBox(height: 100,)
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
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: HexColor.fromHex(AppConstants.primaryBlack),
                borderRadius: BorderRadius.all(Radius.circular(isCollapsed ? 0 : 40)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha:0.8),
                    blurRadius: Theme.of(context).brightness == Brightness.light ? 35 : 6,
                    offset: Offset(0, 7),
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
            !isCollapsed ? SizedBox(
              width: screenWidth,
              height: screenHeight,
              child: InkWell(
                onTap: () {
                  setState(() {
                    if (isCollapsed) {
                      _controller.forward();
                      videoPlayerController.pause();
                    } else {
                      _controller.reverse();
                    }

                    isCollapsed = !isCollapsed;
                  });
                }
              ),
            ) : Container(),
          ],
        ),
      ),
    );
  }

  Widget menuItem({IconData? icon, required String title, GestureTapCallback? onPressed, SvgPicture? svgIcon, double size = 20, bool givePadding = false}){
    return Container(
      width: 300,
      child: InkWell(
        onTap: (){
          onPressed?.call();
        },

        child: Row(
          children: [
            icon != null
              ? Padding(
                padding: EdgeInsets.only(left: givePadding ? 2.0 : 0.0),
                child: Icon(icon, size: size),
              )
              : Padding(
                padding: EdgeInsets.only(left: givePadding ? 5.0 : 0.0),
                child: svgIcon ?? Container(),
              ),
            SizedBox(width: icon != null ? size <= 20 ? 25 : 15 : 15,),
            SizedBox(
              width: givePadding ? title != "Settings" ? 174: 171 : 171,
              child: Text(title, style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                // color: HexColor.fromHex(AppConstants.primaryWhite)
              )),
            ),

            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark ? HexColor.fromHex(AppConstants.primaryWhite) : HexColor.fromHex(AppConstants.primaryBlack),
                  borderRadius: BorderRadius.circular(100)
                ),
                child: Icon(Icons.navigate_next, color: Theme.of(context).brightness == Brightness.dark ? HexColor.fromHex(AppConstants.primaryBlack) : HexColor.fromHex(AppConstants.primaryWhite),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}