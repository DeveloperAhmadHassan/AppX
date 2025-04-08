import 'package:flutter/material.dart';
import 'package:loopyfeed/utils/extensions/color.dart';

import '../utils/constants.dart';

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
  void initState() {
    super.initState();

    widget.tabController.addListener(() {
      if (widget.tabController.indexIsChanging) {
        print("tab index: ${widget.tabController.index}");
      }
    });
  }

  @override
  void dispose() {
    widget.tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 40,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: IconButton(
                onPressed: widget.onSideMenuClick,
                icon: widget.isCollapsed
                    ? Icon(Icons.menu, size: 30)
                    : Icon(Icons.arrow_back, size: 30),
              ),
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(right: 40.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: HexColor.fromHex(AppConstants.primaryWhite).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Container(
                              color: HexColor.fromHex(AppConstants.primaryWhite).withValues(alpha: 0.2),
                            ),
                          ),
                          TabBar(
                            controller: widget.tabController,
                            tabAlignment: TabAlignment.center,
                            padding: EdgeInsets.only(left: 15),
                            physics: widget.tabController.index != 0 ? ClampingScrollPhysics() : NeverScrollableScrollPhysics(),
                            onTap: (index) async {
                              await widget.onTabTapped();
                            },
                            labelPadding: EdgeInsets.only(right: 15),
                            unselectedLabelStyle: TextStyle(
                                fontSize: 18,
                                fontFamily: 'Outfit'
                            ),
                            labelStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                fontFamily: 'Outfit'
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
            ),
            Container()
          ],
        ),
      ),
    );
  }
}
