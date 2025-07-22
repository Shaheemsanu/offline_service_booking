import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:offline_service_booking/app/app.dart';
import 'package:offline_service_booking/src/infrastructure/core/fcm_service/local_notification_service.dart';
import 'package:offline_service_booking/app/injector/injector.dart';
import 'package:permission_handler/permission_handler.dart';

//recive message in app in background solution
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  debugPrint('Handling a background message ${message.messageId}');
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> requestNotificationPermission() async {
  // Android 13+
  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }

  // iOS-specific
  final bool? result = await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin
      >()
      ?.requestPermissions(alert: true, badge: true, sound: true);
  debugPrint("result---$result");
}

Future<void> main() async {
  debugPrint(' Main function started');
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  // await Firebase.initializeApp();
  await LocalNotificationService().init();
  // await FcmService().initialize();

  // tz.initializeTimeZones();
  // // final localTimeZone = await FlutterNativeTimezone.getLocalTimezone();
  // tz.setLocalLocation(tz.getLocation("Asia/Kolkata"));

  // const android = AndroidInitializationSettings('@mipmap/ic_launcher');
  // const ios = DarwinInitializationSettings();
  // const initSettings = InitializationSettings(android: android, iOS: ios);
  // await flutterLocalNotificationsPlugin.initialize(initSettings);

  runApp(const MyApp());
}
