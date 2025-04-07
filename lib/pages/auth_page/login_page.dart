import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../pages/settings_page/privacy_policy_page.dart';
import '../../pages/settings_page/terms_of_use_page.dart';
import '../../utils/assets.dart';
import '../../utils/components/full_logo.dart';
import '../../utils/helper_functions.dart';
import '../../utils/constants.dart';
import '../../utils/extensions/color.dart';

class LoginPage extends StatelessWidget {
  final TabController tabController;
  const LoginPage({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 0,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Column(
          children: [
            SizedBox(height: 40,),
            FullLogo(size: 90,),
            SizedBox(height: 50,),
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Log in to", style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: HexColor.fromHex("#F8FFE0").withValues(alpha: 3.0)
                )),
                SizedBox(width: 7,),
                Container(
                  padding: EdgeInsets.only(top: 4.0),
                  width: 100,
                  child: Image.asset(AppConstants.iconsSecondaryLogo, fit: BoxFit.contain,),
                )
              ],
            ),
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width - 10,
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  children: [
                    SizedBox(height: 20,),
                    loginOption(Assets.iconsPerson, "Use phone/email/username", iconSize: 25),
                    SizedBox(height: 20,),
                    loginOption(Assets.iconsGoogle, "Continue With Google"),
                    SizedBox(height: 20,),
                    loginOption(Assets.iconsFacebook, "Continue With Facebook"),
                    SizedBox(height: 20,),
                    loginOption(Assets.iconsInstagram, "Continue With Instagram"),
                    SizedBox(height: 20,),
                    loginOption(Assets.iconsX, "Continue With X"),
                    SizedBox(height: 20,),
                  ],
                ),
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Center(
                child: FutureBuilder<String>(
                  future: getCountryName(),
                  builder: (context, snapshot) {
                    final country = snapshot.data ?? "your country";

                    return RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: const TextStyle(color: Colors.white54, fontSize: 14, fontWeight: FontWeight.w600),
                        children: [
                          TextSpan(text: 'By continuing with an account located in '),
                          TextSpan(
                            text: country,
                            style: const TextStyle(color: Colors.white),
                            // recognizer: TapGestureRecognizer()
                            //   ..onTap = () {
                            //     Navigator.push(
                            //       context,
                            //       MaterialPageRoute(builder: (_) => const TermsOfUsePage()),
                            //     );
                            //   },
                          ),
                          TextSpan(text: ', you agree to '),
                          TextSpan(
                            text: 'Terms of Service',
                            style: const TextStyle(color: Colors.white),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const TermsOfUsePage()),
                                );
                              },
                          ),
                          const TextSpan(text: ' and acknowledge that you have read our '),
                          TextSpan(
                            text: 'Privacy Policy',
                            style: const TextStyle(color: Colors.white),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const PrivacyPolicyPage()),
                                );
                              },
                          ),
                          const TextSpan(text: '.'),
                        ],
                      ),
                    );
                  },
                )
                ,
              ),
            ),
          ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.grey.withValues(alpha: 0.2),
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Center(
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TextStyle(color: HexColor.fromHex(AppConstants.primaryWhite), fontSize: 20, fontWeight: FontWeight.w600),
                children: [
                  const TextSpan(text: 'Don\'t have an account? '),
                  TextSpan(
                    text: 'Sign Up',
                    style: TextStyle(color: HexColor.fromHex(AppConstants.primaryColor)),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        tabController.animateTo(1);
                      },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget loginOption(String icon, String title,  {double iconSize = 27, double titleSize = 18}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 13.0),
      decoration: BoxDecoration(
        color: HexColor.fromHex("#E1FF8B"),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        children: [
        SvgPicture.asset(
            icon,
            semanticsLabel: 'Google Logo',
            height: 27,
            width: 27,
            // colorFilter: ColorFilter.mode(
            //     Theme.of(context).brightness == Brightness.dark
            //         ? Colors.white
            //         : Colors.black,
            //     BlendMode.srcIn
            // ),
          ),
          Expanded(
            child: Center(
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: titleSize,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

}
