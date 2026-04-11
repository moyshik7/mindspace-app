import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'dart:math';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  final List<String> _streakMessages = [
    "Your Mindspace streak is crying... don't let it die! 🥺",
    "It's been a day! Take a deep breath and keep your streak alive. 💙",
    "We miss you! 5 minutes is all it takes to keep your streak going.",
    "Your mental health journey needs you today! Keep the streak alive! 🌱",
    "Don't let your hard work fade away. Open the app to save your streak! ✨",
    "Even Duo would be sad to see this streak go. 💔 Keep building those mindful days!"
  ];

  Future<void> init() async {
    if (_isInitialized) return;

    tz.initializeTimeZones();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _notificationsPlugin.initialize(settings: initializationSettings);
    _isInitialized = true;
  }

  Future<void> requestPermissions() async {
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  Future<void> scheduleStreakReminder({int hour = 18, int minute = 0}) async {
    // Cancel the existing reminder first
    await _notificationsPlugin.cancel(id: 0);

    // Calculate time: tomorrow at user's chosen time
    final now = DateTime.now();
    // Streak breaks if not visited next day
    final tomorrow = now.add(const Duration(days: 1));
    var scheduledDate = tz.TZDateTime.local(tomorrow.year, tomorrow.month, tomorrow.day, hour, minute);

    // If the time is somehow in the past (e.g., timezone weirdness), don't schedule
    if (scheduledDate.isBefore(tz.TZDateTime.now(tz.local))) {
      return;
    }

    final message = _streakMessages[Random().nextInt(_streakMessages.length)];

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'streak_reminders',
      'Streak Reminders',
      channelDescription: 'Notifications to remind you to keep your streak alive',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _notificationsPlugin.zonedSchedule(
      id: 0,
      title: 'Streak at Risk!',
      body: message,
      scheduledDate: scheduledDate,
      notificationDetails: platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }
}
