import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import '../l10n/app_localizations.dart';
import '../providers/history_provider.dart';
import '../providers/medicine_provider.dart';
import '../models/intake_log.dart';
import '../models/medicine.dart';
import '../utils/time_utils.dart';

class UpcomingMedicinesCard extends StatelessWidget {
  const UpcomingMedicinesCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: const Color(0xFF4CAF50).withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Enhanced Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? const Color(0xFF4CAF50).withOpacity(0.1)
                  : const Color(0xFF4CAF50).withOpacity(0.05),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CAF50),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.schedule,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.upcomingMedicines,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF4CAF50),
                        ),
                      ),
                      Text(
                        l10n.nextDosesDue,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CAF50),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Consumer<HistoryProvider>(
                    builder: (context, historyProvider, child) {
                      final upcomingCount = historyProvider.getUpcomingReminders().length;
                      return Text(
                        upcomingCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          
          // Content
          Consumer<HistoryProvider>(
            builder: (context, historyProvider, child) {
              final upcomingIntakes = historyProvider.getUpcomingReminders();
              
              if (upcomingIntakes.isEmpty) {
                return _buildEmptyState(context, l10n);
              }
              
              // Group by time and sort
              final groupedIntakes = <String, List<IntakeLog>>{};
              for (final intake in upcomingIntakes) {
                final timeKey = TimeUtils.format12Hour(intake.scheduledAt);
                groupedIntakes.putIfAbsent(timeKey, () => []).add(intake);
              }
              
              final sortedTimes = groupedIntakes.keys.toList()
                ..sort((a, b) {
                  final timeA = DateFormat('h:mm a').parse(a);
                  final timeB = DateFormat('h:mm a').parse(b);
                  return timeA.compareTo(timeB);
                });
              
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: sortedTimes.map((time) {
                    final intakes = groupedIntakes[time]!;
                    return _buildTimeGroup(context, time, intakes, l10n);
                  }).toList(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            l10n.noUpcomingMedicines,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.allCaughtUp,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTimeGroup(BuildContext context, String time, List<IntakeLog> intakes, AppLocalizations l10n) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey[800]?.withOpacity(0.3)
            : Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Time header
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey[700]?.withOpacity(0.5)
                  : Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey.withOpacity(0.2),
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 18,
                  color: const Color(0xFF4CAF50),
                ),
                const SizedBox(width: 8),
                Text(
                  time,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF4CAF50),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CAF50).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${intakes.length} ${intakes.length == 1 ? l10n.medicine : l10n.medicines}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: const Color(0xFF4CAF50),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Medicines
          Column(
            children: intakes.map((intake) => _buildMedicineItem(context, intake, l10n)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildMedicineItem(BuildContext context, IntakeLog intake, AppLocalizations l10n) {
    return Consumer<MedicineProvider>(
      builder: (context, medicineProvider, child) {
        final medicine = medicineProvider.getMedicineById(intake.medicineId);
        
        if (medicine == null) {
          return const SizedBox.shrink();
        }
        
        final now = DateTime.now();
        final isOverdue = intake.scheduledAt.isBefore(now);
        final timeDifference = intake.scheduledAt.difference(now);
        
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.grey.withOpacity(0.1),
              ),
            ),
          ),
          child: Row(
            children: [
              // Medicine image/icon
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: _getStatusColor(context, intake.status, isOverdue).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _getStatusColor(context, intake.status, isOverdue).withOpacity(0.3),
                  ),
                ),
                child: medicine.imagePath != null && File(medicine.imagePath!).existsSync()
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          File(medicine.imagePath!),
                          fit: BoxFit.cover,
                        ),
                      )
                    : Icon(
                        _getStatusIcon(intake.status, isOverdue),
                        color: _getStatusColor(context, intake.status, isOverdue),
                        size: 24,
                      ),
              ),
              
              const SizedBox(width: 12),
              
              // Medicine details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      medicine.name,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(
                          Icons.medical_services_outlined,
                          size: 14,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${medicine.dose} • ${medicine.form.displayName(context)}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: _getStatusColor(context, intake.status, isOverdue).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            _getStatusText(context, intake.status, isOverdue),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: _getStatusColor(context, intake.status, isOverdue),
                              fontWeight: FontWeight.w500,
                              fontSize: 10,
                            ),
                          ),
                        ),
                        if (isOverdue) ...[
                          const SizedBox(width: 8),
                          Icon(
                            Icons.warning_amber_rounded,
                            size: 14,
                            color: Colors.orange[600],
                          ),
                          const SizedBox(width: 2),
                          Text(
                            _getTimeAgo(intake.scheduledAt),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.orange[600],
                              fontWeight: FontWeight.w500,
                              fontSize: 10,
                            ),
                          ),
                        ] else if (timeDifference.inMinutes < 60) ...[
                          const SizedBox(width: 8),
                          Icon(
                            Icons.schedule,
                            size: 14,
                            color: Colors.blue[600],
                          ),
                          const SizedBox(width: 2),
                          Text(
                            _getTimeUntil(intake.scheduledAt),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.blue[600],
                              fontWeight: FontWeight.w500,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              
              // Action buttons
              if (intake.status == IntakeStatus.scheduled || intake.status == IntakeStatus.snoozed)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildActionButton(
                      context,
                      intake,
                      'taken',
                      Icons.check,
                      Colors.green,
                      l10n.markTaken,
                    ),
                    const SizedBox(width: 8),
                    _buildActionButton(
                      context,
                      intake,
                      'skip',
                      Icons.close,
                      Colors.orange,
                      l10n.skip,
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    IntakeLog intake,
    String action,
    IconData icon,
    Color color,
    String tooltip,
  ) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: () => _handleAction(context, intake, action),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: color.withOpacity(0.3),
            ),
          ),
          child: Icon(
            icon,
            size: 18,
            color: color,
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(BuildContext context, IntakeStatus status, bool isOverdue) {
    if (isOverdue) return Colors.orange;
    
    switch (status) {
      case IntakeStatus.scheduled:
        return const Color(0xFF4CAF50);
      case IntakeStatus.snoozed:
        return Colors.blue;
      case IntakeStatus.missed:
        return Colors.red;
      case IntakeStatus.taken:
        return Colors.green;
    }
  }

  IconData _getStatusIcon(IntakeStatus status, bool isOverdue) {
    if (isOverdue) return Icons.schedule_rounded;
    
    switch (status) {
      case IntakeStatus.scheduled:
        return Icons.schedule;
      case IntakeStatus.snoozed:
        return Icons.snooze;
      case IntakeStatus.missed:
        return Icons.close;
      case IntakeStatus.taken:
        return Icons.check_circle;
    }
  }

  String _getStatusText(BuildContext context, IntakeStatus status, bool isOverdue) {
    final l10n = AppLocalizations.of(context)!;
    
    if (isOverdue) return l10n.overdue;
    
    switch (status) {
      case IntakeStatus.scheduled:
        return l10n.scheduled;
      case IntakeStatus.snoozed:
        return l10n.snoozed;
      case IntakeStatus.missed:
        return l10n.missed;
      case IntakeStatus.taken:
        return l10n.taken;
    }
  }

  String _getTimeAgo(DateTime scheduledTime) {
    final now = DateTime.now();
    final difference = now.difference(scheduledTime);
    
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  String _getTimeUntil(DateTime scheduledTime) {
    final now = DateTime.now();
    final difference = scheduledTime.difference(now);
    
    if (difference.inMinutes < 60) {
      return 'in ${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return 'in ${difference.inHours}h';
    } else {
      return 'in ${difference.inDays}d';
    }
  }

  void _handleAction(BuildContext context, IntakeLog log, String action) {
    final historyProvider = Provider.of<HistoryProvider>(context, listen: false);
    final l10n = AppLocalizations.of(context)!;
    
    switch (action) {
      case 'taken':
        historyProvider.markIntakeTaken(log.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.medicineMarkedTaken),
            action: SnackBarAction(
              label: l10n.undo,
              onPressed: () {
                historyProvider.markIntakeScheduled(log.id);
              },
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );
        break;
        
      case 'skip':
        historyProvider.markIntakeMissed(log.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.medicineSkipped),
            action: SnackBarAction(
              label: l10n.undo,
              onPressed: () {
                historyProvider.markIntakeScheduled(log.id);
              },
            ),
            backgroundColor: Colors.orange,
            duration: const Duration(seconds: 3),
          ),
        );
        break;
    }
  }
}