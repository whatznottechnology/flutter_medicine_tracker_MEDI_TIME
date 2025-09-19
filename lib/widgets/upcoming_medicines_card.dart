import 'package:flutter/material.dart';import 'package:flutter/material.dart';

import 'package:provider/provider.dart';import 'package:provider/provider.dart';

import 'package:intl/intl.dart';import 'package:intl/intl.dart';

import 'dart:io';import 'dart:io';

import '../l10n/app_localizations.dart';import '../l10n/app_localizations.dart';

import '../providers/history_provider.dart';import '../providers/history_provider.dart';

import '../providers/medicine_provider.dart';import '../providers/medicine_provider.dart';

import '../models/intake_log.dart';import '../models/intake_log.dart';

import '../models/medicine.dart';import '../models/medicine.dart';

import '../utils/time_utils.dart';import '../utils/time_utils.dart';



class UpcomingMedicinesCard extends StatelessWidget {class UpcomingMedicinesCard extends StatelessWidget {

  const UpcomingMedicinesCard({super.key});  const UpcomingMedicinesCard({super.key});



  @override  @override

  Widget build(BuildContext context) {  Widget build(BuildContext context) {

    final l10n = AppLocalizations.of(context)!;    final l10n = AppLocalizations.of(context)!;

        

    return Container(    return Container(

      margin: const EdgeInsets.all(16),      margin: const EdgeInsets.all(16),

      decoration: BoxDecoration(      decoration: BoxDecoration(

        color: Theme.of(context).cardColor,        color: Theme.of(context).cardColor,

        borderRadius: BorderRadius.circular(16),        borderRadius: BorderRadius.circular(16),

        boxShadow: [        boxShadow: [

          BoxShadow(          BoxShadow(

            color: Theme.of(context).shadowColor.withOpacity(0.1),            color: Theme.of(context).shadowColor.withOpacity(0.1),

            spreadRadius: 1,            spreadRadius: 1,

            blurRadius: 8,            blurRadius: 8,

            offset: const Offset(0, 2),            offset: const Offset(0, 2),

          ),          ),

        ],        ],

        border: Border.all(        border: Border.all(

          color: const Color(0xFF4CAF50).withOpacity(0.2),          color: const Color(0xFF4CAF50).withOpacity(0.2),

          width: 1,          width: 1,

        ),        ),

      ),      ),

      child: Column(      child: Column(

        crossAxisAlignment: CrossAxisAlignment.start,        crossAxisAlignment: CrossAxisAlignment.start,

        children: [        children: [

          // Enhanced Header          // Enhanced Header

          Container(          Container(

            padding: const EdgeInsets.all(16),            padding: const EdgeInsets.all(16),

            decoration: BoxDecoration(            decoration: BoxDecoration(

              color: Theme.of(context).brightness == Brightness.dark              color: Theme.of(context).brightness == Brightness.dark

                  ? const Color(0xFF4CAF50).withOpacity(0.1)                  ? const Color(0xFF4CAF50).withOpacity(0.1)

                  : const Color(0xFF4CAF50).withOpacity(0.05),                  : const Color(0xFF4CAF50).withOpacity(0.05),

              borderRadius: const BorderRadius.only(              borderRadius: const BorderRadius.only(

                topLeft: Radius.circular(16),                topLeft: Radius.circular(16),

                topRight: Radius.circular(16),                topRight: Radius.circular(16),

              ),              ),

            ),            ),

            child: Row(            child: Row(

              children: [              children: [

                Container(                Container(

                  padding: const EdgeInsets.all(8),                  padding: const EdgeInsets.all(8),

                  decoration: BoxDecoration(                  decoration: BoxDecoration(

                    color: const Color(0xFF4CAF50).withOpacity(0.1),                    color: const Color(0xFF4CAF50).withOpacity(0.1),

                    borderRadius: BorderRadius.circular(12),                    borderRadius: BorderRadius.circular(12),

                  ),                  ),

                  child: const Icon(                  child: const Icon(

                    Icons.schedule_rounded,                    Icons.schedule_rounded,

                    color: Color(0xFF4CAF50),                    color: Color(0xFF4CAF50),

                    size: 20,                    size: 20,

                  ),                  ),

                ),                ),

                const SizedBox(width: 12),                const SizedBox(width: 12),

                Expanded(                Expanded(

                  child: Text(                  child: Text(

                    l10n.upcomingMedicines,                    l10n.upcomingMedicines,

                    style: Theme.of(context).textTheme.titleMedium?.copyWith(                    style: Theme.of(context).textTheme.titleMedium?.copyWith(

                      fontWeight: FontWeight.bold,                      fontWeight: FontWeight.bold,

                      color: Theme.of(context).brightness == Brightness.dark                      color: Theme.of(context).brightness == Brightness.dark

                          ? Colors.white                          ? Colors.white

                          : const Color(0xFF1B5E20),                          : const Color(0xFF1B5E20),

                    ),                    ),

                  ),                  ),

                ),                ),

              ],              ],

            ),            ),

          ),          ),

          // Content area          // Content area

          Padding(          Padding(

            padding: const EdgeInsets.all(16),            padding: const EdgeInsets.all(16),

            child: Column(            child: Column(

              crossAxisAlignment: CrossAxisAlignment.start,              crossAxisAlignment: CrossAxisAlignment.start,

              children: [              children: [

                Consumer2<HistoryProvider, MedicineProvider>(            Consumer2<HistoryProvider, MedicineProvider>(

                  builder: (context, historyProvider, medicineProvider, child) {              builder: (context, historyProvider, medicineProvider, child) {

                    final upcomingReminders = historyProvider.getUpcomingReminders();                final upcomingReminders = historyProvider.getUpcomingReminders();

                    final todaysLogs = historyProvider.getTodaysIntakeLogs();                final todaysLogs = historyProvider.getTodaysIntakeLogs();

                

                    if (upcomingReminders.isEmpty) {                if (upcomingReminders.isEmpty && todaysLogs.isEmpty) {

                      return _buildEmptyState(context, l10n);                  return _buildEmptyState(context);

                    }                }

                

                    // Sort by time and limit to next 3 medicines                // Show today's logs first, then upcoming

                    final sorted = [...upcomingReminders]                final displayLogs = [...todaysLogs, ...upcomingReminders.take(3)];

                      ..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));                

                    final nextMedicines = sorted.take(3).toList();                return Column(

                  children: displayLogs.take(5).map((log) {

                    return Column(                    final medicine = medicineProvider.getMedicineById(log.medicineId);

                      children: nextMedicines.map((log) {                    if (medicine == null) return const SizedBox.shrink();

                        final medicine = medicineProvider.getMedicine(log.medicineId);                    

                        if (medicine == null) return const SizedBox.shrink();                    return _buildMedicineItem(context, log, medicine);

                                          }).toList(),

                        return _buildMedicineItem(context, log, medicine);                );

                      }).toList(),              },

                    );            ),

                  },              ],

                ),            ),

              ],          ),

            ),        ],

          ),      ),

        ],    );

      ),  }

    );

  }  Widget _buildEmptyState(BuildContext context) {

    final l10n = AppLocalizations.of(context)!;

  Widget _buildEmptyState(BuildContext context, AppLocalizations l10n) {    

    return Column(    return Container(

      children: [      padding: const EdgeInsets.all(32),

        Container(      child: Column(

          padding: const EdgeInsets.all(20),        children: [

          decoration: BoxDecoration(          Container(

            color: const Color(0xFF4CAF50).withOpacity(0.1),            padding: const EdgeInsets.all(20),

            shape: BoxShape.circle,            decoration: BoxDecoration(

          ),              color: const Color(0xFF4CAF50).withOpacity(0.1),

          child: const Icon(              borderRadius: BorderRadius.circular(16),

            Icons.medication_liquid_rounded,            ),

            size: 48,            child: const Icon(

            color: Color(0xFF4CAF50),              Icons.medication_liquid_rounded,

          ),              size: 48,

        ),              color: Color(0xFF4CAF50),

        const SizedBox(height: 16),            ),

        Text(          ),

          l10n.noUpcomingMedicines,          const SizedBox(height: 16),

          style: Theme.of(context).textTheme.titleMedium?.copyWith(          Text(

            fontWeight: FontWeight.w600,            l10n.noUpcomingMedicines,

            color: Theme.of(context).colorScheme.onSurface,            style: Theme.of(context).textTheme.titleMedium?.copyWith(

          ),              fontWeight: FontWeight.w600,

        ),              color: Theme.of(context).colorScheme.onSurface,

        const SizedBox(height: 8),            ),

        Text(          ),

          l10n.addFirstMedicine,          const SizedBox(height: 8),

          style: Theme.of(context).textTheme.bodyMedium?.copyWith(          Text(

            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),            l10n.addFirstMedicine,

          ),            style: Theme.of(context).textTheme.bodyMedium?.copyWith(

          textAlign: TextAlign.center,              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),

        ),            ),

      ],            textAlign: TextAlign.center,

    );          ),

  }        ],

      ),

  Widget _buildMedicineItem(    );

    BuildContext context,  }

    IntakeLog log,

    Medicine medicine,  Widget _buildMedicineItem(

  ) {    BuildContext context,

    final isOverdue = log.scheduledAt.isBefore(DateTime.now()) &&     IntakeLog log,

                     log.status == IntakeStatus.scheduled;    Medicine medicine,

      ) {

    return Container(    final isOverdue = log.scheduledAt.isBefore(DateTime.now()) && 

      margin: const EdgeInsets.only(bottom: 12),                     log.status == IntakeStatus.scheduled;

      padding: const EdgeInsets.all(16),    

      decoration: BoxDecoration(    return Container(

        borderRadius: BorderRadius.circular(12),      margin: const EdgeInsets.only(bottom: 12),

        gradient: LinearGradient(      padding: const EdgeInsets.all(12),

          colors: [      decoration: BoxDecoration(

            _getStatusColor(context, log.status, isOverdue).withOpacity(0.05),        color: _getStatusColor(context, log.status, isOverdue).withOpacity(0.1),

            _getStatusColor(context, log.status, isOverdue).withOpacity(0.02),        borderRadius: BorderRadius.circular(8),

          ],        border: Border.all(

          begin: Alignment.topLeft,          color: _getStatusColor(context, log.status, isOverdue).withOpacity(0.3),

          end: Alignment.bottomRight,          width: 1,

        ),        ),

        border: Border.all(      ),

          color: _getStatusColor(context, log.status, isOverdue).withOpacity(0.3),      child: Padding(

          width: 1,        padding: const EdgeInsets.all(12),

        ),        child: Row(

      ),          children: [

      child: Row(            // Enhanced Medicine Image

        children: [            Container(

          // Enhanced Medicine Image              width: 70,

          Container(              height: 70,

            width: 70,              decoration: BoxDecoration(

            height: 70,                borderRadius: BorderRadius.circular(12),

            decoration: BoxDecoration(                boxShadow: [

              borderRadius: BorderRadius.circular(12),                  BoxShadow(

              boxShadow: [                    color: _getStatusColor(context, log.status, isOverdue).withOpacity(0.2),

                BoxShadow(                    spreadRadius: 1,

                  color: _getStatusColor(context, log.status, isOverdue).withOpacity(0.2),                    blurRadius: 4,

                  spreadRadius: 1,                    offset: const Offset(0, 2),

                  blurRadius: 4,                  ),

                  offset: const Offset(0, 2),                ],

                ),              ),

              ],              child: medicine.imagePath != null && File(medicine.imagePath!).existsSync()

            ),                  ? Hero(

            child: medicine.imagePath != null && File(medicine.imagePath!).existsSync()                      tag: 'upcoming_${log.id}',

                ? Hero(                      child: ClipRRect(

                    tag: 'upcoming_${log.id}',                        borderRadius: BorderRadius.circular(12),

                    child: ClipRRect(                        child: Image.file(

                      borderRadius: BorderRadius.circular(12),                          File(medicine.imagePath!),

                      child: Image.file(                          fit: BoxFit.cover,

                        File(medicine.imagePath!),                          width: 70,

                        fit: BoxFit.cover,                          height: 70,

                        width: 70,                        ),

                        height: 70,                      ),

                      ),                    )

                    ),                  : Container(

                  )                      decoration: BoxDecoration(

                : Container(                        color: _getStatusColor(context, log.status, isOverdue).withOpacity(0.1),

                    decoration: BoxDecoration(                        borderRadius: BorderRadius.circular(12),

                      color: _getStatusColor(context, log.status, isOverdue).withOpacity(0.1),                        border: Border.all(

                      borderRadius: BorderRadius.circular(12),                          color: _getStatusColor(context, log.status, isOverdue).withOpacity(0.3),

                      border: Border.all(                          width: 2,

                        color: _getStatusColor(context, log.status, isOverdue).withOpacity(0.3),                        ),

                        width: 2,                      ),

                      ),                      child: Icon(

                    ),                        _getStatusIcon(log.status, isOverdue),

                    child: Icon(                        color: _getStatusColor(context, log.status, isOverdue),

                      _getStatusIcon(log.status, isOverdue),                        size: 32,

                      color: _getStatusColor(context, log.status, isOverdue),                      ),

                      size: 32,                    ),

                    ),          ),

                  ),          const SizedBox(width: 16),

          ),          Expanded(

          const SizedBox(width: 16),            child: Column(

          Expanded(              crossAxisAlignment: CrossAxisAlignment.start,

            child: Column(              children: [

              crossAxisAlignment: CrossAxisAlignment.start,                Text(

              children: [                  medicine.name,

                Text(                  style: Theme.of(context).textTheme.titleMedium?.copyWith(

                  medicine.name,                    fontWeight: FontWeight.bold,

                  style: Theme.of(context).textTheme.titleMedium?.copyWith(                    color: Theme.of(context).colorScheme.onSurface,

                    fontWeight: FontWeight.bold,                  ),

                    color: Theme.of(context).colorScheme.onSurface,                  maxLines: 2,

                  ),                  overflow: TextOverflow.ellipsis,

                  maxLines: 2,                ),

                  overflow: TextOverflow.ellipsis,                const SizedBox(height: 4),

                ),                Container(

                const SizedBox(height: 4),                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),

                Container(                  decoration: BoxDecoration(

                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),

                  decoration: BoxDecoration(                    borderRadius: BorderRadius.circular(6),

                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),                  ),

                    borderRadius: BorderRadius.circular(6),                  child: Text(

                  ),                    medicine.dose,

                  child: Text(                    style: Theme.of(context).textTheme.bodySmall?.copyWith(

                    medicine.dose,                      color: Theme.of(context).colorScheme.primary,

                    style: Theme.of(context).textTheme.bodySmall?.copyWith(                      fontWeight: FontWeight.w600,

                      color: Theme.of(context).colorScheme.primary,                    ),

                      fontWeight: FontWeight.w600,                  ),

                    ),                ),

                  ),                const SizedBox(height: 6),

                ),                Row(

                const SizedBox(height: 6),                  children: [

                Row(                    Icon(

                  children: [                      Icons.schedule,

                    Icon(                      size: 16,

                      Icons.schedule,                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),

                      size: 16,                    ),

                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),                    const SizedBox(width: 4),

                    ),                    Text(

                    const SizedBox(width: 4),                      TimeUtils.format12Hour(log.scheduledAt),

                    Text(                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(

                      TimeUtils.format12Hour(log.scheduledAt),                        color: _getStatusColor(context, log.status, isOverdue),

                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(                        fontWeight: FontWeight.w600,

                        color: _getStatusColor(context, log.status, isOverdue),                      ),

                        fontWeight: FontWeight.w600,                    ),

                      ),                  ],

                    ),                ),

                  ],                if (medicine.isLowStock) ...[

                ),                  const SizedBox(height: 4),

                if (medicine.isLowStock) ...[                  Row(

                  const SizedBox(height: 4),                    children: [

                  Row(                      Icon(

                    children: [                        Icons.warning_amber_rounded,

                      const Icon(                        size: 16,

                        Icons.warning_amber_rounded,                        color: Colors.orange,

                        size: 16,                      ),

                        color: Colors.orange,                      const SizedBox(width: 4),

                      ),                      Text(

                      const SizedBox(width: 4),                        '${AppLocalizations.of(context)!.lowStock}: ${medicine.currentStock ?? 0}',

                      Text(                        style: Theme.of(context).textTheme.bodySmall?.copyWith(

                        '${AppLocalizations.of(context)!.lowStock}: ${medicine.currentStock ?? 0}',                          color: Colors.orange,

                        style: Theme.of(context).textTheme.bodySmall?.copyWith(                          fontWeight: FontWeight.w500,

                          color: Colors.orange,                        ),

                          fontWeight: FontWeight.w500,                      ),

                        ),                    ],

                      ),                  ),

                    ],                ],

                  ),              ],

                ],            ),

              ],          ),

            ),          Column(

          ),            crossAxisAlignment: CrossAxisAlignment.end,

          Column(            children: [

            crossAxisAlignment: CrossAxisAlignment.end,              Container(

            children: [                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),

              Container(                decoration: BoxDecoration(

                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),                  color: _getStatusColor(context, log.status, isOverdue).withOpacity(0.1),

                decoration: BoxDecoration(                  borderRadius: BorderRadius.circular(6),

                  color: _getStatusColor(context, log.status, isOverdue).withOpacity(0.1),                  border: Border.all(

                  borderRadius: BorderRadius.circular(6),                    color: _getStatusColor(context, log.status, isOverdue).withOpacity(0.3),

                  border: Border.all(                    width: 1,

                    color: _getStatusColor(context, log.status, isOverdue).withOpacity(0.3),                  ),

                    width: 1,                ),

                  ),                child: Text(

                ),                  _getStatusText(context, log.status, isOverdue),

                child: Text(                  style: Theme.of(context).textTheme.bodySmall?.copyWith(

                  _getStatusText(context, log.status, isOverdue),                    color: _getStatusColor(context, log.status, isOverdue),

                  style: Theme.of(context).textTheme.bodySmall?.copyWith(                    fontWeight: FontWeight.w600,

                    color: _getStatusColor(context, log.status, isOverdue),                  ),

                    fontWeight: FontWeight.w600,                ),

                  ),              ),

                ),              ),

              ),              if (log.status == IntakeStatus.scheduled) ...[

              if (log.status == IntakeStatus.scheduled) ...[                const SizedBox(height: 12),

                const SizedBox(height: 12),                Row(

                Row(                  mainAxisSize: MainAxisSize.min,

                  mainAxisSize: MainAxisSize.min,                  children: [

                  children: [                    // Mark Taken button with enhanced styling

                    // Mark Taken button with enhanced styling                    Container(

                    Container(                      decoration: BoxDecoration(

                      decoration: BoxDecoration(                        color: const Color(0xFF4CAF50).withOpacity(0.15),

                        color: const Color(0xFF4CAF50).withOpacity(0.15),                        borderRadius: BorderRadius.circular(10),

                        borderRadius: BorderRadius.circular(10),                        border: Border.all(

                        border: Border.all(                          color: const Color(0xFF4CAF50).withOpacity(0.4),

                          color: const Color(0xFF4CAF50).withOpacity(0.4),                          width: 1.5,

                          width: 1.5,                        ),

                        ),                        boxShadow: [

                        boxShadow: [                          BoxShadow(

                          BoxShadow(                            color: const Color(0xFF4CAF50).withOpacity(0.2),

                            color: const Color(0xFF4CAF50).withOpacity(0.2),                            spreadRadius: 1,

                            spreadRadius: 1,                            blurRadius: 3,

                            blurRadius: 3,                            offset: const Offset(0, 1),

                            offset: const Offset(0, 1),                          ),

                          ),                        ],

                        ],                      ),

                      ),                      child: InkWell(

                      child: InkWell(                        onTap: () => _handleAction(context, log, 'taken'),

                        onTap: () => _handleAction(context, log, 'taken'),                        borderRadius: BorderRadius.circular(10),

                        borderRadius: BorderRadius.circular(10),                        child: const Padding(

                        child: const Padding(                          padding: EdgeInsets.all(10),

                          padding: EdgeInsets.all(10),                          child: Icon(

                          child: Icon(                            Icons.check_rounded,

                            Icons.check_rounded,                            color: Color(0xFF4CAF50),

                            color: Color(0xFF4CAF50),                            size: 20,

                            size: 20,                          ),

                          ),                        ),

                        ),                      ),

                      ),                    ),

                    ),                    const SizedBox(width: 10),

                    const SizedBox(width: 10),                    // Mark Skipped button with enhanced styling  

                    // Mark Skipped button with enhanced styling                      Container(

                    Container(                      decoration: BoxDecoration(

                      decoration: BoxDecoration(                        color: Colors.orange.withOpacity(0.15),

                        color: Colors.orange.withOpacity(0.15),                        borderRadius: BorderRadius.circular(10),

                        borderRadius: BorderRadius.circular(10),                        border: Border.all(

                        border: Border.all(                          color: Colors.orange.withOpacity(0.4),

                          color: Colors.orange.withOpacity(0.4),                          width: 1.5,

                          width: 1.5,                        ),

                        ),                        boxShadow: [

                        boxShadow: [                          BoxShadow(

                          BoxShadow(                            color: Colors.orange.withOpacity(0.2),

                            color: Colors.orange.withOpacity(0.2),                            spreadRadius: 1,

                            spreadRadius: 1,                            blurRadius: 3,

                            blurRadius: 3,                            offset: const Offset(0, 1),

                            offset: const Offset(0, 1),                          ),

                          ),                        ],

                        ],                      ),

                      ),                      child: InkWell(

                      child: InkWell(                        onTap: () => _handleAction(context, log, 'skip'),

                        onTap: () => _handleAction(context, log, 'skip'),                        borderRadius: BorderRadius.circular(10),

                        borderRadius: BorderRadius.circular(10),                        child: const Padding(

                        child: const Padding(                          padding: EdgeInsets.all(10),

                          padding: EdgeInsets.all(10),                          child: Icon(

                          child: Icon(                            Icons.close_rounded,

                            Icons.close_rounded,                            color: Colors.orange,

                            color: Colors.orange,                            size: 20,

                            size: 20,                          ),

                          ),                        ),

                        ),                      ),

                      ),                    ),

                    ),                  ],

                  ],                ),

                ),              ],

              ],            ),

            ],          ),

          ),        ],

        ],      ),

      ),    );

    );    );

  }  }



  Color _getStatusColor(BuildContext context, IntakeStatus status, bool isOverdue) {  Color _getStatusColor(BuildContext context, IntakeStatus status, bool isOverdue) {

    if (isOverdue) return Colors.red;    if (isOverdue) return Colors.red;

        

    switch (status) {    switch (status) {

      case IntakeStatus.taken:      case IntakeStatus.taken:

        return Colors.green;        return Colors.green;

      case IntakeStatus.skipped:      case IntakeStatus.missed:

        return Colors.orange;        return Colors.red;

      case IntakeStatus.scheduled:      case IntakeStatus.snoozed:

        return Theme.of(context).colorScheme.primary;        return Colors.orange;

    }      case IntakeStatus.scheduled:

  }        return Theme.of(context).colorScheme.primary;

    }

  IconData _getStatusIcon(IntakeStatus status, bool isOverdue) {  }

    if (isOverdue) return Icons.schedule_rounded;

      IconData _getStatusIcon(IntakeStatus status, bool isOverdue) {

    switch (status) {    if (isOverdue) return Icons.warning;

      case IntakeStatus.taken:    

        return Icons.check_circle_outline;    switch (status) {

      case IntakeStatus.skipped:      case IntakeStatus.taken:

        return Icons.close_rounded;        return Icons.check_circle;

      case IntakeStatus.scheduled:      case IntakeStatus.missed:

        return Icons.schedule_rounded;        return Icons.cancel;

    }      case IntakeStatus.snoozed:

  }        return Icons.snooze;

      case IntakeStatus.scheduled:

  String _getStatusText(BuildContext context, IntakeStatus status, bool isOverdue) {        return Icons.schedule;

    final l10n = AppLocalizations.of(context)!;    }

      }

    if (isOverdue) return l10n.overdue;

      String _getStatusText(BuildContext context, IntakeStatus status, bool isOverdue) {

    switch (status) {    final l10n = AppLocalizations.of(context)!;

      case IntakeStatus.taken:    if (isOverdue) return l10n.overdue;

        return l10n.taken;    

      case IntakeStatus.skipped:    switch (status) {

        return l10n.skipped;      case IntakeStatus.taken:

      case IntakeStatus.scheduled:        return l10n.taken;

        return l10n.scheduled;      case IntakeStatus.missed:

    }        return l10n.missed;

  }      case IntakeStatus.snoozed:

        return l10n.snoozed;

  void _handleAction(BuildContext context, IntakeLog log, String action) {      case IntakeStatus.scheduled:

    final historyProvider = Provider.of<HistoryProvider>(context, listen: false);        return l10n.scheduled;

    final medicineProvider = Provider.of<MedicineProvider>(context, listen: false);    }

      }

    if (action == 'taken') {

      historyProvider.markMedicineTaken(log.id);  void _handleAction(BuildContext context, IntakeLog log, String action) {

      final medicine = medicineProvider.getMedicine(log.medicineId);    final historyProvider = Provider.of<HistoryProvider>(context, listen: false);

      if (medicine != null && medicine.currentStock != null) {    final l10n = AppLocalizations.of(context)!;

        medicineProvider.updateMedicineStock(    

          medicine.id,    // Store the previous status for undo functionality

          medicine.currentStock! - 1,    final previousStatus = log.status;

        );    

      }    switch (action) {

            case 'taken':

      ScaffoldMessenger.of(context).showSnackBar(        historyProvider.markIntakeTaken(log.id);

        SnackBar(        ScaffoldMessenger.of(context).showSnackBar(

          content: Text(AppLocalizations.of(context)!.medicineTaken),          SnackBar(

          backgroundColor: Colors.green,            content: Text(l10n.medicineMarkedTaken),

          duration: const Duration(seconds: 2),            action: SnackBarAction(

        ),              label: l10n.undo,

      );              onPressed: () {

    } else if (action == 'skip') {                // Revert to previous status

      historyProvider.markMedicineSkipped(log.id);                if (previousStatus == IntakeStatus.scheduled) {

                        historyProvider.markIntakeScheduled(log.id);

      ScaffoldMessenger.of(context).showSnackBar(                }

        SnackBar(              },

          content: Text(AppLocalizations.of(context)!.medicineSkipped),            ),

          backgroundColor: Colors.orange,            duration: const Duration(seconds: 4),

          duration: const Duration(seconds: 2),          ),

        ),        );

      );        break;

    }      case 'skip':

  }        historyProvider.markIntakeMissed(log.id);

}        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.medicineMarkedSkipped),
            action: SnackBarAction(
              label: l10n.undo,
              onPressed: () {
                // Revert to previous status
                if (previousStatus == IntakeStatus.scheduled) {
                  historyProvider.markIntakeScheduled(log.id);
                }
              },
            ),
            duration: const Duration(seconds: 4),
          ),
        );
        break;
    }
  }
}