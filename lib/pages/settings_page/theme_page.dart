import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:loopyfeed/utils/assets.dart';
import 'package:loopyfeed/utils/constants.dart';
import 'package:loopyfeed/utils/enums.dart';

import '../../utils/extensions/color.dart';

class ThemePage extends StatefulWidget {
  const ThemePage({super.key});

  @override
  State<ThemePage> createState() => _ThemePageState();
}

class _ThemePageState extends State<ThemePage> {
  THEME? _theme = THEME.light;
  bool isSwitched = false;
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
      ),
      body: Container(
        padding: EdgeInsets.all(13.0),
        height: MediaQuery.of(context).size.height / 2,
        decoration: BoxDecoration(
          color: Colors.grey.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(10)
        ),
        child: Column(
          children: [
            SizedBox(height: 40,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: 200,
                      child: Image.asset(Assets.profileLightIllustration),
                    ),
                    SizedBox(height: 10,),
                    Text("Light", style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600
                    ),),
                    Radio<THEME>(
                      value: THEME.light,
                      groupValue: _theme,
                      onChanged: (THEME? value) {
                        setState(() {
                          _theme = value;
                        });
                      },
                      activeColor: HexColor.fromHex(AppConstants.primaryColor),
                    ),
                  ],
                ),
                SizedBox(width: 50,),
                Column(
                  children: [
                    SizedBox(
                      height: 200,
                      child: Image.asset(Assets.profileDarkIllustration),
                    ),
                    SizedBox(height: 10,),
                    Text("Dark", style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600
                    ),),
                    Radio<THEME>(
                      value: THEME.dark,
                      groupValue: _theme,
                      onChanged: (THEME? value) {
                        setState(() {
                          _theme = value;
                        });
                      },
                      activeColor: HexColor.fromHex(AppConstants.primaryColor),
                    ),
                  ],
                )
              ],
            ),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                children: [
                  Text("Use device settings", style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600
                  ),),
                  Spacer(),
                  FlutterSwitch(
                    height: 30,
                    width: 50,
                    padding: 3,
                    toggleSize: 20,
                    value: isSwitched,
                    onToggle: (val) {
                      setState(() {
                        isSwitched = val;
                      });

                      // widget.onToggle!(val);
                    },
                    activeColor: Colors.transparent,
                    inactiveColor: Colors.transparent,
                    activeSwitchBorder: Border.all(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black, width: 2),
                    toggleColor: HexColor.fromHex(AppConstants.primaryColor),
                    activeToggleColor: HexColor.fromHex(AppConstants.primaryColor),
                    inactiveToggleColor: HexColor.fromHex(AppConstants.primaryWhite),
                    inactiveSwitchBorder: Border.all(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black, width: 2),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, top: 5.0),
              child: Text("Match appearance to your device's Display & Brightness settings", style: TextStyle(
                fontSize: 15,
                color: Colors.grey
              ),),

            )
          ],
        ),
      ),
    );
  }
}
