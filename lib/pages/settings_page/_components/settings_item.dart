import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/settings.dart';
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
              // color: Colors.white,
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
              height: 24,
              width: 40,
              padding: 3,
              toggleSize: 15,
              value: widget.isSwitched,
              onToggle: (val) {
                setState(() {
                  widget.isSwitched = val;
                });

                widget.onToggle!(val);
              },
              activeColor: Colors.transparent,
              inactiveColor: Colors.transparent,
              activeSwitchBorder: Border.all(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black, width: 2),
              toggleColor: HexColor.fromHex("#ADF7E3"),
              activeToggleColor: Colors.blue,
              inactiveToggleColor: HexColor.fromHex("#ADF7E3"),
              inactiveSwitchBorder: Border.all(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black, width: 2),
            ) : Icon(
              Icons.navigate_next,
              color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
              size: 28,
            ),
          ],
        ),
      ),
    );
  }
}
