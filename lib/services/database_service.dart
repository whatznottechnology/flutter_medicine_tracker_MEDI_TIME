import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/medicine.dart';
import '../models/intake_log.dart';
import '../models/water_log.dart';
import '../models/settings.dart';

class DatabaseService {
  static const String _medicinesBox = 'medicines';
  static const String _intakeLogsBox = 'intake_logs';
  static const String _waterLogsBox = 'water_logs';
  static const String _settingsBox = 'settings';
  static const String _settingsKey = 'app_settings';

  static late Box<Medicine> _medicines;
  static late Box<IntakeLog> _intakeLogs;
  static late Box<WaterLog> _waterLogs;
  static late Box<Settings> _settings;

  static Future<void> initialize() async {
    await Hive.initFlutter();

    // Register adapters
    Hive.registerAdapter(MedicineAdapter());
    Hive.registerAdapter(MedicineFormAdapter());
    Hive.registerAdapter(FoodRelationAdapter());
    Hive.registerAdapter(IntakeLogAdapter());
    Hive.registerAdapter(IntakeStatusAdapter());
    Hive.registerAdapter(WaterLogAdapter());
    Hive.registerAdapter(SettingsAdapter());
    Hive.registerAdapter(MealTimesAdapter());

    // Open boxes
    _medicines = await Hive.openBox<Medicine>(_medicinesBox);
    _intakeLogs = await Hive.openBox<IntakeLog>(_intakeLogsBox);
    _waterLogs = await Hive.openBox<WaterLog>(_waterLogsBox);
    _settings = await Hive.openBox<Settings>(_settingsBox);

    // Initialize default settings if not exists
    if (_settings.get(_settingsKey) == null) {
      await _settings.put(_settingsKey, Settings.defaultSettings());
    }
  }

  // Medicine CRUD operations
  static Future<void> addMedicine(Medicine medicine) async {
    await _medicines.put(medicine.id, medicine);
  }

  static Future<void> updateMedicine(Medicine medicine) async {
    await _medicines.put(medicine.id, medicine);
  }

  static Future<void> deleteMedicine(String id) async {
    await _medicines.delete(id);
    // Also delete related intake logs
    final intakeLogsToDelete = _intakeLogs.values
        .where((log) => log.medicineId == id)
        .map((log) => log.key)
        .toList();
    
    for (final key in intakeLogsToDelete) {
      await _intakeLogs.delete(key);
    }
  }

  static Medicine? getMedicine(String id) {
    return _medicines.get(id);
  }

  static List<Medicine> getAllMedicines() {
    return _medicines.values.where((medicine) => medicine.isActive).toList();
  }

  static ValueListenable<Box<Medicine>> medicinesListenable() {
    return _medicines.listenable();
  }

  // Intake Log CRUD operations
  static Future<void> addIntakeLog(IntakeLog log) async {
    await _intakeLogs.put(log.id, log);
  }

  static Future<void> updateIntakeLog(IntakeLog log) async {
    await _intakeLogs.put(log.id, log);
  }

  static Future<void> deleteIntakeLog(String id) async {
    await _intakeLogs.delete(id);
  }

  static IntakeLog? getIntakeLog(String id) {
    return _intakeLogs.get(id);
  }

  static List<IntakeLog> getIntakeLogsByMedicine(String medicineId) {
    return _intakeLogs.values
        .where((log) => log.medicineId == medicineId)
        .toList();
  }

  static List<IntakeLog> getIntakeLogsByDateRange(DateTime start, DateTime end) {
    return _intakeLogs.values
        .where((log) => 
            log.scheduledAt.isAfter(start.subtract(const Duration(days: 1))) &&
            log.scheduledAt.isBefore(end.add(const Duration(days: 1))))
        .toList();
  }

