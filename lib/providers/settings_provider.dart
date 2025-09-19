import 'package:flutter/foundation.dart';
import '../models/settings.dart';
import '../services/database_service.dart';
import '../services/notification_service.dart';

class SettingsProvider extends ChangeNotifier {
  Settings _settings = Settings.defaultSettings();
  bool _isLoading = false;
  String? _error;

  Settings get settings => _settings;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Convenience getters
  MealTimes get mealTimes => _settings.mealTimes;
  int get waterTarget => _settings.waterTarget;
  int get snoozeDuration => _settings.snoozeDuration;
  bool get notificationsEnabled => _settings.notificationsEnabled;
  bool get waterRemindersEnabled => _settings.waterRemindersEnabled;
  int get waterReminderInterval => _settings.waterReminderInterval;
  bool get soundEnabled => _settings.soundEnabled;
  bool get vibrationEnabled => _settings.vibrationEnabled;
  bool get isOnboardingCompleted => _settings.isOnboardingCompleted;
  String get languageCode => _settings.languageCode;

  SettingsProvider() {
    _loadSettings();
    _listenToChanges();
  }

  void _listenToChanges() {
    DatabaseService.settingsListenable().addListener(_loadSettings);
  }

  Future<void> _loadSettings() async {
    try {
      _settings = DatabaseService.getSettings();
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateMealTimes(MealTimes newMealTimes) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final updatedSettings = _settings.copyWith(mealTimes: newMealTimes);
      await DatabaseService.updateSettings(updatedSettings);
      _settings = updatedSettings;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateWaterTarget(int newTarget) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final updatedSettings = _settings.copyWith(waterTarget: newTarget);
      await DatabaseService.updateSettings(updatedSettings);
      _settings = updatedSettings;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateSnoozeDuration(int newDuration) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final updatedSettings = _settings.copyWith(snoozeDuration: newDuration);
      await DatabaseService.updateSettings(updatedSettings);
      _settings = updatedSettings;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleNotifications(bool enabled) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final updatedSettings = _settings.copyWith(notificationsEnabled: enabled);
      await DatabaseService.updateSettings(updatedSettings);
      _settings = updatedSettings;

      if (!enabled) {
        await NotificationService.cancelAllNotifications();
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleWaterReminders(bool enabled) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final updatedSettings = _settings.copyWith(waterRemindersEnabled: enabled);
      await DatabaseService.updateSettings(updatedSettings);
      _settings = updatedSettings;

      if (enabled && _settings.notificationsEnabled) {
        await NotificationService.scheduleWaterReminder();
      } else {
        await NotificationService.cancelWaterReminders();
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateWaterReminderInterval(int newInterval) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final updatedSettings = _settings.copyWith(waterReminderInterval: newInterval);
      await DatabaseService.updateSettings(updatedSettings);
      _settings = updatedSettings;

      // Reschedule water reminders with new interval
      if (_settings.waterRemindersEnabled && _settings.notificationsEnabled) {
        await NotificationService.cancelWaterReminders();
        await NotificationService.scheduleWaterReminder();
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleSound(bool enabled) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final updatedSettings = _settings.copyWith(soundEnabled: enabled);
      await DatabaseService.updateSettings(updatedSettings);
      _settings = updatedSettings;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleVibration(bool enabled) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final updatedSettings = _settings.copyWith(vibrationEnabled: enabled);
      await DatabaseService.updateSettings(updatedSettings);
      _settings = updatedSettings;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> completeOnboarding() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final updatedSettings = _settings.copyWith(isOnboardingCompleted: true);
      await DatabaseService.updateSettings(updatedSettings);
      _settings = updatedSettings;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> resetSettings() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final defaultSettings = Settings.defaultSettings();
      await DatabaseService.updateSettings(defaultSettings);
      _settings = defaultSettings;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> exportData() async {
    try {
      return await DatabaseService.exportData();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      throw e;
    }
  }

  Future<void> resetAllData() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await NotificationService.cancelAllNotifications();
      await DatabaseService.clearAllData();
      _settings = DatabaseService.getSettings();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateLanguage(String languageCode) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final updatedSettings = Settings(
        mealTimes: _settings.mealTimes,
        waterTarget: _settings.waterTarget,
        snoozeDuration: _settings.snoozeDuration,
        notificationsEnabled: _settings.notificationsEnabled,
        waterRemindersEnabled: _settings.waterRemindersEnabled,
        waterReminderInterval: _settings.waterReminderInterval,
        soundEnabled: _settings.soundEnabled,
        vibrationEnabled: _settings.vibrationEnabled,
        isOnboardingCompleted: _settings.isOnboardingCompleted,
        languageCode: languageCode,
        createdAt: _settings.createdAt,
        updatedAt: DateTime.now(),
      );

      await DatabaseService.updateSettings(updatedSettings);
      _settings = updatedSettings;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  @override
  void dispose() {
    DatabaseService.settingsListenable().removeListener(_loadSettings);
    super.dispose();
  }
}