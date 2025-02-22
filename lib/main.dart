import 'package:flutter/material.dart';
import 'package:heroapp/navigation/side_menu_controller.dart';
import 'package:heroapp/repository/reel_repository.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final reelRepository = ReelRepository();
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        tabBarTheme: TabBarTheme(
          dividerColor: Colors.transparent,
          indicatorColor: Colors.black,
          unselectedLabelColor: Colors.black,
          tabAlignment: TabAlignment.center,
          labelPadding: EdgeInsets.only(right: 15),
          unselectedLabelStyle: TextStyle(
            fontSize: 14,
            fontFamily: 'Poppins',
          ),
          labelColor: Colors.black,
          labelStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            fontFamily: 'Poppins',
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.black
        ),
        appBarTheme: AppBarTheme(
          color: Colors.white,
          foregroundColor: Colors.black
        ),
        textTheme: TextTheme(
          titleLarge: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18
          ),
          titleMedium: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16
          ),
          labelSmall: TextStyle(
            color: Colors.blueGrey,
            fontSize: 15
          )
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            iconColor: Colors.black,
            foregroundColor: Colors.black
          ),
        ),
        fontFamily: 'Poppins',
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        tabBarTheme: TabBarTheme(
          dividerColor: Colors.transparent,
          indicatorColor: Colors.white,
          unselectedLabelColor: Colors.white,
          tabAlignment: TabAlignment.center,
          labelPadding: EdgeInsets.only(right: 15),
          unselectedLabelStyle: TextStyle(
            fontSize: 14,
            fontFamily: 'Poppins',
          ),
          labelColor: Colors.white,
          labelStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            fontFamily: 'Poppins',
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        appBarTheme: AppBarTheme(
          color: Colors.black,
          foregroundColor: Colors.white
        ),
        textTheme: TextTheme(
          titleLarge: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18
          ),
          titleMedium: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16
          ),
          labelSmall: TextStyle(
            color: Colors.blueGrey,
            fontSize: 15
          )
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: Colors.white, width: 3.0,),
            iconColor: Colors.white,
            foregroundColor: Colors.white
          ),
        ),
        fontFamily: 'Poppins',
      ),
      home: MenuDashboardPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
