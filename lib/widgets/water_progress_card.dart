import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/water_provider.dart';
import '../l10n/app_localizations.dart';

class WaterProgressCard extends StatelessWidget {
  const WaterProgressCard({super.key});

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
                  l10n.waterIntake,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Icon(
                  Icons.water_drop,
                  color: Colors.blue,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Consumer<WaterProvider>(
              builder: (context, waterProvider, child) {
                return Column(
                  children: [
                    // Circular progress indicator
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 120,
                          height: 120,
                          child: CircularProgressIndicator(
                            value: waterProvider.todayProgress,
                            strokeWidth: 8,
                            backgroundColor: Colors.blue.withOpacity(0.1),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              waterProvider.isTargetReached ? Colors.green : Colors.blue,
                            ),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.water_drop,
                              color: waterProvider.isTargetReached ? Colors.green : Colors.blue,
                              size: 32,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${waterProvider.todayGlasses}',
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: waterProvider.isTargetReached ? Colors.green : Colors.blue,
                              ),
                            ),
                            Text(
                              '${l10n.ofTarget} ${waterProvider.todayTarget}',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Progress text
                    Text(
                      '${(waterProvider.todayProgress * 100).round()}${l10n.percentOfDailyGoal}',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: waterProvider.isTargetReached ? Colors.green : null,
                      ),
                    ),
                    if (waterProvider.isTargetReached) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.green.withOpacity(0.3)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              l10n.goalAchieved,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.green,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: waterProvider.isLoading ? null : () {
                              waterProvider.addWaterGlass();
                              _showWaterLoggedSnackBar(context, waterProvider);
                            },
                            icon: const Icon(Icons.add),
                            label: Text(l10n.addGlass),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        if (waterProvider.todayGlasses > 0)
                          IconButton(
                            onPressed: waterProvider.isLoading ? null : () {
                              waterProvider.removeWaterGlass();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(l10n.removedOneGlass),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            },
                            icon: const Icon(Icons.remove),
                            tooltip: l10n.removeLastGlass,
                          ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showWaterLoggedSnackBar(BuildContext context, WaterProvider waterProvider) {
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${l10n.waterLogged} ${waterProvider.todayGlasses}/${waterProvider.todayTarget} ${l10n.glasses}',
        ),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: l10n.undo,
          onPressed: () => waterProvider.removeWaterGlass(),
        ),
      ),
    );
  }
}