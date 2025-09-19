// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medicine.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MedicineAdapter extends TypeAdapter<Medicine> {
  @override
  final int typeId = 0;

  @override
  Medicine read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Medicine(
      id: fields[0] as String,
      name: fields[1] as String,
      dose: fields[2] as String,
      form: fields[3] as MedicineForm,
      relationToFood: fields[4] as FoodRelation,
      scheduleTimes: (fields[5] as List).cast<String>(),
      notes: fields[6] as String?,
      iconPath: fields[7] as String?,
      createdAt: fields[8] as DateTime,
      isActive: fields[9] as bool,
      imagePath: fields[10] as String?,
      currentStock: fields[11] as double?,
      lowStockThreshold: fields[12] as double?,
      alertsEnabled: fields[13] as bool,
      lowStockAlertsEnabled: fields[14] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Medicine obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.dose)
      ..writeByte(3)
      ..write(obj.form)
      ..writeByte(4)
      ..write(obj.relationToFood)
      ..writeByte(5)
      ..write(obj.scheduleTimes)
      ..writeByte(6)
      ..write(obj.notes)
      ..writeByte(7)
      ..write(obj.iconPath)
      ..writeByte(8)
      ..write(obj.createdAt)
      ..writeByte(9)
      ..write(obj.isActive)
      ..writeByte(10)
      ..write(obj.imagePath)
      ..writeByte(11)
      ..write(obj.currentStock)
      ..writeByte(12)
      ..write(obj.lowStockThreshold)
      ..writeByte(13)
      ..write(obj.alertsEnabled)
      ..writeByte(14)
      ..write(obj.lowStockAlertsEnabled);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MedicineAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MedicineFormAdapter extends TypeAdapter<MedicineForm> {
  @override
  final int typeId = 1;

  @override
  MedicineForm read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return MedicineForm.tablet;
      case 1:
        return MedicineForm.capsule;
      case 2:
        return MedicineForm.liquid;
      case 3:
        return MedicineForm.injection;
      case 4:
        return MedicineForm.drops;
      case 5:
        return MedicineForm.cream;
      case 6:
        return MedicineForm.spray;
      case 7:
        return MedicineForm.powder;
      case 8:
        return MedicineForm.other;
      default:
        return MedicineForm.tablet;
    }
  }

  @override
  void write(BinaryWriter writer, MedicineForm obj) {
    switch (obj) {
      case MedicineForm.tablet:
        writer.writeByte(0);
        break;
      case MedicineForm.capsule:
        writer.writeByte(1);
        break;
      case MedicineForm.liquid:
        writer.writeByte(2);
        break;
      case MedicineForm.injection:
        writer.writeByte(3);
        break;
      case MedicineForm.drops:
        writer.writeByte(4);
        break;
      case MedicineForm.cream:
        writer.writeByte(5);
        break;
      case MedicineForm.spray:
        writer.writeByte(6);
        break;
      case MedicineForm.powder:
        writer.writeByte(7);
        break;
      case MedicineForm.other:
        writer.writeByte(8);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MedicineFormAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FoodRelationAdapter extends TypeAdapter<FoodRelation> {
  @override
  final int typeId = 2;

  @override
  FoodRelation read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return FoodRelation.beforeMeal;
      case 1:
        return FoodRelation.afterMeal;
      case 2:
        return FoodRelation.withMeal;
      case 3:
        return FoodRelation.independent;
      default:
        return FoodRelation.beforeMeal;
    }
  }

  @override
  void write(BinaryWriter writer, FoodRelation obj) {
    switch (obj) {
      case FoodRelation.beforeMeal:
        writer.writeByte(0);
        break;
      case FoodRelation.afterMeal:
        writer.writeByte(1);
        break;
      case FoodRelation.withMeal:
        writer.writeByte(2);
        break;
      case FoodRelation.independent:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FoodRelationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
