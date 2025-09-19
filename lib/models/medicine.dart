import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

part 'medicine.g.dart';

@HiveType(typeId: 0)
class Medicine extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String dose;

  @HiveField(3)
  MedicineForm form;

  @HiveField(4)
  FoodRelation relationToFood;

  @HiveField(5)
  List<String> scheduleTimes;

  @HiveField(6)
  String? notes;

  @HiveField(7)
  String? iconPath;

  @HiveField(8)
  DateTime createdAt;

  @HiveField(9)
  bool isActive;

  @HiveField(10)
  String? imagePath;

  @HiveField(11)
  double? currentStock;

  @HiveField(12)
  double? lowStockThreshold;

  @HiveField(13)
  bool alertsEnabled;

  @HiveField(14)
  bool lowStockAlertsEnabled;

  Medicine({
    required this.id,
    required this.name,
    required this.dose,
    required this.form,
    required this.relationToFood,
    required this.scheduleTimes,
    this.notes,
    this.iconPath,
    required this.createdAt,
    this.isActive = true,
    this.imagePath,
    this.currentStock,
    this.lowStockThreshold,
    this.alertsEnabled = true,
    this.lowStockAlertsEnabled = true,
  });

  Medicine copyWith({
    String? id,
    String? name,
    String? dose,
    MedicineForm? form,
    FoodRelation? relationToFood,
    List<String>? scheduleTimes,
    String? notes,
    String? iconPath,
    DateTime? createdAt,
    bool? isActive,
    String? imagePath,
    double? currentStock,
    double? lowStockThreshold,
    bool? alertsEnabled,
    bool? lowStockAlertsEnabled,
  }) {
    return Medicine(
      id: id ?? this.id,
      name: name ?? this.name,
      dose: dose ?? this.dose,
      form: form ?? this.form,
      relationToFood: relationToFood ?? this.relationToFood,
      scheduleTimes: scheduleTimes ?? this.scheduleTimes,
      notes: notes ?? this.notes,
      iconPath: iconPath ?? this.iconPath,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
      imagePath: imagePath ?? this.imagePath,
      currentStock: currentStock ?? this.currentStock,
      lowStockThreshold: lowStockThreshold ?? this.lowStockThreshold,
      alertsEnabled: alertsEnabled ?? this.alertsEnabled,
      lowStockAlertsEnabled: lowStockAlertsEnabled ?? this.lowStockAlertsEnabled,
    );
  }

  bool get isLowStock {
    if (currentStock == null || lowStockThreshold == null) return false;
    return currentStock! <= lowStockThreshold!;
  }

  bool get isOutOfStock {
    if (currentStock == null) return false;
    return currentStock! <= 0;
  }

  String get stockDisplayText {
    if (currentStock == null) return 'Stock not tracked';
    return '${currentStock!.toStringAsFixed(form.isCountable ? 0 : 1)} ${form.unitName}';
  }
}

@HiveType(typeId: 1)
enum MedicineForm {
  @HiveField(0)
  tablet,
  @HiveField(1)
  capsule,
  @HiveField(2)
  liquid,
  @HiveField(3)
  injection,
  @HiveField(4)
  drops,
  @HiveField(5)
  cream,
  @HiveField(6)
  spray,
  @HiveField(7)
  powder,
  @HiveField(8)
  other,
}

@HiveType(typeId: 2)
enum FoodRelation {
  @HiveField(0)
  beforeMeal,
  @HiveField(1)
  afterMeal,
  @HiveField(2)
  withMeal,
  @HiveField(3)
  independent,
}

extension MedicineFormExtension on MedicineForm {
  String displayName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case MedicineForm.tablet:
        return l10n.tablet;
      case MedicineForm.capsule:
        return l10n.capsule;
      case MedicineForm.liquid:
        return l10n.liquid;
      case MedicineForm.injection:
        return l10n.injection;
      case MedicineForm.drops:
        return l10n.drops;
      case MedicineForm.cream:
        return l10n.cream;
      case MedicineForm.spray:
        return l10n.spray;
      case MedicineForm.powder:
        return l10n.powder;
      case MedicineForm.other:
        return l10n.other;
    }
  }

  String get unitName {
    switch (this) {
      case MedicineForm.tablet:
      case MedicineForm.capsule:
        return 'pieces';
      case MedicineForm.liquid:
        return 'ml';
      case MedicineForm.injection:
        return 'units';
      case MedicineForm.drops:
        return 'drops';
      case MedicineForm.cream:
      case MedicineForm.powder:
        return 'grams';
      case MedicineForm.spray:
        return 'sprays';
      case MedicineForm.other:
        return 'units';
    }
  }

  bool get isCountable {
    switch (this) {
      case MedicineForm.tablet:
      case MedicineForm.capsule:
      case MedicineForm.injection:
        return true;
      case MedicineForm.liquid:
      case MedicineForm.drops:
      case MedicineForm.cream:
      case MedicineForm.spray:
      case MedicineForm.powder:
      case MedicineForm.other:
        return false;
    }
  }
}

extension FoodRelationExtension on FoodRelation {
  String displayName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case FoodRelation.beforeMeal:
        return l10n.beforeMeal;
      case FoodRelation.afterMeal:
        return l10n.afterMeal;
      case FoodRelation.withMeal:
        return l10n.withMeal;
      case FoodRelation.independent:
        return l10n.independent;
    }
  }
}
