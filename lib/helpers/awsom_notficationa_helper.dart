import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class AwesomeNotificationHelper {
  static const String alarmChannelKey = 'alarm_channel';

  // Initialize notification settings
  static Future<void> initialize(BuildContext context) async {
    await AwesomeNotifications().initialize(
      null, // null means use default icon from manifest
      [
        NotificationChannel(
          channelKey: alarmChannelKey,
          channelName: 'Alarm Notifications',
          channelDescription: 'Channel for alarm reminders',
          defaultColor: Colors.deepPurple,
          ledColor: Colors.white,
          importance: NotificationImportance.High,
          channelShowBadge: true,
          playSound: true,
          enableVibration: true,
        ),
      ],
      debug: true,
    );

    // Ask permission if not granted
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      isAllowed = await _showPermissionDialog(context);
      if (isAllowed) {
        await AwesomeNotifications().requestPermissionToSendNotifications();
      }
    }
  }

  // Show permission request dialog
  static Future<bool> _showPermissionDialog(BuildContext context) async {
    bool granted = false;
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Permission Required'),
        content: const Text('This app needs notification permission to schedule alarms.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              granted = false;
            },
            child: const Text('Deny'),
          ),
          TextButton(
            onPressed: () {
              granted = true;
              Navigator.of(ctx).pop();
            },
            child: const Text('Allow'),
          ),
        ],
      ),
    );
    return granted;
  }

  // Schedule an alarm notification
  static Future<void> scheduleAlarmNotification({
    required int id,
    required DateTime dateTime,
    String title = 'Alarm ⏰',
    String body = 'Time to wake up!',
    bool repeatDaily = true,
  }) async {
    final scheduledDate = dateTime.isBefore(DateTime.now())
        ? dateTime.add(const Duration(days: 1))
        : dateTime;

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: alarmChannelKey,
        title: title,
        body: body,
        notificationLayout: NotificationLayout.Default,
        wakeUpScreen: true,
        category: NotificationCategory.Alarm,
        fullScreenIntent: true,
        locked: true,
        criticalAlert: true,
      ),
      schedule: NotificationCalendar(
        hour: scheduledDate.hour,
        minute: scheduledDate.minute,
        second: 0,
        millisecond: 0,
        repeats: repeatDaily,
      ),
    );
  }

  // Cancel a scheduled alarm
  static Future<void> cancelAlarm(int id) async {
    await AwesomeNotifications().cancel(id);
  }

  // Cancel all scheduled notifications
  static Future<void> cancelAllAlarms() async {
    await AwesomeNotifications().cancelAll();
  }
}
