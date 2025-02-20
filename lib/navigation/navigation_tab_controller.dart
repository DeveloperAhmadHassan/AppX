import 'package:flutter/material.dart';
import 'package:heroapp/pages/carousal_page/carousal_page.dart';
import 'package:heroapp/pages/home_page/home_page.dart';
import 'package:heroapp/pages/discover_page/discover_page.dart';
import '../models/reel.dart';
import './navigation_tab_bar.dart';

class NavigationTabController extends StatefulWidget {
  final Function() onSideMenuClick;
  final bool isCollapsed;

  NavigationTabController({super.key, required this.onSideMenuClick, this.isCollapsed = true});

  @override
  State<NavigationTabController> createState() => _NavigationTabControllerState();
}

class _NavigationTabControllerState extends State<NavigationTabController> {
  Reel? _selectedReel;

  // Update the selected reel when a new reel is selected
  void _handleReelSelected(Reel reel) {
    print(reel.id);
    setState(() {
      _selectedReel = reel;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            children: [
              CarousalPage(),
              HomePage(reel: _selectedReel),
              DiscoverPage(
                tabController: DefaultTabController.of(context),
                onReelSelected: _handleReelSelected,
              ),
            ],
          ),
          NavigationTabBar(onSideMenuClick: widget.onSideMenuClick, isCollapsed: widget.isCollapsed),
        ],
      ),
    );
  }
}