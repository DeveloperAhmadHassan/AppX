import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loopyfeed/utils/enums.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

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
  final dropDownKey = GlobalKey<DropdownSearchState<PopupMode>>();
  @override
  Widget build(BuildContext context) {
    if (widget.isDropdown) {
      // return DropdownMenuTheme(
      //   data: DropdownMenuThemeData(
      //     menuStyle: MenuStyle(
      //       shape: WidgetStateProperty.all(
      //         RoundedRectangleBorder(
      //           borderRadius: BorderRadius.circular(1),
      //         ),
      //       ),
      //       backgroundColor: WidgetStateProperty.all(Colors.red),
      //     ),
      //   ),
      //   child: DropdownButtonFormField<String>(
      //     value: widget.textEditingController.text.isEmpty
      //         ? null
      //         : widget.textEditingController.text,
      //     onChanged: (newValue) {
      //       setState(() {
      //         widget.textEditingController.text = newValue ?? '';
      //       });
      //     },
      //     decoration: InputDecoration(
      //       labelText: widget.textEditingController.text.isEmpty ? widget.label : null,
      //       prefixIcon: Icon(widget.prefixIcon, color: HexColor.fromHex(AppConstants.primaryWhite)),
      //       fillColor: Theme.of(context).brightness == Brightness.dark
      //           ? HexColor.fromHex("#595555")
      //           : HexColor.fromHex(AppConstants.primaryBlack),
      //       filled: true,
      //       suffixIcon: Icon(FontAwesomeIcons.penToSquare, size: 12, color: HexColor.fromHex(AppConstants.primaryWhite)),
      //       contentPadding: EdgeInsets.only(top: 11),
      //       labelStyle: TextStyle(
      //         fontWeight: FontWeight.w400,
      //         color: HexColor.fromHex(AppConstants.primaryWhite),
      //       ),
      //       enabledBorder: OutlineInputBorder(
      //         borderRadius: BorderRadius.circular(100),
      //         borderSide: BorderSide.none,
      //       ),
      //       focusedBorder: OutlineInputBorder(
      //         borderRadius: BorderRadius.circular(100),
      //         borderSide: BorderSide.none,
      //       ),
      //       border: OutlineInputBorder(
      //         borderRadius: BorderRadius.circular(100),
      //         borderSide: BorderSide.none,
      //       ),
      //     ),
      //     items: widget.options.map<DropdownMenuItem<String>>((String value) {
      //       return DropdownMenuItem<String>(
      //         value: value,
      //         child: Text(
      //           value,
      //           style: TextStyle(
      //             color: Theme.of(context).brightness == Brightness.dark
      //                 ? HexColor.fromHex(AppConstants.primaryWhite)
      //                 : HexColor.fromHex(AppConstants.primaryBlack),
      //             fontWeight: FontWeight.w400,
      //             fontSize: 16,
      //           ),
      //         ),
      //       );
      //     }).toList(),
      //     style: TextTheme().bodyMedium,
      //     icon: Container(),
      //   ),
      // );
      return DropdownSearch<GENDER>(
        key: dropDownKey,
        suffixProps: DropdownSuffixProps(
          dropdownButtonProps: DropdownButtonProps(
            iconClosed: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Icon(Symbols.arrow_drop_down),
            ),
            iconOpened: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Icon(Symbols.arrow_drop_up),
            ),
          ),
        ),
        selectedItem: GENDER.male,
        itemAsString: (item) => item.name,
        compareFn: (i1, i2) => i1 == i2,
        items: (filter, infiniteScrollProps) => GENDER.values,
        decoratorProps: DropDownDecoratorProps(
          baseStyle: TextStyle(
            color: Colors.white
          ),
          decoration: InputDecoration(
            fillColor: Theme.of(context).brightness == Brightness.dark
                ? HexColor.fromHex("#595555")
                : HexColor.fromHex(AppConstants.primaryBlack),
            filled: true,

            // labelText: "Gender",
            hintText: "Gender",
            prefixIcon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Icon(widget.prefixIcon, color: HexColor.fromHex(AppConstants.primaryWhite)),
            ),
            suffixIcon: Icon(FontAwesomeIcons.penToSquare, size: 82, color: HexColor.fromHex(AppConstants.primaryWhite)),
            contentPadding: EdgeInsets.symmetric(vertical: 16),
            labelStyle: TextStyle(
              fontWeight: FontWeight.w400,
              color: HexColor.fromHex(AppConstants.primaryWhite),
            ),
            hintStyle: TextStyle(
              fontWeight: FontWeight.w400,
              color: HexColor.fromHex(AppConstants.primaryWhite),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(100),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(100),
              borderSide: BorderSide.none,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(100),
              borderSide: BorderSide.none,
            ),
            suffixIconColor: Colors.white
          ),
        ),
        popupProps: PopupProps.menu(
            fit: FlexFit.loose, constraints: BoxConstraints()),
      );
    }
    return TextField(
      cursorOpacityAnimates: true,
      readOnly: widget.isCalendar,
      controller: widget.textEditingController,
      decoration: InputDecoration(
        hintText: widget.label,
        hintStyle: TextStyle(color: Colors.white70),
        prefixIcon: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Icon(widget.prefixIcon,color: HexColor.fromHex(AppConstants.primaryWhite)),
        ),
        suffixIcon: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Icon(FontAwesomeIcons.penToSquare, size: 12, color: HexColor.fromHex(AppConstants.primaryWhite)),
        ),
        fillColor: Theme.of(context).brightness == Brightness.dark ? HexColor.fromHex("#595555") : HexColor.fromHex(AppConstants.primaryBlack),
        filled: true,
        counterStyle: TextStyle(
          fontSize: 12
        ),
        // contentPadding: EdgeInsets.only(top: 15, right: 20, left: 0),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: BorderSide.none,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: BorderSide.none,
        ),
      ),

      keyboardType: widget.isCalendar ? TextInputType.datetime : TextInputType.text,
      textInputAction: TextInputAction.done,
      cursorColor: Theme.of(context).brightness == Brightness.dark ? HexColor.fromHex(AppConstants.primaryWhite) : HexColor.fromHex(AppConstants.primaryBlack),
      style: TextStyle(
        color: HexColor.fromHex(AppConstants.primaryWhite),
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
          helpText: "Select Your Birth Date",
          builder: (BuildContext context, Widget? child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1)),
              child: Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: ColorScheme.light(
                    primary: Colors.blueGrey,
                    onPrimary: HexColor.fromHex(AppConstants.primaryWhite),
                    onSurface: HexColor.fromHex(AppConstants.primaryBlack),
                  ),
                  textButtonTheme: TextButtonThemeData(
                    style: TextButton.styleFrom(
                      foregroundColor: HexColor.fromHex(AppConstants.primaryBlack),
                    ),
                  ),
                  textTheme: const TextTheme(
                    headlineSmall: TextStyle(fontSize: 25.0),
                  ),
                ),
                child: child!,
              ),
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
