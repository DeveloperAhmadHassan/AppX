import 'package:cloudinary_flutter/cloudinary_context.dart';
import 'package:cloudinary_url_gen/cloudinary.dart';
import 'package:country_codes/country_codes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'navigation/side_menu_controller.dart';
import 'repository/reel_repository.dart';
import 'utils/app_theme.dart';

void main() async{
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // CloudinaryContext.cloudinary = Cloudinary.fromCloudName(cloudName: 'dqudeifns');
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
  bool isDarkMode = true;

  void onSwitchChanged(String title, bool value) {
    setState(() {
      isDarkMode = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp,DeviceOrientation.portraitDown]);

    final reelRepository = ReelRepository();

    return MaterialApp(
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      home: MenuDashboardPage(
        isDarkMode: isDarkMode,
        onSwitchChanged: onSwitchChanged,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
