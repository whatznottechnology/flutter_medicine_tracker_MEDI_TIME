// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'intake_log.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class IntakeLogAdapter extends TypeAdapter<IntakeLog> {
  @override
  final int typeId = 3;

  @override
  IntakeLog read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return IntakeLog(
      id: fields[0] as String,
      medicineId: fields[1] as String,
      scheduledAt: fields[2] as DateTime,
      actualAt: fields[3] as DateTime?,
      status: fields[4] as IntakeStatus,
      notes: fields[5] as String?,
      createdAt: fields[6] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, IntakeLog obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.medicineId)
      ..writeByte(2)
      ..write(obj.scheduledAt)
      ..writeByte(3)
      ..write(obj.actualAt)
      ..writeByte(4)
      ..write(obj.status)
      ..writeByte(5)
      ..write(obj.notes)
      ..writeByte(6)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IntakeLogAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class IntakeStatusAdapter extends TypeAdapter<IntakeStatus> {
  @override
  final int typeId = 4;

  @override
  IntakeStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return IntakeStatus.taken;
      case 1:
        return IntakeStatus.missed;
      case 2:
        return IntakeStatus.snoozed;
      case 3:
        return IntakeStatus.scheduled;
      default:
        return IntakeStatus.taken;
    }
  }

  @override
  void write(BinaryWriter writer, IntakeStatus obj) {
    switch (obj) {
      case IntakeStatus.taken:
        writer.writeByte(0);
        break;
      case IntakeStatus.missed:
        writer.writeByte(1);
        break;
      case IntakeStatus.snoozed:
        writer.writeByte(2);
        break;
      case IntakeStatus.scheduled:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IntakeStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
