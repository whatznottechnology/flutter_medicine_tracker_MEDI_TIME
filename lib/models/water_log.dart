import 'package:hive/hive.dart';

part 'water_log.g.dart';

@HiveType(typeId: 5)
class WaterLog extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  DateTime date;

  @HiveField(2)
  int glassesTaken;

  @HiveField(3)
  int target;

  @HiveField(4)
  List<DateTime> intakeTimes;

  @HiveField(5)
  DateTime createdAt;

  WaterLog({
    required this.id,
    required this.date,
    required this.glassesTaken,
    required this.target,
    required this.intakeTimes,
    required this.createdAt,
  });

  WaterLog copyWith({
    String? id,
    DateTime? date,
    int? glassesTaken,
    int? target,
    List<DateTime>? intakeTimes,
    DateTime? createdAt,
  }) {
    return WaterLog(
      id: id ?? this.id,
      date: date ?? this.date,
      glassesTaken: glassesTaken ?? this.glassesTaken,
      target: target ?? this.target,
      intakeTimes: intakeTimes ?? List.from(this.intakeTimes),
      createdAt: createdAt ?? this.createdAt,
    );
  }

  double get progressPercentage {
    return target > 0 ? (glassesTaken / target).clamp(0.0, 1.0) : 0.0;
  }

  bool get isTargetReached {
    return glassesTaken >= target;
  }

  String get formattedDate {
    return '${date.day}/${date.month}/${date.year}';
  }
}
