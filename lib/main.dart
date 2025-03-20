import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'navigation/side_menu_controller.dart';
import 'repository/reel_repository.dart';
import 'utils/app_theme.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
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
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
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
