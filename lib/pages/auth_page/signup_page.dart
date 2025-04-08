import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:math' as math;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loopyfeed/pages/auth_page/email_page.dart';
import 'package:loopyfeed/pages/auth_page/otp_page.dart';

import '../../pages/settings_page/privacy_policy_page.dart';
import '../../pages/settings_page/terms_of_use_page.dart';
import '../../utils/assets.dart';
import '../../utils/components/full_logo.dart';
import '../../utils/helper_functions.dart';
import '../../utils/constants.dart';
import '../../utils/extensions/color.dart';

class SignupPage extends StatefulWidget {
  final TabController tabController;
  const SignupPage({super.key, required this.tabController});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool _isChecked = false;
  bool _phoneError = false;
  String _phoneErrorHelper = "Error Occurred";
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
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
              SizedBox(height: 10,),
              FullLogo(size: 80,),
              SizedBox(height: 10,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Sign up", style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                      color: Theme.of(context).brightness == Brightness.dark ? HexColor.fromHex("#F8FFE0").withValues(alpha: 3.0) : HexColor.fromHex(AppConstants.primaryBlack).withValues(alpha: 3.0)
                  )),
                  // SizedBox(width: 7,),
                  // Container(
                  //   padding: EdgeInsets.only(top: 4.0),
                  //   width: 100,
                  //   child: Image.asset(AppConstants.iconsSecondaryLogo, fit: BoxFit.contain,),
                  // )
                ],
              ),
              SizedBox(height: 15,),
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width - 10,
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 13.0),
                        decoration: BoxDecoration(
                          color: HexColor.fromHex("#595555"),
                          borderRadius: BorderRadius.circular(100),
                          border: _phoneError ? Border.all(color: Colors.red, width: 2) : null,
                        ),
                        child: Form(
                          key: _formKey,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 13.0),
                            decoration: BoxDecoration(
                              color: HexColor.fromHex("#595555"),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Row(
                              children: [
                                Text("PK +92", style: TextStyle(color: HexColor.fromHex(AppConstants.primaryWhite))),
                                SizedBox(width: 8),
                                Transform.rotate(
                                  angle: math.pi / 2,
                                  child: Icon(Icons.chevron_right, color: HexColor.fromHex(AppConstants.primaryWhite)),
                                ),
                                SizedBox(width: 8),
                                Container(
                                  width: 1,
                                  height: 20,
                                  color: Colors.white30,
                                ),
                                SizedBox(width: 8),
                                Flexible(
                                  child: TextFormField(
                                    cursorColor: HexColor.fromHex(AppConstants.primaryColor),
                                    controller: _phoneController,
                                    style: TextStyle(color: HexColor.fromHex(AppConstants.primaryWhite)),
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        setState(() {
                                          _phoneError = true;
                                          _phoneErrorHelper = "Enter your login info";
                                        });
                                        return null;
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(horizontal: 2),
                                      hintText: "Phone number",
                                      hintStyle: TextStyle(color: Colors.white70),
                                      fillColor: HexColor.fromHex("#595555"),
                                      filled: true,
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(100),
                                        borderSide: BorderSide.none,
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(100),
                                        borderSide: BorderSide.none,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(100),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      _phoneError ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 13.0, vertical: 5),
                        child: Row(
                          children: [
                            Icon(Icons.warning, color: Colors.red, size: 18,),
                            SizedBox(width: 7,),
                            Text(_phoneErrorHelper, style: TextStyle(
                              color: Colors.red,
                              fontSize: 14,
                              fontWeight: FontWeight.bold
                            ),)
                          ],
                        ),
                      ) : Container(),
                      Row(
                        children: [
                          Checkbox(
                            checkColor: HexColor.fromHex(AppConstants.primaryBlack),
                            fillColor: WidgetStateProperty.all(HexColor.fromHex(AppConstants.primaryColor)),
                            value: _isChecked,
                            shape: CircleBorder(),
                            onChanged: (bool? value) {
                              setState(() {
                                _isChecked = value!;
                              });
                            },
                          ),
                          // SizedBox(width: 20,),
                          Text("Save login info to log in automatically next time.", style: TextStyle(
                            fontSize: 13,
                            color: Theme.of(context).brightness == Brightness.dark ? HexColor.fromHex(AppConstants.primaryWhite).withValues(alpha: 0.8) : HexColor.fromHex(AppConstants.primaryBlack).withValues(alpha: 0.8)
                          ),),
                        ],
                      ),
                      SizedBox(height: 15,),
                      InkWell(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => OtpPage(phoneNumber: _phoneController.text.toString(),)));
                          } else {
                          }
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(vertical: 13.0, horizontal: 13.0),
                          decoration: BoxDecoration(
                            color: HexColor.fromHex("#E1FF8B"),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Text(
                            "Continue",
                            style: TextStyle(color: HexColor.fromHex(AppConstants.primaryBlack), fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15.0),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white54 : Colors.black54, fontSize: 14, fontWeight: FontWeight.w600),
                            children: [
                              TextSpan(text: 'Your number may be used to connect you with others, improve ads and more, depending on your settings. '),
                              TextSpan(
                                text: "Learn More",
                                style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ?  HexColor.fromHex(AppConstants.primaryWhite) : HexColor.fromHex(AppConstants.primaryBlack)),
                                // recognizer: TapGestureRecognizer()
                                //   ..onTap = () {
                                //     Navigator.push(
                                //       context,
                                //       MaterialPageRoute(builder: (_) => const TermsOfUsePage()),
                                //     );
                                //   },
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 5,),
                      Row(
                          children: <Widget>[
                            Expanded(
                                child: Divider()
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 22.0),
                              child: Text("or"),
                            ),
                            Expanded(
                                child: Divider()
                            ),
                          ]
                      ),
                      SizedBox(height: 20,),
                      loginOption(Assets.iconsPerson, "Continue With Email", iconSize: 22, onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => EmailPage()));
                      }),
                      SizedBox(height: 20,),
                      loginOption(Assets.iconsGoogle, "Continue With Google"),
                      SizedBox(height: 20,),
                      loginOption(Assets.iconsFacebook, "Continue With Facebook"),
                      // SizedBox(height: 20,),
                      // loginOption(FontAwesomeIcons.instagram, "Continue With Instagram"),
                      // SizedBox(height: 20,),
                      // loginOption(FontAwesomeIcons.xTwitter, "Continue With X"),
                      // SizedBox(height: 20,),
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
                  const TextSpan(text: 'Already have an account? '),
                  TextSpan(
                    text: 'Login',
                    style: TextStyle(color: HexColor.fromHex(AppConstants.primaryColor)),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        widget.tabController.animateTo(0);
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

  Widget loginOption(String icon, String title,  {double iconSize = 27, double titleSize = 20, GestureTapCallback? onTap}) {
    return InkWell(
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
                semanticsLabel: 'Google Logo',
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
