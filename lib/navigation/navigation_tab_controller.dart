import 'package:flutter/material.dart';

import '../pages/carousel_page/carousel_page.dart';
import '../pages/carousel_page/_components/globals.dart';
import '../pages/home_page/home_page.dart';
import '../pages/discover_page/discover_page.dart';
import '../models/reel.dart';

import 'navigation_tab_bar.dart';

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

class _NavigationTabControllerState extends State<NavigationTabController> {

  @override
  void initState() {
    super.initState();
    widget.tabController.addListener(_handleTabControllerChange);
  }

  @override
  void dispose() {
    widget.tabController.removeListener(_handleTabControllerChange);
    super.dispose();
  }

  void _handleTabControllerChange() {
    if (widget.tabController.indexIsChanging) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    print("tab index: ${widget.tabController.index}");
    return Scaffold(
      body: Stack(
        children: [
          TabBarView(
            controller: widget.tabController,
            physics: widget.tabController.index != 0 ? ClampingScrollPhysics() : NeverScrollableScrollPhysics(),
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
                videoPlayerController.dispose();
                reel.value = Reel("");
              });
            },
          ),
        ],
      ),
    );
  }

}