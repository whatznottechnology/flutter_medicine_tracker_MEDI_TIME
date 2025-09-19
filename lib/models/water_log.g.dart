// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'water_log.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WaterLogAdapter extends TypeAdapter<WaterLog> {
  @override
  final int typeId = 5;

  @override
  WaterLog read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WaterLog(
      id: fields[0] as String,
      date: fields[1] as DateTime,
      glassesTaken: fields[2] as int,
      target: fields[3] as int,
      intakeTimes: (fields[4] as List).cast<DateTime>(),
      createdAt: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, WaterLog obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.glassesTaken)
      ..writeByte(3)
      ..write(obj.target)
      ..writeByte(4)
      ..write(obj.intakeTimes)
      ..writeByte(5)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WaterLogAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
