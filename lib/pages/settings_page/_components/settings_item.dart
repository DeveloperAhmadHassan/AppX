import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/settings.dart';
import '../../../utils/constants.dart';
import '../../../utils/extensions/color.dart';

class SettingsItem extends StatefulWidget {
  final IconData? icon;
  final String title;
  bool isSwitch;
  bool isSwitched;
  bool morePadding;
  final iconSize;
  Function? onTap;
  final Function(bool)? onToggle;
  SettingsItem({
    super.key,
    this.icon,
    required this.title,
    this.isSwitched = false,
    this.isSwitch = false,
    this.onTap,
    this.onToggle,
    this.morePadding = true,
    this.iconSize = 22.0
  });

  @override
  State<SettingsItem> createState() => _SettingsItemState();
}

class _SettingsItemState extends State<SettingsItem> {
  Future<void> saveSettingsToLocal(Settings settings) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String settingsJson = jsonEncode(settings.toJson());
    await prefs.setString('settings', settingsJson);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onTap?.call();
      },
      child: Padding(
        padding: EdgeInsets.only(top: 13.0, left: widget.morePadding ? 10.0 : 10.0, right: 20.0, bottom: 5.0),
        child: Row(
          children: [
            widget.icon != null
                ? Icon(
              widget.icon,
              size: widget.iconSize,
              // color: HexColor.fromHex(AppConstants.primaryWhite),
            )
                : Container(),
            SizedBox(
              width: 20,
            ),
            Text(
              widget.title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
            ),
            Spacer(),
            widget.isSwitch ? FlutterSwitch(
              height: 30,
              width: 50,
              padding: 3,
              toggleSize: 20,
              value: widget.isSwitched,
              onToggle: (val) {
                setState(() {
                  widget.isSwitched = val;
                });

                widget.onToggle!(val);
              },
              activeColor: HexColor.fromHex(AppConstants.primaryBlack),
              inactiveColor: HexColor.fromHex(AppConstants.graySwatch1),
              activeSwitchBorder: Border.all(color: HexColor.fromHex(AppConstants.primaryBlack), width: 2),
              toggleColor: HexColor.fromHex(AppConstants.primaryColor),
              activeToggleColor: HexColor.fromHex(AppConstants.primaryColor),
              inactiveToggleColor: HexColor.fromHex(AppConstants.primaryWhite),
              inactiveSwitchBorder: Border.all(color: HexColor.fromHex(AppConstants.graySwatch1), width: 2),
            ) : Icon(
              Icons.navigate_next,
              color: Theme.of(context).brightness == Brightness.dark ? HexColor.fromHex(AppConstants.primaryWhite) : HexColor.fromHex(AppConstants.primaryBlack),
              size: 28,
            ),
          ],
        ),
      ),
    );
  }
}
