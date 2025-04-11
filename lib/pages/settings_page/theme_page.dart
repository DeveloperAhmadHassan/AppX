import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loopyfeed/utils/assets.dart';
import 'package:loopyfeed/utils/constants.dart';
import 'package:loopyfeed/utils/enums.dart';

import '../../utils/extensions/color.dart';

class ThemePage extends StatefulWidget {
  final Function(THEME) onToggle;
  final THEME theme;
  const ThemePage({super.key, required this.onToggle, required this.theme});

  @override
  State<ThemePage> createState() => _ThemePageState();
}

class _ThemePageState extends State<ThemePage> {
  THEME? _theme = THEME.dark;
  THEME? _themeRadioStatus = THEME.dark;
  bool isSwitched = false;
  late FToast fToast;

  @override
  void initState() {
    super.initState();
    _theme = widget.theme;
    _themeRadioStatus = widget.theme;

    if(_theme == THEME.system) {
      isSwitched = true;
      _themeRadioStatus = THEME.dark;
      // _theme = THEME.dark;
    }

    fToast = FToast();
    fToast.init(context);
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15.0, bottom: 0.0),
            child: Text(
              "appearance",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          Center(
            child: Container(
              padding: EdgeInsets.all(13.0),
              margin: EdgeInsets.all(13.0),
              // height: MediaQuery.of(context).size.height / 2,
              constraints: BoxConstraints(

              ),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.withValues(alpha: 0.2) : Colors.black26,
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
                            groupValue: _themeRadioStatus,
                            onChanged: (THEME? value) {
                              print("Theme: $_theme");
                              print(isSwitched);
                              if(!isSwitched) {
                                setState(() {
                                  _theme = value;
                                  _themeRadioStatus = value;
                                });
                                if(value != null) {
                                  widget.onToggle(value);
                                }
                              } else {
                                setState(() {
                                  _themeRadioStatus = value;
                                });
                                fToast.removeCustomToast();
                                fToast.showToast(
                                  gravity: ToastGravity.BOTTOM,
                                  toastDuration: Duration(seconds: 3),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: Theme.of(context).brightness == Brightness.dark ? 5.0 : 10.0),
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).brightness == Brightness.dark ? HexColor.fromHex(AppConstants.primaryColor) : HexColor.fromHex(AppConstants.primaryBlack),
                                        borderRadius: BorderRadius.circular(100)
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: Theme.of(context).brightness == Brightness.dark ? Image.asset(Assets.iconsPrimaryLogoLight) : Image.asset(Assets.iconsPrimaryLogo),
                                        ),
                                        SizedBox(width: 5,),
                                        Text(
                                          "Turn Off Device Settings to switch theme!",
                                          style: TextStyle(
                                              color: Theme.of(context).brightness == Brightness.dark ? HexColor.fromHex(AppConstants.primaryBlack) : HexColor.fromHex(AppConstants.primaryColor),
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold
                                          ),
                                        ),
                                        SizedBox(width: Theme.of(context).brightness == Brightness.dark ? 5 : 0,),
                                      ],
                                    ),
                                  ),
                                );
                              }
                            },
                            activeColor: HexColor.fromHex(AppConstants.primaryBlack),
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
                            groupValue: _themeRadioStatus,
                            onChanged: (THEME? value) {
                              print("Theme: $_theme");
                              print(isSwitched);
                              if(!isSwitched) {
                                setState(() {
                                  _theme = value;
                                  _themeRadioStatus = value;
                                });
                                if(value != null) {
                                  widget.onToggle(value);
                                }
                              } else {
                                setState(() {
                                  _themeRadioStatus = value;
                                });
                                fToast.removeCustomToast();
                                fToast.showToast(
                                  gravity: ToastGravity.BOTTOM,
                                  toastDuration: Duration(seconds: 3),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: Theme.of(context).brightness == Brightness.dark ? 5.0 : 10.0),
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).brightness == Brightness.dark ? HexColor.fromHex(AppConstants.primaryColor) : HexColor.fromHex(AppConstants.primaryBlack),
                                        borderRadius: BorderRadius.circular(100)
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: Theme.of(context).brightness == Brightness.dark ? Image.asset(Assets.iconsPrimaryLogoLight) : Image.asset(Assets.iconsPrimaryLogo),
                                        ),
                                        SizedBox(width: 5,),
                                        Text(
                                          "Turn Off Device Settings to switch theme!",
                                          style: TextStyle(
                                              color: Theme.of(context).brightness == Brightness.dark ? HexColor.fromHex(AppConstants.primaryBlack) : HexColor.fromHex(AppConstants.primaryColor),
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold
                                          ),
                                        ),
                                        SizedBox(width: Theme.of(context).brightness == Brightness.dark ? 5 : 0,),
                                      ],
                                    ),
                                  ),
                                );
                              }
                            },
                            activeColor: Theme.of(context).brightness == Brightness.dark ? HexColor.fromHex(AppConstants.primaryColor) : HexColor.fromHex(AppConstants.primaryBlack),
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
                              _theme = val ? THEME.system : _themeRadioStatus;
                            });
                            widget.onToggle(val ? THEME.system : _theme != null ? _theme! : THEME.dark);
                          },
                          activeColor: HexColor.fromHex(AppConstants.primaryBlack),
                          inactiveColor: HexColor.fromHex(AppConstants.graySwatch1),
                          activeSwitchBorder: Border.all(color: HexColor.fromHex(AppConstants.primaryBlack), width: 2),
                          toggleColor: HexColor.fromHex(AppConstants.primaryColor),
                          activeToggleColor: HexColor.fromHex(AppConstants.primaryColor),
                          inactiveToggleColor: HexColor.fromHex(AppConstants.primaryWhite),
                          inactiveSwitchBorder: Border.all(color: HexColor.fromHex(AppConstants.graySwatch1), width: 2),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, top: 5.0),
                    child: Text("Match appearance to your device's Display & Brightness settings", style: TextStyle(
                      fontSize: 15,
                      color: Theme.of(context).brightness == Brightness.dark ? Colors.grey : Colors.black54
                    ),),

                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
