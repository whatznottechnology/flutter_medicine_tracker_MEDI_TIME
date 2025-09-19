import 'package:hive/hive.dart';

part 'settings.g.dart';

@HiveType(typeId: 6)
class Settings extends HiveObject {
  @HiveField(0)
  MealTimes mealTimes;

  @HiveField(1)
  int waterTarget;

  @HiveField(2)
  int snoozeDuration;

  @HiveField(3)
  bool notificationsEnabled;

  @HiveField(4)
  bool waterRemindersEnabled;

  @HiveField(5)
  int waterReminderInterval;

  @HiveField(6)
  bool soundEnabled;

  @HiveField(7)
  bool vibrationEnabled;

  @HiveField(8)
  bool isOnboardingCompleted;

  @HiveField(9)
  String languageCode;

  @HiveField(10)
  DateTime createdAt;

  @HiveField(11)
  DateTime updatedAt;

  Settings({
    required this.mealTimes,
    this.waterTarget = 8,
    this.snoozeDuration = 10,
    this.notificationsEnabled = true,
    this.waterRemindersEnabled = true,
    this.waterReminderInterval = 120,
    this.soundEnabled = true,
    this.vibrationEnabled = true,
    this.isOnboardingCompleted = false,
    this.languageCode = 'en',
    required this.createdAt,
    required this.updatedAt,
  });

  Settings copyWith({
    MealTimes? mealTimes,
    int? waterTarget,
    int? snoozeDuration,
    bool? notificationsEnabled,
    bool? waterRemindersEnabled,
    int? waterReminderInterval,
    bool? soundEnabled,
    bool? vibrationEnabled,
    bool? isOnboardingCompleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Settings(
      mealTimes: mealTimes ?? this.mealTimes,
      waterTarget: waterTarget ?? this.waterTarget,
      snoozeDuration: snoozeDuration ?? this.snoozeDuration,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      waterRemindersEnabled: waterRemindersEnabled ?? this.waterRemindersEnabled,
      waterReminderInterval: waterReminderInterval ?? this.waterReminderInterval,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      isOnboardingCompleted: isOnboardingCompleted ?? this.isOnboardingCompleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  static Settings defaultSettings() {
    final now = DateTime.now();
    return Settings(
      mealTimes: MealTimes.defaultTimes(),
      languageCode: 'en',
      createdAt: now,
      updatedAt: now,
    );
  }
}

@HiveType(typeId: 7)
class MealTimes extends HiveObject {
  @HiveField(0)
  String breakfast;

  @HiveField(1)
  String lunch;

  @HiveField(2)
  String dinner;

  MealTimes({
    required this.breakfast,
    required this.lunch,
    required this.dinner,
  });

  MealTimes copyWith({
    String? breakfast,
    String? lunch,
    String? dinner,
  }) {
    return MealTimes(
      breakfast: breakfast ?? this.breakfast,
      lunch: lunch ?? this.lunch,
      dinner: dinner ?? this.dinner,
    );
  }

  static MealTimes defaultTimes() {
    return MealTimes(
      breakfast: '08:00',
      lunch: '13:00',
      dinner: '19:00',
    );
  }

  Map<String, String> toMap() {
    return {
      'Breakfast': breakfast,
      'Lunch': lunch,
      'Dinner': dinner,
    };
  }
}
