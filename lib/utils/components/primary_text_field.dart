// import 'package:flutter/material.dart';
//
// import '../constants.dart';
// import '../extensions/color.dart';
//
// class PrimaryTextField extends StatefulWidget {
//   const PrimaryTextField({super.key});
//
//   @override
//   State<PrimaryTextField> createState() => _PrimaryTextFieldState();
// }
//
// class _PrimaryTextFieldState extends State<PrimaryTextField> {
//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       cursorColor: HexColor.fromHex(AppConstants.primaryColor),
//       controller: _phoneController,
//       style: TextStyle(color: HexColor.fromHex(AppConstants.primaryWhite)),
//       keyboardType: TextInputType.number,
//       inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//       validator: (value) {
//         if (value == null || value.isEmpty) {
//           setState(() {
//             _phoneError = true;
//             _phoneErrorHelper = "Enter your login info";
//           });
//           return null;
//         }
//         return null;
//       },
//       decoration: InputDecoration(
//         contentPadding: EdgeInsets.symmetric(horizontal: 2),
//         hintText: "Phone number",
//         hintStyle: TextStyle(color: Colors.white70),
//         fillColor: HexColor.fromHex("#595555"),
//         filled: true,
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(100),
//           borderSide: BorderSide.none,
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(100),
//           borderSide: BorderSide.none,
//         ),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(100),
//           borderSide: BorderSide.none,
//         ),
//       ),
//     );
//   }
// }
