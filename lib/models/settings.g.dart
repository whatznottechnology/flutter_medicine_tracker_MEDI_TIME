// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SettingsAdapter extends TypeAdapter<Settings> {
  @override
  final int typeId = 6;

  @override
  Settings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Settings(
      mealTimes: fields[0] as MealTimes,
      waterTarget: fields[1] as int,
      snoozeDuration: fields[2] as int,
      notificationsEnabled: fields[3] as bool,
      waterRemindersEnabled: fields[4] as bool,
      waterReminderInterval: fields[5] as int,
      soundEnabled: fields[6] as bool,
      vibrationEnabled: fields[7] as bool,
      isOnboardingCompleted: fields[8] as bool,
      languageCode: fields[9] as String,
      createdAt: fields[10] as DateTime,
      updatedAt: fields[11] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Settings obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.mealTimes)
      ..writeByte(1)
      ..write(obj.waterTarget)
      ..writeByte(2)
      ..write(obj.snoozeDuration)
      ..writeByte(3)
      ..write(obj.notificationsEnabled)
      ..writeByte(4)
      ..write(obj.waterRemindersEnabled)
      ..writeByte(5)
      ..write(obj.waterReminderInterval)
      ..writeByte(6)
      ..write(obj.soundEnabled)
      ..writeByte(7)
      ..write(obj.vibrationEnabled)
      ..writeByte(8)
      ..write(obj.isOnboardingCompleted)
      ..writeByte(9)
      ..write(obj.languageCode)
      ..writeByte(10)
      ..write(obj.createdAt)
      ..writeByte(11)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MealTimesAdapter extends TypeAdapter<MealTimes> {
  @override
  final int typeId = 7;

  @override
  MealTimes read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MealTimes(
      breakfast: fields[0] as String,
      lunch: fields[1] as String,
      dinner: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, MealTimes obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.breakfast)
      ..writeByte(1)
      ..write(obj.lunch)
      ..writeByte(2)
      ..write(obj.dinner);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MealTimesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
