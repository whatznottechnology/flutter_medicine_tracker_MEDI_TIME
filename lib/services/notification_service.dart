import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:permission_handler/permission_handler.dart';
import '../models/medicine.dart';
import '../models/intake_log.dart';
import 'database_service.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationDetails _androidNotificationDetails =
      AndroidNotificationDetails(
    'medicine_reminder',
    'Medicine Reminders',
    channelDescription: 'Notifications for medicine reminders',
    importance: Importance.high,
    priority: Priority.high,
    showWhen: true,
    enableVibration: true,
    playSound: true,
  );

  static const DarwinNotificationDetails _iosNotificationDetails =
      DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );

  static const NotificationDetails _notificationDetails = NotificationDetails(
    android: _androidNotificationDetails,
    iOS: _iosNotificationDetails,
  );

  static Future<void> initialize() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosInitializationSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    await _notifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    await _requestPermissions();
  }

  static Future<void> _requestPermissions() async {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }

  static void _onNotificationTapped(NotificationResponse response) {
    final payload = response.payload;
    if (payload != null) {
      final parts = payload.split('|');
      if (parts.length >= 3) {
        final action = parts[0];
        final medicineId = parts[1];
        final logId = parts[2];

        switch (action) {
          case 'taken':
            _markMedicineTaken(medicineId, logId);
            break;
          case 'snooze':
            _snoozeMedicine(medicineId, logId);
            break;
          case 'skip':
            _skipMedicine(medicineId, logId);
            break;
        }
      }
    }
  }

  static Future<void> _markMedicineTaken(String medicineId, String logId) async {
    final log = DatabaseService.getIntakeLog(logId);
    if (log != null) {
      final updatedLog = log.copyWith(
        status: IntakeStatus.taken,
        actualAt: DateTime.now(),
      );
      await DatabaseService.updateIntakeLog(updatedLog);
    }
  }

  static Future<void> _snoozeMedicine(String medicineId, String logId) async {
    final settings = DatabaseService.getSettings();
    final medicine = DatabaseService.getMedicine(medicineId);
    final log = DatabaseService.getIntakeLog(logId);
    
    if (medicine != null && log != null) {
      // Update current log as snoozed
      final updatedLog = log.copyWith(
        status: IntakeStatus.snoozed,
        actualAt: DateTime.now(),
      );
      await DatabaseService.updateIntakeLog(updatedLog);

      // Schedule new reminder after snooze duration
      final snoozeTime = DateTime.now().add(Duration(minutes: settings.snoozeDuration));
      await scheduleMedicineReminder(
        medicine,
        snoozeTime,
        isSnooze: true,
      );
    }
  }

  static Future<void> _skipMedicine(String medicineId, String logId) async {
    final log = DatabaseService.getIntakeLog(logId);
    if (log != null) {
      final updatedLog = log.copyWith(
        status: IntakeStatus.missed,
        actualAt: DateTime.now(),
      );
      await DatabaseService.updateIntakeLog(updatedLog);
    }
  }

  static Future<void> scheduleMedicineReminder(
    Medicine medicine,
    DateTime scheduledTime, {
    bool isSnooze = false,
  }) async {
    final settings = DatabaseService.getSettings();
    if (!settings.notificationsEnabled) return;

    // Create intake log
    final logId = '${medicine.id}_${scheduledTime.millisecondsSinceEpoch}';
    final intakeLog = IntakeLog(
      id: logId,
      medicineId: medicine.id,
      scheduledAt: scheduledTime,
      status: IntakeStatus.scheduled,
      createdAt: DateTime.now(),
    );
    await DatabaseService.addIntakeLog(intakeLog);

    final notificationId = scheduledTime.millisecondsSinceEpoch ~/ 1000;
    
    String title = isSnooze 
        ? 'Medicine Reminder (Snoozed)' 
        : 'Time for your medicine!';
    
    String body = '${medicine.name} - ${medicine.dose}';
    if (medicine.relationToFood != FoodRelation.independent) {
      // Manual translation since we don't have context here
      String relationText;
      switch (medicine.relationToFood) {
        case FoodRelation.beforeMeal:
          relationText = 'Before Meal';
          break;
        case FoodRelation.afterMeal:
          relationText = 'After Meal';
          break;
        case FoodRelation.withMeal:
          relationText = 'With Meal';
          break;
        case FoodRelation.independent:
          relationText = 'Independent';
          break;
      }
      body += ' ($relationText)';
    }

    final payload = 'reminder|${medicine.id}|$logId';

    try {
      // Use simple scheduling without androidScheduleMode for compatibility
      if (scheduledTime.isAfter(DateTime.now())) {
        await _notifications.show(
          notificationId,
          title,
          body,
          _notificationDetails,
          payload: payload,
        );
      }
    } catch (e) {
      print('Error scheduling notification: $e');
    }
  }

  static Future<void> scheduleAllMedicineReminders(Medicine medicine) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    for (final timeString in medicine.scheduleTimes) {
      final timeParts = timeString.split(':');
      final hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);

      // Schedule for today if time hasn't passed, otherwise tomorrow
      var scheduledDateTime = DateTime(today.year, today.month, today.day, hour, minute);
      if (scheduledDateTime.isBefore(now)) {
        scheduledDateTime = scheduledDateTime.add(const Duration(days: 1));
      }

      await scheduleMedicineReminder(medicine, scheduledDateTime);

      // Schedule for the next 30 days
      for (int i = 1; i <= 30; i++) {
        final futureDate = scheduledDateTime.add(Duration(days: i));
        await scheduleMedicineReminder(medicine, futureDate);
      }
    }
  }

  static Future<void> cancelMedicineReminders(String medicineId) async {
    // Get all pending notifications
    final pendingNotifications = await _notifications.pendingNotificationRequests();
    
    // Cancel notifications for this medicine
    for (final notification in pendingNotifications) {
      if (notification.payload?.contains('|$medicineId|') == true) {
        await _notifications.cancel(notification.id);
      }
    }

    // Update intake logs to cancelled status
    final logs = DatabaseService.getIntakeLogsByMedicine(medicineId);
    for (final log in logs) {
      if (log.status == IntakeStatus.scheduled && log.scheduledAt.isAfter(DateTime.now())) {
        await DatabaseService.deleteIntakeLog(log.id);
      }
    }
  }

  static Future<void> scheduleWaterReminder() async {
    final settings = DatabaseService.getSettings();
    if (!settings.waterRemindersEnabled || !settings.notificationsEnabled) {
      return;
    }

    // For simplicity, show a simple notification every few hours
    await _notifications.show(
      999999, // Unique ID for water reminders
      'Time to drink water! 💧',
      'Stay hydrated! Drink a glass of water.',
      _notificationDetails,
      payload: 'water_reminder',
    );
  }

  static Future<void> cancelWaterReminders() async {
    await _notifications.cancel(999999);
  }

  static Future<void> showInstantNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    await _notifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      _notificationDetails,
      payload: payload,
    );
  }

  // Stock Alert Methods
  static Future<void> showLowStockAlert(Medicine medicine) async {
    final settings = DatabaseService.getSettings();
    if (!settings.notificationsEnabled || !medicine.lowStockAlertsEnabled) return;

    await showInstantNotification(
      title: 'Low Stock Alert ⚠️',
      body: '${medicine.name} is running low. Current stock: ${medicine.stockDisplayText}',
      payload: 'low_stock|${medicine.id}',
    );
  }

  static Future<void> showOutOfStockAlert(Medicine medicine) async {
    final settings = DatabaseService.getSettings();
    if (!settings.notificationsEnabled || !medicine.lowStockAlertsEnabled) return;

    await showInstantNotification(
      title: 'Out of Stock 🚨',
      body: '${medicine.name} is out of stock. Please refill your medicine.',
      payload: 'out_of_stock|${medicine.id}',
    );
  }

  static Future<void> checkAndNotifyLowStock() async {
    final lowStockMedicines = DatabaseService.getLowStockMedicines();
    final outOfStockMedicines = DatabaseService.getOutOfStockMedicines();

    for (final medicine in outOfStockMedicines) {
      await showOutOfStockAlert(medicine);
    }

    for (final medicine in lowStockMedicines) {
      if (!medicine.isOutOfStock) {
        await showLowStockAlert(medicine);
      }
    }
  }

  static Future<void> showMedicineAlerts(Medicine medicine) async {
    if (!medicine.alertsEnabled) return;

    if (medicine.isOutOfStock) {
      await showOutOfStockAlert(medicine);
    } else if (medicine.isLowStock) {
      await showLowStockAlert(medicine);
    }
  }

  static Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  static Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _notifications.pendingNotificationRequests();
  }
}