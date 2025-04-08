import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loopyfeed/utils/constants.dart';

import '../../utils/extensions/color.dart';

class OtpPage extends StatefulWidget {
  final String phoneNumber;

  const OtpPage({super.key, required this.phoneNumber});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final List<TextEditingController> _controllers =
  List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());

  String getOtpCode() {
    return _controllers.map((c) => c.text).join();
  }

  void _onSubmit() {
    String otp = getOtpCode();
    if (otp.length == 6) {
      print("Entered OTP: $otp");
      // Proceed with verification logic here
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter all 6 digits")),
      );
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focus in _focusNodes) {
      focus.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: 34),
          onPressed: () => Navigator.pop(context, true),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Enter 6-digit code", style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold
            )),
            SizedBox(height: 6),
            Text("Your Code was sent to +92 ${widget.phoneNumber}", style: TextStyle(
              color: Colors.white54,
              fontSize: 16
            )),
            SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(6, (index) {
                return SizedBox(
                  width: 52,
                  child: TextField(
                    cursorColor: HexColor.fromHex(AppConstants.primaryColor),
                    controller: _controllers[index],
                    focusNode: _focusNodes[index],
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 22),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 2),
                      fillColor: HexColor.fromHex("#595555"),
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        if (index < 5) {
                          _focusNodes[index + 1].requestFocus();
                        } else {
                          _focusNodes[index].unfocus();
                        }
                      } else if (value.isEmpty && index > 0) {
                        _focusNodes[index - 1].requestFocus();
                      }
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                );
              }),
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: (){},
              child: Text("Resend Code", style: TextStyle(
                  color: HexColor.fromHex(AppConstants.primaryColor)
              ),),
            ),
            SizedBox(height: 40),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TextStyle(color: HexColor.fromHex(AppConstants.primaryWhite), fontSize: 16, fontWeight: FontWeight.w600),
                children: [
                  TextSpan(text: 'Didn\'t get a code? '),
                  TextSpan(
                    text: "Request a phone call",
                    style: TextStyle(
                        color: HexColor.fromHex(AppConstants.primaryColor),
                        fontSize: 16
                    ),
                  )
                ]
              ),
            ),
          ],
        ),
      ),
    );
  }
}
