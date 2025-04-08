import 'package:flutter/material.dart';

import 'constants.dart';
import 'extensions/color.dart';

class AppTheme {
  static ThemeData lightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: HexColor.fromHex(AppConstants.backgroundLight),
      sliderTheme: SliderThemeData(),
      tabBarTheme: TabBarTheme(
        dividerColor: Colors.transparent,
        indicatorColor: HexColor.fromHex(AppConstants.primaryBlack),
        unselectedLabelColor: HexColor.fromHex(AppConstants.primaryBlack),
        tabAlignment: TabAlignment.center,
        labelPadding: EdgeInsets.only(right: 15),
        unselectedLabelStyle: TextStyle(
          fontSize: 14,
          fontFamily: 'Outfit',
        ),
        labelColor: HexColor.fromHex(AppConstants.primaryBlack),
        labelStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          fontFamily: 'Outfit',
        ),
      ),
      iconTheme: IconThemeData(
          color: HexColor.fromHex(AppConstants.primaryBlack)
      ),
      appBarTheme: AppBarTheme(
          color: HexColor.fromHex(AppConstants.backgroundLight),
          foregroundColor: HexColor.fromHex(AppConstants.primaryBlack)
      ),
      textTheme: TextTheme(
          headlineLarge: TextStyle(
              fontSize: 64,
              fontWeight: FontWeight.w700
          ),
          headlineMedium: TextStyle(
              fontSize: 58,
              fontWeight: FontWeight.w800
          ),
          headlineSmall: TextStyle(
              fontSize: 50,
              fontWeight: FontWeight.w700
          ),
          titleLarge: TextStyle(
              color: HexColor.fromHex(AppConstants.primaryBlack),
              fontWeight: FontWeight.bold,
              fontSize: 18
          ),
          titleMedium: TextStyle(
              color: HexColor.fromHex(AppConstants.primaryBlack),
              fontWeight: FontWeight.bold,
              fontSize: 13
          ),
          labelSmall: TextStyle(
              color: Colors.blueGrey,
              fontSize: 15
          ),
          bodyMedium: TextStyle(
            color: HexColor.fromHex(AppConstants.primaryBlack),
            fontSize: 16,
            fontWeight: FontWeight.w400,
            // letterSpacing: 2.0,
          ),
          labelMedium: TextStyle(
              color: HexColor.fromHex(AppConstants.primaryWhite)
          ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
            iconColor: HexColor.fromHex(AppConstants.primaryBlack),
            foregroundColor: HexColor.fromHex(AppConstants.primaryBlack)
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        prefixIconColor: HexColor.fromHex(AppConstants.primaryBlack),
        suffixIconColor: HexColor.fromHex(AppConstants.primaryBlack).withValues(alpha: 0.5),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: HexColor.fromHex(AppConstants.primaryBlack)),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: HexColor.fromHex(AppConstants.primaryBlack)),
        ),
        hintStyle: TextStyle(
          color: HexColor.fromHex(AppConstants.primaryBlack).withValues(alpha: 0.6),
        ),
        labelStyle: TextStyle(
          color: HexColor.fromHex(AppConstants.primaryBlack),
        ),
      ),
      dropdownMenuTheme: DropdownMenuThemeData(
          inputDecorationTheme: InputDecorationTheme(
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: HexColor.fromHex(AppConstants.primaryBlack)),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: HexColor.fromHex(AppConstants.primaryBlack)),
            ),
            hintStyle: TextStyle(
              color: HexColor.fromHex(AppConstants.primaryBlack).withValues(alpha: 0.6),
            ),
            labelStyle: TextStyle(
              color: HexColor.fromHex(AppConstants.primaryBlack),
            ),
            prefixIconColor: HexColor.fromHex(AppConstants.primaryBlack),
            suffixIconColor: HexColor.fromHex(AppConstants.primaryBlack).withValues(alpha: 0.5),
          )
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(Colors.black),
            foregroundColor: WidgetStateProperty.all(HexColor.fromHex(AppConstants.primaryWhite)),
            padding: WidgetStateProperty.all(EdgeInsets.symmetric(horizontal: 13.0))
        ),
      ),
      fontFamily: 'Outfit',
    );
  }

  static ThemeData darkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Colors.black,
      tabBarTheme: TabBarTheme(
        dividerColor: Colors.transparent,
        indicatorColor: HexColor.fromHex(AppConstants.primaryWhite),
        unselectedLabelColor: HexColor.fromHex(AppConstants.primaryWhite),
        tabAlignment: TabAlignment.center,
        labelPadding: EdgeInsets.only(right: 15),
        unselectedLabelStyle: TextStyle(
          fontSize: 14,
          fontFamily: 'Outfit',
        ),
        labelColor: HexColor.fromHex(AppConstants.primaryWhite),
        labelStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          fontFamily: 'Outfit',
        ),
      ),
      iconTheme: IconThemeData(
          color: HexColor.fromHex(AppConstants.primaryWhite)
      ),
      appBarTheme: AppBarTheme(
          color: Colors.black,
          foregroundColor: HexColor.fromHex(AppConstants.primaryWhite)
      ),
      textTheme: TextTheme(
          headlineLarge: TextStyle(
              fontSize: 64,
              fontWeight: FontWeight.w700
          ),
          headlineMedium: TextStyle(
              fontSize: 58,
              fontWeight: FontWeight.w800
          ),
          headlineSmall: TextStyle(
              fontSize: 50,
              fontWeight: FontWeight.w700
          ),
          titleLarge: TextStyle(
              color: HexColor.fromHex(AppConstants.primaryWhite),
              fontWeight: FontWeight.bold,
              fontSize: 18
          ),
          titleMedium: TextStyle(
              color: HexColor.fromHex(AppConstants.primaryWhite),
              fontWeight: FontWeight.bold,
              fontSize: 13
          ),
          labelSmall: TextStyle(
              color: Colors.blueGrey,
              fontSize: 15
          ),
          bodyMedium: TextStyle(
            color: HexColor.fromHex(AppConstants.primaryWhite),
            fontSize: 16,
            fontWeight: FontWeight.w400,
            // letterSpacing: 2.0,
          ),
          labelMedium: TextStyle(
              color: HexColor.fromHex(AppConstants.primaryWhite)
          )
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
            side: BorderSide(color: HexColor.fromHex(AppConstants.primaryWhite), width: 3.0,),
            iconColor: HexColor.fromHex(AppConstants.primaryWhite),
            foregroundColor: HexColor.fromHex(AppConstants.primaryWhite)
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        prefixIconColor: HexColor.fromHex(AppConstants.primaryWhite),
        suffixIconColor: HexColor.fromHex(AppConstants.primaryWhite).withValues(alpha: 0.5),
        contentPadding: EdgeInsets.symmetric(vertical: 16),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: HexColor.fromHex(AppConstants.primaryWhite)),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: HexColor.fromHex(AppConstants.primaryWhite)),
        ),
        hintStyle: TextStyle(
          color: HexColor.fromHex(AppConstants.primaryWhite).withValues(alpha: 0.6),
        ),
        labelStyle: TextStyle(
          color: HexColor.fromHex(AppConstants.primaryWhite),
        ),
      ),
      // dropdownMenuTheme: DropdownMenuThemeData(
      //     inputDecorationTheme: InputDecorationTheme(
      //       border: UnderlineInputBorder(
      //         borderSide: BorderSide(color: HexColor.fromHex(AppConstants.primaryWhite)),
      //       ),
      //       focusedBorder: UnderlineInputBorder(
      //         borderSide: BorderSide(color: HexColor.fromHex(AppConstants.primaryWhite)),
      //       ),
      //       hintStyle: TextStyle(
      //         color: HexColor.fromHex(AppConstants.primaryWhite).withValues(alpha: 0.6),
      //       ),
      //       labelStyle: TextStyle(
      //         color: HexColor.fromHex(AppConstants.primaryWhite),
      //       ),
      //       prefixIconColor: HexColor.fromHex(AppConstants.primaryWhite),
      //       suffixIconColor: HexColor.fromHex(AppConstants.primaryWhite).withValues(alpha: 0.5),
      //     )
      // ),
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(Colors.black),
          foregroundColor: WidgetStateProperty.all(HexColor.fromHex(AppConstants.primaryWhite)),
          padding: WidgetStateProperty.all(EdgeInsets.symmetric(horizontal: 13.0))
        ),
      ),
      fontFamily: 'Outfit',
    );
  }
}
