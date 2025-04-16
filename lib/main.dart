import 'package:country_codes/country_codes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:loopyfeed/repository/secure_storage_repository.dart';
import 'package:loopyfeed/repository/settings_repository.dart';
import 'package:loopyfeed/repository/usage_repository.dart';
import 'package:loopyfeed/services/notification_service.dart';
import 'package:loopyfeed/utils/enums.dart';

import 'firebase_options.dart';
import 'models/daily_usage.dart';
import 'navigation/side_menu_controller.dart';
import 'repository/reel_repository.dart';
import 'utils/app_theme.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  print("Handling a background message: ${message.messageId}");
}

void main() async{
  WidgetsBinding _ = WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  print('User granted permission: ${settings.authorizationStatus}');

  String? token = await messaging.getToken();
  print("FCM Token: $token");



  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();

  NotificationService().initNotification();

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Received a message in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');

      // Show local notification using flutter_local_notifications
      flutterLocalNotificationsPlugin.show(
        0,
        message.notification?.title,
        message.notification?.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'channel_id',
            'channel_name',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
      );
    }
  });

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.black,
      systemNavigationBarColor: Colors.black,
      systemNavigationBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.light
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
  late final userId;
  DateTime? _startTime;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _startTime = DateTime.now();
    _incrementAppOpenCount();
    _loadTheme();
    _initUserId();
  }

  @override
  void dispose() {
    _saveScreenTime();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _initUserId() async {
    userId = await SecureStorageRepository.getOrCreateUserId();
    print("Secure user_id: $userId");
  }

  void _loadTheme() async {
    final savedTheme = await SettingsRepository.getTheme();
    if (savedTheme != null) {
      setState(() {
        _theme = savedTheme;
      });
    }
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

