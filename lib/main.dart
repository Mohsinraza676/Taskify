import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'utils/app_theme.dart';
import 'screens/splash_screen.dart';
import 'services/notification_service.dart';

// Background message handler for FCM
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Notification Service
  final notificationService = NotificationService();
  await notificationService.init();

  try {
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    
    final messaging = FirebaseMessaging.instance;
    await messaging.requestPermission(alert: true, badge: true, sound: true);

    String? token = await messaging.getToken();
    debugPrint("--- FCM TOKEN ---");
    debugPrint(token);
    debugPrint("-----------------");

    // Schedule a Daily Reminder at 9:00 AM
    await notificationService.scheduleDailyNotification(
      id: 0,
      title: "Good Morning! ☀️",
      body: "Time to check your Taskify list and plan your day.",
      hour: 9,
      minute: 0,
    );

  } catch (e) {
    debugPrint('Initialization error: $e');
  }

  runApp(
    const ProviderScope(
      child: TaskifyApp(),
    ),
  );
}

class TaskifyApp extends StatefulWidget {
  const TaskifyApp({super.key});

  @override
  State<TaskifyApp> createState() => _TaskifyAppState();
}

class _TaskifyAppState extends State<TaskifyApp> {
  final GlobalKey<ScaffoldMessengerState> _messengerKey = GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    _setupInteractions();
  }

  void _setupInteractions() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        _showInAppNotification(
          message.notification!.title ?? "Notification",
          message.notification!.body ?? "",
        );
      }
    });
  }

  void _showInAppNotification(String title, String body) {
    _messengerKey.currentState?.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: AppTheme.primaryColor,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(body, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: _messengerKey,
      title: 'Taskify',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}
