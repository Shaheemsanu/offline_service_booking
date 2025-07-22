import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:offline_service_booking/app/app.dart';
import 'package:offline_service_booking/main.dart';
import 'package:offline_service_booking/src/domain/core/model/booking_model.dart';
import 'package:offline_service_booking/src/domain/core/model/provider_model.dart';
import 'package:offline_service_booking/src/infrastructure/core/database_service.dart';
import 'package:offline_service_booking/src/presentation/view/booking_list_screen/booking_list_screen.dart';
import 'package:timezone/data/latest_all.dart';
import 'package:timezone/timezone.dart' as tz;

class LocalNotificationService {
  /// Create a [AndroidNotificationChannel] for heads up notifications
  // static const AndroidNotificationChannel channel = AndroidNotificationChannel(
  //   'high_importance_channel', // id
  //   'High Importance Notifications', // title
  //   description:
  //       'This channel is used for important notifications.', // description
  //   importance: Importance.high,
  //   sound: RawResourceAndroidNotificationSound("notify"),
  //   playSound: true,
  // );

  // /// Initialize the [FlutterLocalNotificationsPlugin] package.
  // final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  //     FlutterLocalNotificationsPlugin();

  // Future<void> scheduleLocalNotification({
  //   required String title,
  //   required String body,
  //   required DateTime scheduledTime,
  // }) async {
  //   final tz.TZDateTime scheduledDateTime = tz.TZDateTime.from(
  //     scheduledTime,
  //     tz.local,
  //   );

  //   await flutterLocalNotificationsPlugin.zonedSchedule(
  //     scheduledDateTime.hashCode, // unique ID per notification
  //     title,
  //     body,
  //     scheduledDateTime,
  //     NotificationDetails(
  //       // use named parameters for both platforms
  //       android: AndroidNotificationDetails(
  //         'booking_channel',
  //         'Booking Reminders',
  //         channelDescription: 'Reminders for upcoming bookings',
  //         importance: Importance.high,
  //         priority: Priority.high,
  //       ),
  //       iOS: DarwinNotificationDetails(),
  //     ),
  //     androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
  //     payload: 'booking_notification',
  //     matchDateTimeComponents: null, // null for single fire
  //   );
  // }
  //   void addLocalNotification(BookingModel booking) {
  //   print(
  //     "====================Adding local notification for booking: ${booking.id}===================",
  //   );
  //   final dateTime = DateTime.parse('${booking.date} ${booking.time}');
  //   final notifyTime = dateTime.subtract(Duration(seconds: 10));
  //   print("Notification scheduled for: ${notifyTime.toLocal()}");
  //   FcmService().scheduleLocalNotification(
  //     title: 'Upcoming Booking',
  //     scheduledTime: notifyTime,
  //     body:
  //         'You have a booking ${widget.provider.name} scheduled at ${booking.date} ${booking.time}.',
  //   );
  // }

  Future<void> init() async {
    initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Kolkata'));
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const DarwinInitializationSettings iOSSettings =
        DarwinInitializationSettings();
    const InitializationSettings initializationSettings =
        InitializationSettings(android: androidSettings, iOS: iOSSettings);
    // await notificationsPlugin.initialize(initializationSettings);
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse resp) {
        final payload = resp.payload;
        if (payload != null) {
          _handleNotificationTap(payload);
        }
      },

      onDidReceiveBackgroundNotificationResponse:
          backgroundNotificationTap, // optional for background
    );
  }

  Future<void> scheduleRemainder({
    required BookingModel booking,
    required ProviderModel providerModel,
    required String title,
    required String body,
    required DateTime dateTime,
  }) async {
    print('--555555--------scheduleRemainder--$providerModel');
    final payload = jsonEncode({
      'provider_model': providerModel.toMap(),
      'body': body,
    });

    final notifyTime = dateTime.add(Duration(seconds: 15));
    print('----------Scheduling notification with payload: $payload');
    // tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime.from(notifyTime, tz.local);
    // now.subtract(const Duration(seconds: 5));
    await flutterLocalNotificationsPlugin.zonedSchedule(
      payload: payload,
      int.parse(booking.id), // unique ID per notification
      title,
      body,
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'scheduled_channel',
          'Scheduled Notifications',
          channelDescription: 'Channel for scheduled notifications',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dayOfMonthAndTime,
    );
    print('----------Notification scheduled for $scheduledDate');
  }

  void _handleNotificationTap(String payload) {
    final data = jsonDecode(payload);
    final pModelMap = data['provider_model'] as Map<String, dynamic>;
    final body = data['body'] as String;
    print(
      '--------------------Notification tapped with id: ${ProviderModel.fromMap(pModelMap)}, body: $body',
    );
    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (context) =>
            BookingListScreen(provider: ProviderModel.fromMap(pModelMap)),
      ),
    );
  }
}

// For background/terminated states
@pragma('vm:entry-point')
Future<void> backgroundNotificationTap(NotificationResponse resp) async {
  final payload = resp.payload;
  if (payload != null) {
    print(
      '--------------------Background notification tapped with payload: $payload',
    );

    final data = jsonDecode(payload);
    final pModelMap = data['provider_model'] as Map<String, dynamic>;
    final body = data['body'] as String;
    await DatabaseServices().initDB();
    print("---------provider_model $pModelMap -------body $body----");
    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (context) =>
            BookingListScreen(provider: ProviderModel.fromMap(pModelMap)),
      ),
    );
  }
}
