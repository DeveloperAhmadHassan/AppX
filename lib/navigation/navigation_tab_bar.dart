import 'dart:ui';

import 'package:flutter/material.dart';

class NavigationTabBar extends StatefulWidget {
  final Function() onSideMenuClick;
  final bool isCollapsed;
  const NavigationTabBar({super.key, required this.onSideMenuClick, this.isCollapsed = true});

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
              padding: const EdgeInsets.only(left: 25.0),
              child: IconButton(
                onPressed: widget.onSideMenuClick,
                // onPressed:(){},
                icon: widget.isCollapsed
                  ? Icon(Icons.menu, size: 30, color: Colors.white,)
                  : Icon(Icons.arrow_back, size: 30, color: Colors.white,)
              ),
            ),
            SizedBox(width: 20,),
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width - 110,
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
                        dividerColor: Colors.transparent,
                        indicatorColor: Colors.white,
                        unselectedLabelColor: Colors.white,
                        unselectedLabelStyle: TextStyle(
                          fontSize: 16
                        ),
                        labelColor: Colors.white,
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16
                        ),
                        tabs: const [
                          Tab(text: 'Carousal'),
                          Tab(text: 'Reels'),
                          Tab(text: 'Discover'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
