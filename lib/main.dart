import 'package:country_codes/country_codes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loopyfeed/repository/usage_repository.dart';
import 'package:loopyfeed/utils/enums.dart';

import 'models/daily_usage.dart';
import 'navigation/side_menu_controller.dart';
import 'repository/reel_repository.dart';
import 'utils/app_theme.dart';

void main() async{
  WidgetsBinding _ = WidgetsFlutterBinding.ensureInitialized();
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


class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  THEME _theme = THEME.dark;
  DateTime? _startTime;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _startTime = DateTime.now();
    _incrementAppOpenCount();
  }

  @override
  void dispose() {
    _saveScreenTime();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void onSwitchChanged(String title, THEME value) {
    setState(() {
      _theme = value;
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _startTime = DateTime.now();
    } else if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      _saveScreenTime();
    }
  }

  Future<void> _incrementAppOpenCount() async {
    final today = DateTime.now().toIso8601String().split('T').first;
    final usageMap = await UsageRepository.loadUsageMap();

    final usage = usageMap[today] ?? DailyUsage(date: today);
    usage.appOpenCount += 1;

    usageMap[today] = usage;
    await UsageRepository.saveUsageMap(usageMap);
  }

  Future<void> _saveScreenTime() async {
    if (_startTime == null) return;

    final sessionDuration = DateTime.now().difference(_startTime!);
    final today = DateTime.now().toIso8601String().split('T').first;
    final usageMap = await UsageRepository.loadUsageMap();

    final usage = usageMap[today] ?? DailyUsage(date: today);
    usage.screenTimeSeconds += sessionDuration.inSeconds;

    usageMap[today] = usage;
    await UsageRepository.saveUsageMap(usageMap);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.black,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.black,
      systemNavigationBarIconBrightness: Brightness.light,
    ));
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);

    final _ = ReelRepository();

    return MaterialApp(
      themeMode: switch (_theme) {
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

