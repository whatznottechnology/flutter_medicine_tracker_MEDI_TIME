import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/history_provider.dart';
import '../l10n/app_localizations.dart';

class AdherenceCard extends StatelessWidget {
  const AdherenceCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.adherenceOverviewTitle,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(
                  Icons.analytics,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Consumer<HistoryProvider>(
              builder: (context, historyProvider, child) {
                final medicineAdherence = historyProvider.getMedicineAdherenceRate();
                final waterCompliance = historyProvider.getWaterComplianceRate();
                final streakDays = historyProvider.getStreakDays();
                
                return Column(
                  children: [
                    _buildAdherenceItem(
                      context,
                      l10n.medicineAdherenceTitle,
                      medicineAdherence,
                      Icons.medication,
                      Colors.green,
                    ),
                    const SizedBox(height: 12),
                    _buildAdherenceItem(
                      context,
                      l10n.waterGoalAchievementTitle,
                      waterCompliance,
                      Icons.water_drop,
                      Colors.blue,
                    ),
                    const SizedBox(height: 16),
                    _buildStreakInfo(context, streakDays),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdherenceItem(
    BuildContext context,
    String title,
    double percentage,
    IconData icon,
    Color color,
  ) {
    final percentageText = '${(percentage * 100).round()}%';
    
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              LinearProgressIndicator(
                value: percentage,
                backgroundColor: color.withOpacity(0.1),
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _getAdherenceColor(percentage).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _getAdherenceColor(percentage).withOpacity(0.3),
            ),
          ),
          child: Text(
            percentageText,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: _getAdherenceColor(percentage),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStreakInfo(BuildContext context, int streakDays) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: streakDays > 0 
            ? Colors.orange.withOpacity(0.1)
            : Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: streakDays > 0 
              ? Colors.orange.withOpacity(0.3)
              : Theme.of(context).colorScheme.outline.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.local_fire_department,
            color: streakDays > 0 ? Colors.orange : Theme.of(context).colorScheme.onSurfaceVariant,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.waterGoalStreakTitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  streakDays > 0 
                      ? '$streakDays ${l10n.consecutiveDays}'
                      : l10n.startStreakTodayText,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          if (streakDays > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$streakDays',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Color _getAdherenceColor(double percentage) {
    if (percentage >= 0.8) return Colors.green;
    if (percentage >= 0.6) return Colors.orange;
    return Colors.red;
  }
}