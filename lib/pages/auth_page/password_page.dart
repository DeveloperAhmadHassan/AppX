import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loopyfeed/utils/extensions/string.dart';

import '../../utils/constants.dart';
import '../../utils/extensions/color.dart';
import 'otp_page.dart';

class PasswordPage extends StatefulWidget {
  final String email;
  const PasswordPage({super.key, required this.email});

  @override
  State<PasswordPage> createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  bool _isDisabled = true;
  bool _passwordError = false;
  String _passwordErrorHelper = "Error Occurred";
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
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
              Text("Create Password", style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold
              )),
              SizedBox(height: 32),
              TextFormField(
                cursorColor: HexColor.fromHex(AppConstants.primaryColor),
                controller: _passwordController,
                style: TextStyle(color: HexColor.fromHex(AppConstants.primaryWhite)),
                keyboardType: TextInputType.emailAddress,
                inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
                onChanged: (String value) {
                  setState(() {
                    if (_passwordController.text.isNotEmpty) {
                      _isDisabled = false;
                    } else {
                      _isDisabled = true;
                    }
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    setState(() {
                      _passwordError = true;
                      _passwordErrorHelper = "Enter your login info";
                    });
                    return "";
                  }
                  if (!value.isValidEmail) {
                    setState(() {
                      _passwordError = true;
                      _passwordErrorHelper = "Enter a valid email address";
                    });
                    return "";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  hintText: "Enter password",
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
                  // errorBorder: OutlineInputBorder(
                  //   borderRadius: BorderRadius.circular(100),
                  //   borderSide: BorderSide(color: Colors.red, width: 2),
                  // ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                    borderSide: _passwordError ? BorderSide(color: Colors.red, width: 2) : BorderSide.none,
                  ),
                ),
              ),
              _passwordError ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 13.0, vertical: 5),
                child: Row(
                  children: [
                    Icon(Icons.warning, color: Colors.red, size: 18,),
                    SizedBox(width: 7,),
                    Text(_passwordErrorHelper, style: TextStyle(
                        color: Colors.red,
                        fontSize: 14,
                        fontWeight: FontWeight.bold
                    ),)
                  ],
                ),
              ) : Container(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Your password must have at least:", style: Theme.of(context).textTheme.titleLarge,),
                    SizedBox(height: 10,),
                    Row(
                      children: [
                        Icon(Icons.check, color: Colors.white54, size: 18,),
                        SizedBox(width: 8,),
                        Text("8 characters (20 max)", style: TextStyle(
                          color: Colors.white54
                        ),)
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.check, color: Colors.white54, size: 18,),
                        SizedBox(width: 8,),
                        Text("1 letter and 1 number", style: TextStyle(
                            color: Colors.white54
                        ),)
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.check, color: Colors.white54, size: 18,),
                        SizedBox(width: 8,),
                        Text("1 special character (example # ? ! \$ & @)", style: TextStyle(
                            color: Colors.white54
                        ),)
                      ],
                    ),
                  ],
                ),
              ),
              Spacer(),
              SizedBox(height: 15,),
              InkWell(
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => OtpPage(phoneNumber: _passwordController.text.toString(),)));
                  } else {
                  }
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 13.0, horizontal: 13.0),
                  decoration: BoxDecoration(
                    color: _isDisabled ? HexColor.fromHex("#E1FF8B").withValues(alpha: 0.3) : HexColor.fromHex("#E1FF8B"),
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
