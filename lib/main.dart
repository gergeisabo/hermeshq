import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:window_manager/window_manager.dart';
import 'app.dart';
import 'services/storage_service.dart';
import 'services/connectivity_service.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await StorageService.init();
  await NotificationService.init();

  if (await _isMacOS()) {
    await _setupMacOSWindow();
  }

  // Lock orientation to portrait on mobile
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  runApp(const HermesHQApp());
}

Future<bool> _isMacOS() async {
  try {
    return await windowManager.isPlatformSupported();
  } catch (_) {
    return false;
  }
}

Future<void> _setupMacOSWindow() async {
  await windowManager.ensureInitialized();

  const windowOptions = WindowOptions(
    size: Size(1280, 800),
    minimumSize: Size(900, 600),
    center: true,
    title: 'HermesHQ',
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
  );

  await windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
}
