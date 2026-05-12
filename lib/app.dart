import 'package:flutter/material.dart';
import 'screens/dashboard_screen.dart';
import 'screens/settings_screen.dart';
import 'services/connectivity_service.dart';
import 'services/notification_service.dart';

class HermesHQApp extends StatefulWidget {
  const HermesHQApp({super.key});

  @override
  State<HermesHQApp> createState() => _HermesHQAppState();
}

class _HermesHQAppState extends State<HermesHQApp>
    with WidgetsBindingObserver {
  final ConnectivityService _connectivity = ConnectivityService();
  final NotificationService _notifications = NotificationService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _connectivity.startMonitoring();
    _connectivity.statusStream.listen(_onStatusChange);
  }

  void _onStatusChange(ServerStatus status) {
    if (status == ServerStatus.offline) {
      _notifications.showServerDown();
    } else if (status == ServerStatus.online) {
      _notifications.showServerBack();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _connectivity.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _connectivity.pauseMonitoring();
    } else if (state == AppLifecycleState.resumed) {
      _connectivity.resumeMonitoring();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HermesHQ',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5B4FCF),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        fontFamily: '.AppleSystemUIFont',
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5B4FCF),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      home: const DashboardScreen(),
      routes: {
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}
