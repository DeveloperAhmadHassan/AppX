import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:heroapp/utils/extensions/color.dart';

import '../../../utils/constants.dart';

class SettingsItem extends StatefulWidget {
  final IconData? icon;
  final String title;
  bool isSwitch;
  bool isSwitched;
  Function? onTap;
  SettingsItem({super.key, this.icon, required this.title, this.isSwitched = false, this.isSwitch = false, this.onTap});

  @override
  State<SettingsItem> createState() => _SettingsItemState();
}

class _SettingsItemState extends State<SettingsItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        widget.onTap?.call();
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 13.0, left: 20.0, right: 20.0, bottom: 15.0),
        child: Row(
          children: [
            widget.icon != null ? Icon(widget.icon, color: Colors.white,) : Container(),
            SizedBox(width: 20,),
            Text(widget.title, style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white
            )),
            Spacer(),
            widget.isSwitch ?  FlutterSwitch(
              height: 24,
              width: 40,
              padding: 3,
              toggleSize: 15,
              value: widget.isSwitched,
              onToggle: (val) {
                setState(() {
                  widget.isSwitched = val;
                });
              },
              activeColor: Colors.transparent,
              inactiveColor: Colors.transparent,
              activeSwitchBorder: Border.all(
                color: Colors.white,
                width: 2
              ),
              toggleColor: HexColor.fromHex(AppConstants.primaryColor),
              activeToggleColor: HexColor.fromHex(AppConstants.primaryColor),
              inactiveToggleColor: HexColor.fromHex(AppConstants.primaryColor),
              inactiveSwitchBorder: Border.all(
                color: Colors.white,
                width: 2
              ),
            ) : Icon(Icons.navigate_next, color: Colors.white, size: 28,),
          ],
        ),
      ),
    );
  }
}
