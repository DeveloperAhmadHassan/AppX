import 'dart:ui';

import 'package:flutter/material.dart';

class NavigationTabBar extends StatefulWidget {
  final Function() onSideMenuClick;
  final bool isCollapsed;
  final TabController tabController;
  final Function() onTabTapped;
  const NavigationTabBar({super.key, required this.onSideMenuClick, this.isCollapsed = true, required this.tabController, required this.onTabTapped});

  @override
  State<NavigationTabBar> createState() => _NavigationTabBarState();
}

class _NavigationTabBarState extends State<NavigationTabBar> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 30,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: IconButton(
                onPressed: widget.onSideMenuClick,
                icon: widget.isCollapsed
                  ? Icon(Icons.menu, size: 30)
                  : Icon(Icons.arrow_back, size: 30)
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30.0),
              child: Center(
                child: Container(
                  // width: MediaQuery.of(context).size.width - 160,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                            child: Container(
                              color: Colors.black.withValues(alpha: 0),
                            ),
                          ),
                        ),
                        TabBar(
                          controller: widget.tabController,
                          tabAlignment: TabAlignment.center,
                          padding: EdgeInsets.only(left: 15),
                          onTap: (index){
                            widget.onTabTapped();
                            print("User manually changed to: $index");
                          },
                          // labelPadding: EdgeInsets.only(right: 15),
                          unselectedLabelStyle: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Poppins'
                          ),
                          // labelColor: Colors.white,
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            fontFamily: 'Poppins'
                          ),
                          indicatorPadding: EdgeInsets.only(bottom: 10.0),
                          tabs: const [
                            Tab(text: 'Carousel'),
                            Tab(text: 'Reels'),
                            Tab(text: 'Discover'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