  static List<IntakeLog> getTodaysIntakeLogs() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    
    return getIntakeLogsByDateRange(today, tomorrow);
  }

  static ValueListenable<Box<IntakeLog>> intakeLogsListenable() {
    return _intakeLogs.listenable();
  }

  // Water Log CRUD operations
  static Future<void> addWaterLog(WaterLog log) async {
    await _waterLogs.put(log.id, log);
  }

  static Future<void> updateWaterLog(WaterLog log) async {
    await _waterLogs.put(log.id, log);
  }

  static Future<void> deleteWaterLog(String id) async {
    await _waterLogs.delete(id);
  }

  static WaterLog? getWaterLog(String id) {
    return _waterLogs.get(id);
  }

  static WaterLog? getTodaysWaterLog() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    return _waterLogs.values
        .where((log) => 
            log.date.year == today.year &&
            log.date.month == today.month &&
            log.date.day == today.day)
        .firstOrNull;
  }

  static List<WaterLog> getWaterLogsByDateRange(DateTime start, DateTime end) {
    return _waterLogs.values
        .where((log) => 
            log.date.isAfter(start.subtract(const Duration(days: 1))) &&
            log.date.isBefore(end.add(const Duration(days: 1))))
        .toList();
  }

  static ValueListenable<Box<WaterLog>> waterLogsListenable() {
    return _waterLogs.listenable();
  }

  // Settings operations
  static Future<void> updateSettings(Settings settings) async {
    await _settings.put(_settingsKey, settings);
  }

  static Settings getSettings() {
    return _settings.get(_settingsKey) ?? Settings.defaultSettings();
  }

  static ValueListenable<Box<Settings>> settingsListenable() {
    return _settings.listenable(keys: [_settingsKey]);
  }

  // Utility methods
  static Future<void> clearAllData() async {
    await _medicines.clear();
    await _intakeLogs.clear();
    await _waterLogs.clear();
    await _settings.put(_settingsKey, Settings.defaultSettings());
  }

  static Future<Map<String, dynamic>> exportData() async {
    return {
      'medicines': _medicines.values.map((m) => {
        'id': m.id,
        'name': m.name,
        'dose': m.dose,
        'form': m.form.name,
        'relationToFood': m.relationToFood.name,
        'scheduleTimes': m.scheduleTimes,
        'notes': m.notes,
        'iconPath': m.iconPath,
        'createdAt': m.createdAt.toIso8601String(),
        'isActive': m.isActive,
      }).toList(),
      'intakeLogs': _intakeLogs.values.map((log) => {
        'id': log.id,
        'medicineId': log.medicineId,
        'scheduledAt': log.scheduledAt.toIso8601String(),
        'actualAt': log.actualAt?.toIso8601String(),
        'status': log.status.name,
        'notes': log.notes,
        'createdAt': log.createdAt.toIso8601String(),
      }).toList(),
      'waterLogs': _waterLogs.values.map((log) => {
        'id': log.id,
        'date': log.date.toIso8601String(),
        'glassesTaken': log.glassesTaken,
        'target': log.target,
        'intakeTimes': log.intakeTimes.map((time) => time.toIso8601String()).toList(),
        'createdAt': log.createdAt.toIso8601String(),
      }).toList(),
      'settings': {
        'mealTimes': {
          'breakfast': getSettings().mealTimes.breakfast,
          'lunch': getSettings().mealTimes.lunch,
          'dinner': getSettings().mealTimes.dinner,
        },
        'waterTarget': getSettings().waterTarget,
        'snoozeDuration': getSettings().snoozeDuration,
        'notificationsEnabled': getSettings().notificationsEnabled,
        'waterRemindersEnabled': getSettings().waterRemindersEnabled,
        'waterReminderInterval': getSettings().waterReminderInterval,
        'soundEnabled': getSettings().soundEnabled,
        'vibrationEnabled': getSettings().vibrationEnabled,
        'isOnboardingCompleted': getSettings().isOnboardingCompleted,
      },
    };
  }

  // Stock Management Methods
  static Future<void> updateMedicineStock(String medicineId, double newStock) async {
    final medicine = getMedicine(medicineId);
    if (medicine != null) {
      final updatedMedicine = medicine.copyWith(currentStock: newStock);
      await updateMedicine(updatedMedicine);
    }
  }

  static Future<void> decreaseStock(String medicineId, double amount) async {
    final medicine = getMedicine(medicineId);
    if (medicine != null && medicine.currentStock != null) {
      final newStock = (medicine.currentStock! - amount).clamp(0.0, double.infinity);
      final updatedMedicine = medicine.copyWith(currentStock: newStock);
      await updateMedicine(updatedMedicine);
    }
  }

  static Future<void> increaseStock(String medicineId, double amount) async {
    final medicine = getMedicine(medicineId);
    if (medicine != null && medicine.currentStock != null) {
      final newStock = medicine.currentStock! + amount;
      final updatedMedicine = medicine.copyWith(currentStock: newStock);
      await updateMedicine(updatedMedicine);
    }
  }

  static List<Medicine> getLowStockMedicines() {
    return getAllMedicines()
        .where((medicine) => 
            medicine.isActive && 
            medicine.lowStockAlertsEnabled && 
            medicine.isLowStock)
        .toList();
  }

  static List<Medicine> getOutOfStockMedicines() {
    return getAllMedicines()
        .where((medicine) => 
            medicine.isActive && 
            medicine.currentStock != null && 
            medicine.isOutOfStock)
        .toList();
  }

  static int getLowStockCount() {
    return getLowStockMedicines().length;
  }

  static int getOutOfStockCount() {
    return getOutOfStockMedicines().length;
  }

  // Image Management Methods
  static List<String> getAllUsedImagePaths() {
    return getAllMedicines()
        .where((medicine) => medicine.imagePath != null)
        .map((medicine) => medicine.imagePath!)
        .toList();
  }

  static Future<void> dispose() async {
    await _medicines.close();
    await _intakeLogs.close();
    await _waterLogs.close();
    await _settings.close();
  }
}