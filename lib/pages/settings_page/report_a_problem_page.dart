import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../utils/constants.dart';
import '../../utils/extensions/color.dart';

class ReportAProblemPage extends StatefulWidget {
  const ReportAProblemPage({super.key});

  @override
  _ReportAProblemPageState createState() => _ReportAProblemPageState();
}

class _ReportAProblemPageState extends State<ReportAProblemPage> {
  final TextEditingController _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isSending = false;
  bool _isDisabled = false;

  void _submitReport() async {
    final problemText = _controller.text.trim();

    if (problemText.isEmpty) return;

    setState(() {
      _isSending = true;
    });

    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _isSending = false;
    });

    _controller.clear();
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(content: Text('Problem reported. Thank you!')),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back,size: 34,),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 5.0, bottom: 15.0),
              child: Text(
                "report",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            Form(
              key: _formKey,
              child: TextField(
              controller: _controller,
              maxLines: 5,
              cursorColor: HexColor.fromHex(AppConstants.primaryColor),
              style: TextStyle(color: HexColor.fromHex(AppConstants.primaryWhite)),
              keyboardType: TextInputType.emailAddress,
              inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                hintText: "Describe the Issue",
                hintStyle: TextStyle(color: Colors.white70),
                fillColor: Theme.of(context).brightness == Brightness.light ? HexColor.fromHex(AppConstants.primaryBlack) : HexColor.fromHex(AppConstants.graySwatch1),
                filled: true,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            )
            ),
            SizedBox(height: 16),
            InkWell(
              onTap: () {
                if (_formKey.currentState!.validate()) {
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => PasswordPage(email: _emailController.text.toString(),)));
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
    );
  }
}
