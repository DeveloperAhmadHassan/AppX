import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: Colors.white,
      sliderTheme: SliderThemeData(

      ),
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
              fontSize: 13
          ),
          labelSmall: TextStyle(
              color: Colors.blueGrey,
              fontSize: 15
          ),
          bodyMedium: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w400,
            // letterSpacing: 2.0,
          ),
          labelMedium: TextStyle(
              color: Colors.white
          )
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
            iconColor: Colors.black,
            foregroundColor: Colors.black
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        prefixIconColor: Colors.black,
        suffixIconColor: Colors.black.withValues(alpha: 0.5),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        hintStyle: TextStyle(
          color: Colors.black.withValues(alpha: 0.6),
        ),
        labelStyle: TextStyle(
          color: Colors.black,
        ),
      ),
      dropdownMenuTheme: DropdownMenuThemeData(
          inputDecorationTheme: InputDecorationTheme(
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
            hintStyle: TextStyle(
              color: Colors.black.withValues(alpha: 0.6),
            ),
            labelStyle: TextStyle(
              color: Colors.black,
            ),
            prefixIconColor: Colors.black,
            suffixIconColor: Colors.black.withValues(alpha: 0.5),

          )
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(Colors.black),
          foregroundColor: WidgetStateProperty.all(Colors.white),
            padding: WidgetStateProperty.all(EdgeInsets.symmetric(horizontal: 13.0))
        ),
      ),
      fontFamily: 'Poppins',
    );
  }

  static ThemeData darkTheme() {
    return ThemeData(
      useMaterial3: true,
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
              fontSize: 13
          ),
          labelSmall: TextStyle(
              color: Colors.blueGrey,
              fontSize: 15
          ),
          bodyMedium: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w400,
            // letterSpacing: 2.0,
          ),
          labelMedium: TextStyle(
              color: Colors.white
          )
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
            side: BorderSide(color: Colors.white, width: 3.0,),
            iconColor: Colors.white,
            foregroundColor: Colors.white
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        prefixIconColor: Colors.white,
        suffixIconColor: Colors.white.withValues(alpha: 0.5),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        hintStyle: TextStyle(
          color: Colors.white.withValues(alpha: 0.6),
        ),
        labelStyle: TextStyle(
          color: Colors.white,
        ),
      ),
      dropdownMenuTheme: DropdownMenuThemeData(
          inputDecorationTheme: InputDecorationTheme(
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            hintStyle: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
            ),
            labelStyle: TextStyle(
              color: Colors.white,
            ),
            prefixIconColor: Colors.white,
            suffixIconColor: Colors.white.withValues(alpha: 0.5),
          )
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(Colors.white),
          foregroundColor: WidgetStateProperty.all(Colors.black),
          padding: WidgetStateProperty.all(EdgeInsets.symmetric(horizontal: 13.0))
        ),
      ),
      fontFamily: 'Poppins',
    );
  }
}
