import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

import '../../pages/auth_page/select_country_page.dart';

import '../../utils/constants.dart';
import '../../utils/extensions/color.dart';
import 'otp_page.dart';

class PhonePage extends StatefulWidget {
  const PhonePage({super.key});

  @override
  State<PhonePage> createState() => _PhonePageState();
}

class _PhonePageState extends State<PhonePage> {
  bool _phoneError = false;
  String _phoneErrorHelper = "Error Occurred";
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 13.0, vertical: 60.0),
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 13.0),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.light ? HexColor.fromHex(AppConstants.primaryBlack) : HexColor.fromHex(AppConstants.graySwatch1),
                borderRadius: BorderRadius.circular(100),
                border: _phoneError ? Border.all(color: Colors.red, width: 2) : null,
              ),
              child: Form(
                key: _formKey,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 13.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.light ? HexColor.fromHex(AppConstants.primaryBlack) : HexColor.fromHex(AppConstants.graySwatch1),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => SelectCountryPage()));
                        },
                        child: Row(
                            children: [
                              Text("PK +92", style: TextStyle(color: HexColor.fromHex(AppConstants.primaryWhite))),
                              SizedBox(width: 8),
                              Transform.rotate(
                                angle: math.pi / 2,
                                child: Icon(Icons.chevron_right, color: HexColor.fromHex(AppConstants.primaryWhite)),
                              ),
                            ]
                        ),
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
            Spacer(),
          ]
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (_formKey.currentState!.validate()) {
              Navigator.push(context, MaterialPageRoute(builder: (context) => OtpPage(phoneNumber: _phoneController.text.toString(),)));
            } else {
            }
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(vertical: 11.0, horizontal: 13.0),
            decoration: BoxDecoration(
              color: HexColor.fromHex(AppConstants.primaryColor),
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
