import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationHelper {
  final FlutterLocalNotificationsPlugin _notifications =
  FlutterLocalNotificationsPlugin();

  Future<bool> initializeNotifications(BuildContext context) async {
    tz.initializeTimeZones();
    const androidInitialize = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInitialize = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const initializationSettings = InitializationSettings(
      android: androidInitialize,
      iOS: iosInitialize,
    );

    // Initialize notifications
    await _notifications.initialize(initializationSettings);

    // Request notification permission for Android 13+
    final androidPlugin = _notifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin != null) {
      final granted = await androidPlugin.requestNotificationsPermission();
      if (granted != true) {
        if (context.mounted) {
          await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Notification Permission Required'),
              content: const Text(
                'This app needs notification permissions to send alarm reminders. Please enable them in settings.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    await openAppSettings();
                    Navigator.pop(context);
                  },
                  child: const Text('Open Settings'),
                ),
              ],
            ),
          );
        }
        return false;
      }
    }

    // Request exact alarm permission
    await requestExactAlarmPermission(context);

    return true;
  }

  Future<void> requestExactAlarmPermission(BuildContext context) async {
    final status = await Permission.scheduleExactAlarm.status;
    if (status.isRestricted || status.isDenied) {
      if (context.mounted) {
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Exact Alarm Permission Required'),
            content: const Text(
              'This app needs permission to schedule exact alarms. Please enable it in settings.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  await openAppSettings();
                  Navigator.pop(context);
                },
                child: const Text('Open Settings'),
              ),
            ],
          ),
        );
      }
    }
  }

  Future<void> scheduleNotification(DateTime dateTime, int id) async {
    final androidDetails = AndroidNotificationDetails(
      'alarm_notif',
      'Alarm Notifications',
      channelDescription: 'Notifications for scheduled alarms',
      importance: Importance.max,
      priority: Priority.high,
    );
    final notificationDetails = NotificationDetails(android: androidDetails);

    await _notifications.zonedSchedule(
      id,
      'Sunset Alarm',
      'It\'s time to unwind 🌅',
      tz.TZDateTime.from(dateTime, tz.local),
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }
}