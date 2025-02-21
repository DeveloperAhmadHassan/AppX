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

class _NavigationTabControllerState extends State<NavigationTabController> with TickerProviderStateMixin {
  Reel? _selectedReel;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 3, vsync: this, initialIndex: 1);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleReelSelected(Reel reel) {
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
            controller: _tabController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              CarousalPage(
                tabController: _tabController,
                onReelSelected: _handleReelSelected,
              ),
              HomePage(reel: _selectedReel),
              DiscoverPage(
                tabController: _tabController,
                onReelSelected: _handleReelSelected,
              ),
            ],
          ),
          NavigationTabBar(
            onSideMenuClick: widget.onSideMenuClick,
            isCollapsed: widget.isCollapsed,
            tabController: _tabController,
            onTabTapped: (){
              setState(() {
                _selectedReel = null;
              });
            }),
        ],
      ),
    );
  }
}