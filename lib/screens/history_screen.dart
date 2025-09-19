import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/history_provider.dart';
import '../providers/medicine_provider.dart';
import '../models/intake_log.dart';
import '../l10n/app_localizations.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.history),
        actions: [
          PopupMenuButton<int>(
            onSelected: (period) {
              Provider.of<HistoryProvider>(context, listen: false).setSelectedPeriod(period);
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: 7, child: Text(l10n.last7Days)),
              PopupMenuItem(value: 30, child: Text(l10n.last30Days)),
              PopupMenuItem(value: 90, child: Text(l10n.last90Days)),
            ],
            child: const Icon(Icons.filter_list),
          ),
        ],
      ),
      body: Consumer2<HistoryProvider, MedicineProvider>(
        builder: (context, historyProvider, medicineProvider, child) {
          final intakeLogs = historyProvider.filteredIntakeLogs;
          final waterLogs = historyProvider.filteredWaterLogs;
          
          return DefaultTabController(
            length: 2,
            child: Column(
              children: [
                TabBar(
                  tabs: [
                    Tab(text: l10n.medicineHistory, icon: const Icon(Icons.medication)),
                    Tab(text: l10n.waterHistory, icon: const Icon(Icons.water_drop)),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      _buildMedicineHistory(context, l10n, intakeLogs, medicineProvider),
                      _buildWaterHistory(context, l10n, waterLogs),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMedicineHistory(
    BuildContext context,
    AppLocalizations l10n, 
    List<IntakeLog> logs,
    MedicineProvider medicineProvider,
  ) {
    if (logs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.history, size: 64),
            const SizedBox(height: 16),
            Text(l10n.noMedicineHistoryYet),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: logs.length,
      itemBuilder: (context, index) {
        final log = logs[index];
        final medicine = medicineProvider.getMedicineById(log.medicineId);
        
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: _getStatusColor(log.status).withOpacity(0.1),
              child: Text(
                log.status.emoji,
                style: const TextStyle(fontSize: 18),
              ),
            ),
            title: Text(medicine?.name ?? l10n.unknownMedicine),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${l10n.doseLabel} ${medicine?.dose ?? l10n.unknownDose}'),
                Text('${l10n.scheduledLabel} ${DateFormat('MMM d, HH:mm').format(log.scheduledAt)}'),
                if (log.actualAt != null)
                  Text('${l10n.actualLabel} ${DateFormat('MMM d, HH:mm').format(log.actualAt!)}'),
              ],
            ),
            trailing: Chip(
              label: Text(
                log.status.displayName(context),
                style: TextStyle(
                  color: _getStatusColor(log.status),
                  fontWeight: FontWeight.w600,
                ),
              ),
              backgroundColor: _getStatusColor(log.status).withOpacity(0.1),
            ),
          ),
        );
      },
    );
  }

  Widget _buildWaterHistory(BuildContext context, AppLocalizations l10n, List logs) {
    if (logs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.water_drop_outlined, size: 64),
            const SizedBox(height: 16),
            Text(l10n.noWaterHistoryYet),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: logs.length,
      itemBuilder: (context, index) {
        final log = logs[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue.withOpacity(0.1),
              child: const Icon(Icons.water_drop, color: Colors.blue),
            ),
            title: Text(DateFormat('EEEE, MMM d').format(log.date)),
            subtitle: Text('${log.glassesTaken} ${l10n.ofGlasses} ${log.target} ${l10n.glassesText}'),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: log.isTargetReached ? Colors.green : Colors.orange,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${(log.progressPercentage * 100).round()}%',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Color _getStatusColor(IntakeStatus status) {
    switch (status) {
      case IntakeStatus.taken:
        return Colors.green;
      case IntakeStatus.missed:
        return Colors.red;
      case IntakeStatus.snoozed:
        return Colors.orange;
      case IntakeStatus.scheduled:
        return Colors.blue;
    }
  }
}