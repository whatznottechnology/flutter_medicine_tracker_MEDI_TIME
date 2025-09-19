import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

part 'intake_log.g.dart';

@HiveType(typeId: 3)
class IntakeLog extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String medicineId;

  @HiveField(2)
  DateTime scheduledAt;

  @HiveField(3)
  DateTime? actualAt;

  @HiveField(4)
  IntakeStatus status;

  @HiveField(5)
  String? notes;

  @HiveField(6)
  DateTime createdAt;

  IntakeLog({
    required this.id,
    required this.medicineId,
    required this.scheduledAt,
    this.actualAt,
    required this.status,
    this.notes,
    required this.createdAt,
  });

  IntakeLog copyWith({
    String? id,
    String? medicineId,
    DateTime? scheduledAt,
    DateTime? actualAt,
    IntakeStatus? status,
    String? notes,
    DateTime? createdAt,
  }) {
    return IntakeLog(
      id: id ?? this.id,
      medicineId: medicineId ?? this.medicineId,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      actualAt: actualAt ?? this.actualAt,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

@HiveType(typeId: 4)
enum IntakeStatus {
  @HiveField(0)
  taken,
  @HiveField(1)
  missed,
  @HiveField(2)
  snoozed,
  @HiveField(3)
  scheduled,
}

extension IntakeStatusExtension on IntakeStatus {
  String displayName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case IntakeStatus.taken:
        return l10n.taken;
      case IntakeStatus.missed:
        return l10n.missed;
      case IntakeStatus.snoozed:
        return l10n.snoozed;
      case IntakeStatus.scheduled:
        return l10n.scheduled;
    }
  }

  String get emoji {
    switch (this) {
      case IntakeStatus.taken:
        return '✅';
      case IntakeStatus.missed:
        return '❌';
      case IntakeStatus.snoozed:
        return '⏰';
      case IntakeStatus.scheduled:
        return '🕐';
    }
  }
}
