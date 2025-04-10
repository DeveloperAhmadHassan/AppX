import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loopyfeed/pages/auth_page/password_page.dart';
import 'package:loopyfeed/utils/extensions/string.dart';
import 'dart:math' as math;

import '../../pages/auth_page/select_country_page.dart';

import '../../utils/constants.dart';
import '../../utils/extensions/color.dart';
import 'otp_page.dart';

class LoginEmailPage extends StatefulWidget {
  const LoginEmailPage({super.key});

  @override
  State<LoginEmailPage> createState() => _LoginEmailPageState();
}

class _LoginEmailPageState extends State<LoginEmailPage> {
  bool _isDisabled = true;
  bool _emailError = false;
  String _emailErrorHelper = "Error Occurred";
  final _formEmailKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 13.0, vertical: 60.0),
        child: Form(
          key: _formEmailKey,
          child: Column(
            children: [
              TextFormField(
                cursorColor: HexColor.fromHex(AppConstants.primaryColor),
                controller: _emailController,
                style: TextStyle(color: HexColor.fromHex(AppConstants.primaryWhite)),
                keyboardType: TextInputType.emailAddress,
                inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
                onChanged: (String value) {
                  setState(() {
                    if (_emailController.text.isNotEmpty) {
                      _isDisabled = false;
                    } else {
                      _isDisabled = true;
                    }
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    setState(() {
                      _emailError = true;
                      _emailErrorHelper = "Enter your login info";
                    });
                    return "";
                  }
                  if (!value.isValidEmail) {
                    setState(() {
                      _emailError = true;
                      _emailErrorHelper = "Enter a valid email address";
                    });
                    return "";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 16),
                  hintText: "Enter email address",
                  hintStyle: TextStyle(color: Colors.white70),
                  fillColor: Theme.of(context).brightness == Brightness.light ? HexColor.fromHex(AppConstants.primaryBlack) : HexColor.fromHex(AppConstants.graySwatch1),
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
                    borderSide: _emailError ? BorderSide(color: Colors.red, width: 2) : BorderSide.none,
                  ),
                ),
              ),
              _emailError ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 13.0, vertical: 5),
                child: Row(
                  children: [
                    Icon(Icons.warning, color: Colors.red, size: 18,),
                    SizedBox(width: 7,),
                    Text(_emailErrorHelper, style: TextStyle(
                        color: Colors.red,
                        fontSize: 14,
                        fontWeight: FontWeight.bold
                    ),)
                  ],
                ),
              ) : Container(),
            ]
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            print("clicking");
            if (_formEmailKey.currentState!.validate()) {
              Navigator.push(context, MaterialPageRoute(builder: (context) => PasswordPage(email: _emailController.text.toString(),)));
            } else {
              setState(() {
                _emailError = true;
                _emailErrorHelper = "Error Occurred";
              });
            }
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(vertical: 13.0, horizontal: 11.0),
            decoration: BoxDecoration(
              color: _isDisabled ? Color.alphaBlend(
                Colors.grey.withValues(alpha: 0.6),
                HexColor.fromHex(AppConstants.primaryColor),
              ) : HexColor.fromHex(AppConstants.primaryColor),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Text(
              "Continue",
              style: TextStyle(color: HexColor.fromHex(AppConstants.primaryBlack), fontWeight: FontWeight.bold, fontSize: 22),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
