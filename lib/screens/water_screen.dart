import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/water_provider.dart';
import '../widgets/water_progress_card.dart';
import '../l10n/app_localizations.dart';

class WaterScreen extends StatelessWidget {
  const WaterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.waterTracker),
      ),
      body: Consumer<WaterProvider>(
        builder: (context, waterProvider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const WaterProgressCard(),
                const SizedBox(height: 24),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.quickActionsTitle,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  waterProvider.addWaterGlass();
                                  _showSnackBar(context, l10n.glassAdded);
                                },
                                icon: const Icon(Icons.add),
                                label: Text(l10n.addGlassButton),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: waterProvider.todayGlasses > 0 ? () {
                                  waterProvider.removeWaterGlass();
                                  _showSnackBar(context, l10n.glassRemoved);
                                } : null,
                                icon: const Icon(Icons.remove),
                                label: Text(l10n.removeButton),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () => _showTargetDialog(context, waterProvider),
                            icon: const Icon(Icons.edit),
                            label: Text(l10n.changeTargetButton),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  void _showTargetDialog(BuildContext context, WaterProvider waterProvider) {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController(text: waterProvider.todayTarget.toString());
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.setWaterTarget),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: l10n.glassesPerDayLabel,
            suffixText: l10n.glassesUnit,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              final newTarget = int.tryParse(controller.text);
              if (newTarget != null && newTarget > 0) {
                waterProvider.setWaterTarget(newTarget);
                Navigator.pop(context);
              }
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }
}