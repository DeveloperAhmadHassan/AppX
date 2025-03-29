import 'package:flutter/material.dart';

import 'navigation_tab_bar.dart';
import '../pages/carousel_page/carousel_page.dart';
import '../pages/carousel_page/_components/globals.dart';
import '../pages/home_page/home_page.dart';
import '../pages/discover_page/discover_page.dart';
import '../models/reel.dart';

class NavigationTabController extends StatefulWidget {
  final Function() onSideMenuClick;
  final Function(Reel?) handleReelSelected;
  final bool isCollapsed;
  final TabController tabController;
  final Reel? selectedReel;
  const NavigationTabController({super.key, required this.onSideMenuClick, this.isCollapsed = true, required this.tabController, this.selectedReel, required this.handleReelSelected});

  @override
  State<NavigationTabController> createState() => _NavigationTabControllerState();
}

class _NavigationTabControllerState extends State<NavigationTabController> with TickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          TabBarView(
            controller:  widget.tabController,
            // physics: const NeverScrollableScrollPhysics(),
            children: [
              CarouselPage(
                tabController: widget.tabController,
                onReelSelected: widget.handleReelSelected,
              ),
              HomePage(reel: widget.selectedReel),
              DiscoverPage(
                tabController: widget.tabController,
                onReelSelected: widget.handleReelSelected,
              ),
            ],
          ),
          NavigationTabBar(
            onSideMenuClick: widget.onSideMenuClick,
            isCollapsed: widget.isCollapsed,
            tabController: widget.tabController,
            onTabTapped: () {
              setState(() {
                widget.handleReelSelected(null);
                // videoFuture.value = play(widget.reel.reelUrl);
                // print("Tab Changed");
                videoPlayerController.dispose();
                reel.value = Reel("");
              });
            }),
        ],
      ),
    );
  }
}