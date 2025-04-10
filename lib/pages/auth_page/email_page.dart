import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loopyfeed/pages/auth_page/password_page.dart';
import 'package:loopyfeed/utils/extensions/string.dart';

import '../../utils/constants.dart';
import '../../utils/extensions/color.dart';
import 'otp_page.dart';

class EmailPage extends StatefulWidget {
  const EmailPage({super.key});

  @override
  State<EmailPage> createState() => _EmailPageState();
}

class _EmailPageState extends State<EmailPage> {
  bool _isDisabled = true;
  bool _isChecked = false;
  bool _emailError = false;
  String _emailErrorHelper = "Error Occurred";
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: 34),
          onPressed: () => Navigator.pop(context, true),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Enter email address", style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold
              )),
              SizedBox(height: 32),
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
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
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
                  // errorBorder: OutlineInputBorder(
                  //   borderRadius: BorderRadius.circular(100),
                  //   borderSide: BorderSide(color: Colors.red, width: 2),
                  // ),
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15.0),
                child: RichText(
                  textAlign: TextAlign.left,
                  text: TextSpan(
                    style: TextStyle(color: HexColor.fromHex(AppConstants.graySwatch1), fontSize: 14, fontWeight: FontWeight.w600),
                    children: [
                      TextSpan(text: 'Your number may be used to connect you with others, improve ads and more, depending on your settings. '),
                      TextSpan(
                        text: "Learn More",
                        style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? HexColor.fromHex(AppConstants.primaryWhite) : HexColor.fromHex(AppConstants.primaryBlack)),
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
              Spacer(),
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
                    Navigator.push(context, MaterialPageRoute(builder: (context) => PasswordPage(email: _emailController.text.toString(),)));
                  } else {
                  }
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 13.0, horizontal: 13.0),
                  decoration: BoxDecoration(
                    color: _isDisabled ? HexColor.fromHex(AppConstants.primaryColor).withValues(alpha: 0.3) : HexColor.fromHex(AppConstants.primaryColor),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    "Continue",
                    style: TextStyle(color: HexColor.fromHex(AppConstants.primaryBlack), fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
