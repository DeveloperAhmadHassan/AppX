import 'package:flutter/material.dart';
import 'package:heroapp/pages/discover_page/discover_page.dart';

import './navigation_tab_bar.dart';
import '../pages/carousal_page/carousal_page.dart';
import '../pages/home_page/home_page.dart';

class NavigationTabController extends StatelessWidget {
  final Function() onSideMenuClick;
  final bool isCollapsed;
  const NavigationTabController({super.key, required this.onSideMenuClick, this.isCollapsed = true});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 2,
      child: Scaffold(
        body: Stack(
          children: [
            TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              children: [
                CarousalPage(),
                HomePage(),
                DiscoverPage()
              ],
            ),
            NavigationTabBar(onSideMenuClick: onSideMenuClick,isCollapsed: isCollapsed,),
          ],
        ),
      ),
    );
  }
}