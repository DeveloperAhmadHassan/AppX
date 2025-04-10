import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loopyfeed/pages/auth_page/login_phone_email_page.dart';

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
      body: SingleChildScrollView(
        child: Column(
            children: [
              SizedBox(height: 40,),
              FullLogo(size: 90,),
              SizedBox(height: 50,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Log in to", style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Theme.of(context).brightness == Brightness.dark ? HexColor.fromHex("#F8FFE0").withValues(alpha: 3.0) : HexColor.fromHex(AppConstants.primaryBlack).withValues(alpha: 3.0)
                  )),
                ],
              ),
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width - 10,
                  padding: EdgeInsets.symmetric(horizontal: 30.0),
                  child: Column(
                    children: [
                      SizedBox(height: 20,),
                      loginOption(Assets.iconsPerson, "Use phone/email/username", iconSize: 22, onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPhoneEmailPage()));
                      }),
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
              // Spacer(),
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
                          style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white54 : Colors.black54, fontSize: 14, fontWeight: FontWeight.w600),
                          children: [
                            TextSpan(text: 'By continuing with an account located in '),
                            TextSpan(
                              text: country,
                              style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ?  HexColor.fromHex(AppConstants.primaryWhite) : HexColor.fromHex(AppConstants.primaryBlack)),
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
                              style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ?  HexColor.fromHex(AppConstants.primaryWhite) : HexColor.fromHex(AppConstants.primaryBlack)),
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
                              style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ?  HexColor.fromHex(AppConstants.primaryWhite) : HexColor.fromHex(AppConstants.primaryBlack)),
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
      ),
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.withValues(alpha: 0.2) : Colors.grey,
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

  Widget loginOption(String icon, String title,  {double iconSize = 27, double titleSize = 18, GestureTapCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 13.0),
        decoration: BoxDecoration(
          color: HexColor.fromHex(AppConstants.primaryColor),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Row(
          children: [
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: SvgPicture.asset(
              icon,
              semanticsLabel: 'Login Logo',
              height: iconSize,
              width: iconSize,
            ),
          ),
            Expanded(
              child: Center(
                child: Text(
                  title,
                  style: TextStyle(
                    color: HexColor.fromHex(AppConstants.primaryBlack),
                    fontWeight: FontWeight.w600,
                    fontSize: titleSize,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
