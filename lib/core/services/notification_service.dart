import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService instance = NotificationService._internal();
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;

    tz.initializeTimeZones();

    const androidSettings =
        AndroidInitializationSettings('@mipmap/launcher_icon');

    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notificationsPlugin.initialize(settings: initSettings);
    _isInitialized = true;
  }

  Future<void> requestPermissions() async {
    final androidImpl = _notificationsPlugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await androidImpl?.requestNotificationsPermission();

    final iosImpl = _notificationsPlugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    await iosImpl?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  /// Lên lịch nhắc nhở hằng ngày lúc 20:00 (hoặc giờ tùy chỉnh)
  Future<void> scheduleDailyReminder({int hour = 20, int minute = 0}) async {
    if (!_isInitialized) await init();

    await _notificationsPlugin.cancel(id: 1001); // Cancel previous reminder

    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    const androidDetails = AndroidNotificationDetails(
      'daily_reminder_channel',
      'Nhắc nhở hàng ngày',
      channelDescription: 'Nhắc nhở ghi chép chi tiêu và chấm công cuối ngày',
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails();

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notificationsPlugin.zonedSchedule(
      id: 1001,
      title: 'Đã đến lúc tổng kết ngày! 📝',
      body: 'Bạn đã chấm công hôm nay và ghi chép chi tiêu chưa? Kiểm tra ngay nhé!',
      scheduledDate: scheduledDate,
      notificationDetails: notificationDetails,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> cancelDailyReminder() async {
    await _notificationsPlugin.cancel(id: 1001);
  }

  /// Thông báo ngay lập tức (Test / Event)
  Future<void> showInstantNotification({
    required String title,
    required String body,
  }) async {
    if (!_isInitialized) await init();

    const androidDetails = AndroidNotificationDetails(
      'instant_notification_channel',
      'Thông báo chung',
      channelDescription: 'Thông báo cập nhật và sự kiện',
      importance: Importance.high,
      priority: Priority.high,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    await _notificationsPlugin.show(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: title,
      body: body,
      notificationDetails: notificationDetails,
    );
  }
}
