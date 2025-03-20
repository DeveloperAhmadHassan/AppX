import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../utils/constants.dart';
import '../../../utils/extensions/color.dart';

class ProfileTextField extends StatefulWidget {
  final String label;
  final String? hint;
  final IconData prefixIcon;
  final bool isCalendar;
  final bool isDropdown;
  final TextEditingController textEditingController;
  final List<String> options;
  final bool isMultiLine;

  const ProfileTextField({
    super.key,
    required this.label,
    this.hint,
    required this.prefixIcon,
    this.isCalendar = false,
    this.isDropdown = false,
    required this.textEditingController,
    this.options = const [],
    this.isMultiLine = false,
  });

  @override
  State<ProfileTextField> createState() => _ProfileTextFieldState();
}

class _ProfileTextFieldState extends State<ProfileTextField> {
  @override
  Widget build(BuildContext context) {
    if (widget.isDropdown) {
      return DropdownButtonFormField<String>(
        value: widget.textEditingController.text.isEmpty
            ? null
            : widget.textEditingController.text,
        onChanged: (newValue) {
          setState(() {
            widget.textEditingController.text = newValue ?? '';
          });
        },
        decoration: InputDecoration(
          hintText: widget.hint,
          labelText: widget.label,
          prefixIcon: Icon(widget.prefixIcon),
          suffixIcon: Icon(FontAwesomeIcons.penToSquare, size: 12),
        ),
        items: widget.options.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              selectionColor: Colors.black,
              style: TextStyle(color: Colors.black),
            ),
          );
        }).toList(),
        dropdownColor: HexColor.fromHex(AppConstants.primaryColor),
        style: TextTheme().labelMedium,
        icon: Container(),
      );
    }
    return TextField(
      cursorOpacityAnimates: true,
      readOnly: widget.isCalendar,
      controller: widget.textEditingController,
      decoration: InputDecoration(
        hintText: widget.hint,
        labelText: widget.label,
        prefixIcon: Icon(widget.prefixIcon,),
        suffixIcon: Icon(FontAwesomeIcons.penToSquare, size: 12,),
        counterStyle: TextStyle(
          fontSize: 9
        )
      ),

      keyboardType: widget.isCalendar ? TextInputType.datetime : TextInputType.text,
      textInputAction: TextInputAction.done,
      cursorColor: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
      style: TextTheme().bodyMedium,
      maxLines: widget.isMultiLine ? 5 : 1,
      minLines: 1,
      maxLength: widget.isMultiLine ? 50 : null,
      textAlign: TextAlign.left,
      onTap: widget.isCalendar ? () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
          builder: (BuildContext context, Widget? child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                  primary: Colors.blueGrey,
                  onPrimary: Colors.white,
                  onSurface: Colors.black,
                ),
                textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                  ),
                ),
              ),
              child: child!,
            );
          },
        );
        if (pickedDate != null) {
          String formattedDate = "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";

          setState(() {
            widget.textEditingController.text = formattedDate;
          });
        }
      } : null,
    );
  }
}
