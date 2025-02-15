import 'package:flutter/material.dart';
import 'package:heroapp/navigation/side_menu_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Poppins', ),
      home: const MenuDashboardPage(),
      // debugShowCheckedModeBanner: false,
    );
  }
}
