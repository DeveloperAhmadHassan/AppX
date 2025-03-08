import 'package:flutter/material.dart';
import 'package:heroapp/pages/carousal_page/carousal_page.dart';
import 'package:heroapp/pages/home_page/home_page.dart';
import 'package:heroapp/pages/discover_page/discover_page.dart';
import '../models/reel.dart';
import '../pages/carousal_page/_components/globals.dart';
import './navigation_tab_bar.dart';

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
            physics: const NeverScrollableScrollPhysics(),
            children: [
              CarousalPage(
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