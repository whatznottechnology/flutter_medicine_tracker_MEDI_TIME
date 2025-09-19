import 'package:flutter/foundation.dart';
import '../models/intake_log.dart';
import '../models/medicine.dart';
import '../models/water_log.dart';
import '../services/database_service.dart';

class HistoryProvider extends ChangeNotifier {
  List<IntakeLog> _intakeLogs = [];
  List<WaterLog> _waterLogs = [];
  bool _isLoading = false;
  String? _error;
  DateTime _selectedDate = DateTime.now();
  int _selectedPeriod = 7; // 7 days, 30 days, etc.

  List<IntakeLog> get intakeLogs => _intakeLogs;
  List<WaterLog> get waterLogs => _waterLogs;
  bool get isLoading => _isLoading;
  String? get error => _error;
  DateTime get selectedDate => _selectedDate;
  int get selectedPeriod => _selectedPeriod;

  List<IntakeLog> get filteredIntakeLogs {
    final startDate = _selectedDate.subtract(Duration(days: _selectedPeriod));
    return _intakeLogs.where((log) =>
        log.scheduledAt.isAfter(startDate) &&
        log.scheduledAt.isBefore(_selectedDate.add(const Duration(days: 1)))
    ).toList()..sort((a, b) => b.scheduledAt.compareTo(a.scheduledAt));
  }

  List<WaterLog> get filteredWaterLogs {
    final startDate = _selectedDate.subtract(Duration(days: _selectedPeriod));
    return _waterLogs.where((log) =>
        log.date.isAfter(startDate.subtract(const Duration(days: 1))) &&
        log.date.isBefore(_selectedDate.add(const Duration(days: 1)))
    ).toList()..sort((a, b) => b.date.compareTo(a.date));
  }

  HistoryProvider() {
    _loadHistory();
    _listenToChanges();
  }

  void _listenToChanges() {
    DatabaseService.intakeLogsListenable().addListener(_loadHistory);
    DatabaseService.waterLogsListenable().addListener(_loadHistory);
  }

  Future<void> _loadHistory() async {
    try {
      _isLoading = true;
      notifyListeners();

      // Load all intake logs and water logs
      final now = DateTime.now();
      final startDate = now.subtract(const Duration(days: 90)); // Load last 90 days
      
      _intakeLogs = DatabaseService.getIntakeLogsByDateRange(startDate, now);
      _waterLogs = DatabaseService.getWaterLogsByDateRange(startDate, now);

      _error = null;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  void setSelectedPeriod(int days) {
    _selectedPeriod = days;
    notifyListeners();
  }

  Future<void> markIntakeTaken(String logId) async {
    try {
      final log = _intakeLogs.firstWhere((log) => log.id == logId);
      final updatedLog = log.copyWith(
        status: IntakeStatus.taken,
        actualAt: DateTime.now(),
      );
      await DatabaseService.updateIntakeLog(updatedLog);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> markIntakeMissed(String logId) async {
    try {
      final log = _intakeLogs.firstWhere((log) => log.id == logId);
      final updatedLog = log.copyWith(
        status: IntakeStatus.missed,
        actualAt: DateTime.now(),
      );
      await DatabaseService.updateIntakeLog(updatedLog);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> markIntakeScheduled(String logId) async {
    try {
      final log = _intakeLogs.firstWhere((log) => log.id == logId);
      final updatedLog = log.copyWith(
        status: IntakeStatus.scheduled,
        actualAt: null, // Clear the actual time since it's back to scheduled
      );
      await DatabaseService.updateIntakeLog(updatedLog);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Analytics methods
  double getMedicineAdherenceRate() {
    final completedLogs = filteredIntakeLogs.where((log) =>
        log.status == IntakeStatus.taken || log.status == IntakeStatus.missed);
    
    if (completedLogs.isEmpty) return 0.0;
    
    final takenLogs = completedLogs.where((log) => log.status == IntakeStatus.taken);
    return takenLogs.length / completedLogs.length;
  }

  double getWaterComplianceRate() {
    if (filteredWaterLogs.isEmpty) return 0.0;
    
    final targetReachedDays = filteredWaterLogs.where((log) => log.isTargetReached);
    return targetReachedDays.length / filteredWaterLogs.length;
  }

  Map<String, int> getMedicineIntakeStats() {
    final stats = <String, int>{};
    
    for (final log in filteredIntakeLogs) {
      final medicine = DatabaseService.getMedicine(log.medicineId);
      if (medicine != null) {
        stats[medicine.name] = (stats[medicine.name] ?? 0) + 
            (log.status == IntakeStatus.taken ? 1 : 0);
      }
    }
    
    return stats;
  }

  List<IntakeLog> getIntakeLogsByMedicine(String medicineId) {
    return filteredIntakeLogs.where((log) => log.medicineId == medicineId).toList();
  }

  List<IntakeLog> getIntakeLogsByStatus(IntakeStatus status) {
    return filteredIntakeLogs.where((log) => log.status == status).toList();
  }

  List<IntakeLog> getTodaysIntakeLogs() {
    final today = DateTime.now();
    final todayStart = DateTime(today.year, today.month, today.day);
    final todayEnd = todayStart.add(const Duration(days: 1));
    
    return _intakeLogs.where((log) =>
        log.scheduledAt.isAfter(todayStart) &&
        log.scheduledAt.isBefore(todayEnd)
    ).toList()..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
  }

  List<IntakeLog> getUpcomingReminders() {
    final now = DateTime.now();
    final upcoming = _intakeLogs.where((log) =>
        log.status == IntakeStatus.scheduled &&
        log.scheduledAt.isAfter(now)
    ).toList();
    
    upcoming.sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
    return upcoming.take(5).toList(); // Next 5 reminders
  }

  Map<DateTime, List<IntakeLog>> getIntakeLogsByDay() {
    final groupedLogs = <DateTime, List<IntakeLog>>{};
    
    for (final log in filteredIntakeLogs) {
      final date = DateTime(
        log.scheduledAt.year,
        log.scheduledAt.month,
        log.scheduledAt.day,
      );
      
      if (!groupedLogs.containsKey(date)) {
        groupedLogs[date] = [];
      }
      groupedLogs[date]!.add(log);
    }
    
    return groupedLogs;
  }

  int getStreakDays() {
    int streak = 0;
    final sortedLogs = filteredWaterLogs.toList()
      ..sort((a, b) => b.date.compareTo(a.date));
    
    for (final log in sortedLogs) {
      if (log.isTargetReached) {
        streak++;
      } else {
        break;
      }
    }
    
    return streak;
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  @override
  void dispose() {
    DatabaseService.intakeLogsListenable().removeListener(_loadHistory);
    DatabaseService.waterLogsListenable().removeListener(_loadHistory);
    super.dispose();
  }
}