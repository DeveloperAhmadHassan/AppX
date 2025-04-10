import 'package:flutter/material.dart';

import '../../generated/assets.dart';
import '../constants.dart';
import '../extensions/color.dart';
class NoItemsFound extends StatelessWidget {
  final TabController tabController;
  final Function() onSideMenuClick;
  final String pageTitle;
  final String title;
  const NoItemsFound({super.key, required this.tabController, required this.onSideMenuClick, required this.pageTitle, required this.title});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height - 120,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          pageTitle.isNotEmpty ? Padding(
            padding: const EdgeInsets.only(left: 25.0, bottom: 0.0),
            child: Text(
              pageTitle,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ): Container(),
          Spacer(),
          Center(
            child: SizedBox(
              height: 320,
              width: 320,
              child: Image.asset(Assets.profileLikedVideosIllustration),
            ),
          ),
          Center(
            child: Text(title, style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).brightness == Brightness.dark ? HexColor.fromHex(AppConstants.primaryWhite) : HexColor.fromHex(AppConstants.primaryBlack)
            ),),
          ),
          SizedBox(height: 15,),
          Center(
            child: InkWell(
              onTap: () {
                if(context.mounted){
                  Navigator.pop(context, true);
                }
                onSideMenuClick();
                Future.delayed(const Duration(milliseconds: 200), () {
                  tabController.animateTo(1);
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 10.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(color: Theme.of(context).brightness == Brightness.dark ? HexColor.fromHex(AppConstants.primaryWhite) : HexColor.fromHex(AppConstants.primaryBlack), width: 2)
                ),
                child: Text("Watch Videos", style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).brightness == Brightness.dark ? HexColor.fromHex(AppConstants.primaryWhite) : HexColor.fromHex(AppConstants.primaryBlack),
                ),),
              ),
            ),
          ),
          Spacer(),
          Center(
            child: SizedBox(
              width: 100,
              child: Image.asset(Theme.of(context).brightness == Brightness.dark ? Assets.iconsBranding2 : Assets.iconsBrandingDark),
            ),
          ),
          // SizedBox(height: 20,)
        ],
      ),
    );
  }
}
