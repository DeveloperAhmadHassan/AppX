import 'package:flutter/material.dart';
import 'package:loopyfeed/pages/auth_page/email_page.dart';
import 'package:loopyfeed/pages/auth_page/login_email_page.dart';
import 'package:loopyfeed/pages/auth_page/phone_page.dart';
import 'package:loopyfeed/utils/constants.dart';
import 'package:loopyfeed/utils/extensions/color.dart';

import '../../pages/auth_page/login_page.dart';
import '../../pages/auth_page/signup_page.dart';

class LoginPhoneEmailPage extends StatefulWidget {
  const LoginPhoneEmailPage({super.key});

  @override
  State<LoginPhoneEmailPage> createState() => _LoginPhoneEmailPageState();
}

class _LoginPhoneEmailPageState extends State<LoginPhoneEmailPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }


  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Spacer(),
            Text('Log in', style: TextStyle(
                fontSize: 22
            ) ,textAlign: TextAlign.center,),
            Spacer()
          ],
        ),
        actions: [
          Icon(Icons.info_outline_rounded)
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 15,),
          TabBar(
            controller: _tabController,
            physics: ClampingScrollPhysics(),
            tabAlignment: TabAlignment.fill,
            labelStyle: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: HexColor.fromHex(AppConstants.primaryWhite)
            ),
            unselectedLabelStyle: TextStyle(
              fontSize: 20,
              color: Colors.grey
            ),
            unselectedLabelColor: Colors.grey,
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorPadding: EdgeInsets.symmetric(horizontal: 10),
            indicatorWeight: 3,
            indicator: UnderlineTabIndicator(
              borderRadius: BorderRadius.circular(100),
              borderSide: BorderSide(
                width: 3.0,
                color: Theme.of(context).brightness == Brightness.dark ? HexColor.fromHex(AppConstants.primaryWhite) : HexColor.fromHex(AppConstants.primaryBlack),
              ),
            ),
            tabs: <Widget>[
              Tab(text: "Phone",),
              Tab(text: "Email/ Username",),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: ClampingScrollPhysics(),
              children: [
                PhonePage(),
                LoginEmailPage(),
              ],
            ),
          ),
        ],
      ),
    );
  }


}
