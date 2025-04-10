// import 'package:flutter/material.dart';
// import 'package:flutter_animated_icon_button/tap_fill_icon.dart';
// import 'package:flutter_animated_icon_button/tap_particle.dart';
//
// import '../constants.dart';
// import '../extensions/color.dart';

// class SaveButton extends StatefulWidget {
//   const SaveButton({Key? key}) : super(key: key);
//
//   @override
//   _SaveButtonState createState() => _SaveButtonState();
// }
//
// class _SaveButtonState extends State<SaveButton> with SingleTickerProviderStateMixin {
//   late AnimationController controller;
//
//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   void initState() {
//     controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 300),
//       lowerBound: 0.0,
//       upperBound: 1.0,
//     );
//     controller.addListener(() {
//       if (mounted) {
//         setState(() {});
//       }
//     });
//
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return TapParticle(
//       size: 50,
//       particleCount: 5,
//       particleLength: 10,
//       color: HexColor.fromHex(AppConstants.primaryWhite),
//       syncAnimation: controller,
//       duration: const Duration(milliseconds: 300),
//       child: TapFillIcon(
//         animationController: controller,
//         borderIcon: const Icon(
//           Icons.bookmark_border_outlined,
//           color: Colors.grey,
//           size: 50,
//         ),
//         fillIcon: Icon(
//           Icons.bookmark,
//           color: HexColor.fromHex(AppConstants.primaryWhite),
//           size: 50,
//         ),
//       ),
//     );
//   }
// }

