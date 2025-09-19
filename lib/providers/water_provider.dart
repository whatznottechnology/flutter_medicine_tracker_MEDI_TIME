import 'package:flutter/foundation.dart';
import '../models/water_log.dart';
import '../services/database_service.dart';

class WaterProvider extends ChangeNotifier {
  WaterLog? _todayLog;
  List<WaterLog> _recentLogs = [];
  bool _isLoading = false;
  String? _error;

  WaterLog? get todayLog => _todayLog;
  List<WaterLog> get recentLogs => _recentLogs;
  bool get isLoading => _isLoading;
  String? get error => _error;

  int get todayGlasses => _todayLog?.glassesTaken ?? 0;
  int get todayTarget => _todayLog?.target ?? 8;
  double get todayProgress => _todayLog?.progressPercentage ?? 0.0;
  bool get isTargetReached => _todayLog?.isTargetReached ?? false;

  WaterProvider() {
    _loadTodayLog();
    _loadRecentLogs();
    _listenToChanges();
  }

  void _listenToChanges() {
    DatabaseService.waterLogsListenable().addListener(_onWaterLogsChanged);
  }

  void _onWaterLogsChanged() {
    _loadTodayLog();
    _loadRecentLogs();
  }

  Future<void> _loadTodayLog() async {
    try {
      _todayLog = DatabaseService.getTodaysWaterLog();
      
      // Create today's log if it doesn't exist
      if (_todayLog == null) {
        final settings = DatabaseService.getSettings();
        _todayLog = WaterLog(
          id: _generateTodayLogId(),
          date: DateTime.now(),
          glassesTaken: 0,
          target: settings.waterTarget,
          intakeTimes: [],
          createdAt: DateTime.now(),
        );
        await DatabaseService.addWaterLog(_todayLog!);
      }
      
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> _loadRecentLogs() async {
    try {
      final now = DateTime.now();
      final sevenDaysAgo = now.subtract(const Duration(days: 7));
      _recentLogs = DatabaseService.getWaterLogsByDateRange(sevenDaysAgo, now);
      _recentLogs.sort((a, b) => b.date.compareTo(a.date));
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  String _generateTodayLogId() {
    final now = DateTime.now();
    return 'water_${now.year}_${now.month}_${now.day}';
  }

  Future<void> addWaterGlass() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      if (_todayLog == null) {
        await _loadTodayLog();
      }

      if (_todayLog != null) {
        final updatedIntakeTimes = List<DateTime>.from(_todayLog!.intakeTimes)
          ..add(DateTime.now());
        
        final updatedLog = _todayLog!.copyWith(
          glassesTaken: _todayLog!.glassesTaken + 1,
          intakeTimes: updatedIntakeTimes,
        );

        await DatabaseService.updateWaterLog(updatedLog);
        _todayLog = updatedLog;
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> removeWaterGlass() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      if (_todayLog != null && _todayLog!.glassesTaken > 0) {
        final updatedIntakeTimes = List<DateTime>.from(_todayLog!.intakeTimes);
        if (updatedIntakeTimes.isNotEmpty) {
          updatedIntakeTimes.removeLast();
        }
        
        final updatedLog = _todayLog!.copyWith(
          glassesTaken: _todayLog!.glassesTaken - 1,
          intakeTimes: updatedIntakeTimes,
        );

        await DatabaseService.updateWaterLog(updatedLog);
        _todayLog = updatedLog;
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> setWaterTarget(int newTarget) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      if (_todayLog != null) {
        final updatedLog = _todayLog!.copyWith(target: newTarget);
        await DatabaseService.updateWaterLog(updatedLog);
        _todayLog = updatedLog;
      }

      // Also update settings
      final settings = DatabaseService.getSettings();
      final updatedSettings = settings.copyWith(waterTarget: newTarget);
      await DatabaseService.updateSettings(updatedSettings);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> resetTodayLog() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      if (_todayLog != null) {
        final updatedLog = _todayLog!.copyWith(
          glassesTaken: 0,
          intakeTimes: [],
        );
        await DatabaseService.updateWaterLog(updatedLog);
        _todayLog = updatedLog;
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  List<WaterLog> getLogsByDateRange(DateTime start, DateTime end) {
    return DatabaseService.getWaterLogsByDateRange(start, end);
  }

  double getAverageIntakeForPeriod(int days) {
    final now = DateTime.now();
    final startDate = now.subtract(Duration(days: days));
    final logs = getLogsByDateRange(startDate, now);
    
    if (logs.isEmpty) return 0.0;
    
    final totalGlasses = logs.fold<int>(0, (sum, log) => sum + log.glassesTaken);
    return totalGlasses / logs.length;
  }

  double getComplianceRateForPeriod(int days) {
    final now = DateTime.now();
    final startDate = now.subtract(Duration(days: days));
    final logs = getLogsByDateRange(startDate, now);
    
    if (logs.isEmpty) return 0.0;
    
    final targetReachedCount = logs.where((log) => log.isTargetReached).length;
    return targetReachedCount / logs.length;
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  @override
  void dispose() {
    DatabaseService.waterLogsListenable().removeListener(_onWaterLogsChanged);
    super.dispose();
  }
}