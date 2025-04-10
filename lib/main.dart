// import 'package:cloudinary_flutter/cloudinary_context.dart';
// import 'package:cloudinary_url_gen/cloudinary.dart';
import 'package:country_codes/country_codes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:loopyfeed/utils/enums.dart';

import 'navigation/side_menu_controller.dart';
import 'repository/reel_repository.dart';
import 'utils/app_theme.dart';

void main() async{
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // CloudinaryContext.cloudinary = Cloudinary.fromCloudName(cloudName: 'dqudeifns');
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.purple,
      systemNavigationBarColor: Colors.purple,
    ),
  );
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp,DeviceOrientation.portraitDown]);
  await CountryCodes.init();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}


class _MyAppState extends State<MyApp> {
  THEME _theme = THEME.dark;

  void onSwitchChanged(String title, THEME value) {
    setState(() {
      _theme = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.black,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.black,
      systemNavigationBarIconBrightness: Brightness.light
    ));
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp,DeviceOrientation.portraitDown]);

    final reelRepository = ReelRepository();

    return MaterialApp(
      themeMode: switch(_theme) {
        THEME.light => ThemeMode.light,
        THEME.dark => ThemeMode.dark,
        THEME.system => ThemeMode.system,
      },
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      home: MenuDashboardPage(
        theme: _theme,
        onSwitchChanged: onSwitchChanged,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
