// ignore_for_file: dead_code

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          hintText: widget.hint,
          hintStyle: TextStyle(
            color: Colors.white..withValues(alpha: 0.6),
          ),
          labelText: widget.label,
          labelStyle: TextStyle(
            color: Colors.white,
          ),
          prefixIcon: Icon(widget.prefixIcon, color: Colors.white),
          suffixIcon: Icon(FontAwesomeIcons.penToSquare, color: Colors.white.withValues(alpha: 0.5), size: 18,)
        ),
        items: widget.options.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: TextStyle(color: Colors.white),
            ),
          );
        }).toList(),
        dropdownColor: Colors.blueGrey,
        style: TextStyle(color: Colors.white),
        icon: Container(),
      );
    }
    // throw Error();
    // throw Exception("hasSize is undefined");
    return TextField(
      cursorOpacityAnimates: true,
      readOnly: widget.isCalendar,
      controller: widget.textEditingController,
      decoration: InputDecoration(
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        hintText: widget.hint,
        hintStyle: TextStyle(
          color: Colors.white.withValues(alpha: 0.6),
        ),
        labelText: widget.label,
        labelStyle: TextStyle(
          color: Colors.white,
        ),
        prefixIcon: Icon(widget.prefixIcon, color: Colors.white),
        suffixIcon: Icon(FontAwesomeIcons.penToSquare, color: Colors.white.withValues(alpha: 0.5), size: 18,),
      ),
      keyboardType: widget.isCalendar ? TextInputType.datetime : TextInputType.text,
      textInputAction: TextInputAction.done,
      cursorColor: Colors.white,
      style: TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 2.0,
      ),
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
