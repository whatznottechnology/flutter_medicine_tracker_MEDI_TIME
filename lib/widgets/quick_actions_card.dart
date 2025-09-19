import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/water_provider.dart';
import '../screens/add_medicine_screen.dart';
import '../l10n/app_localizations.dart';

class QuickActionsCard extends StatelessWidget {
  const QuickActionsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.quickActions,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    context,
                    icon: Icons.medication,
                    label: l10n.addMedicine,
                    color: Theme.of(context).colorScheme.primary,
                    onTap: () => _navigateToAddMedicine(context),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Consumer<WaterProvider>(
                    builder: (context, waterProvider, child) {
                      return _buildActionButton(
                        context,
                        icon: Icons.water_drop,
                        label: l10n.logWater,
                        color: Colors.blue,
                        onTap: () => _logWater(context, waterProvider),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToAddMedicine(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddMedicineScreen()),
    );
  }

  void _logWater(BuildContext context, WaterProvider waterProvider) {
    final l10n = AppLocalizations.of(context)!;
    waterProvider.addWaterGlass();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${l10n.waterLogged} ${waterProvider.todayGlasses}/${waterProvider.todayTarget} ${l10n.glasses}'),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: l10n.undo,
          onPressed: () => waterProvider.removeWaterGlass(),
        ),
      ),
    );
  }
}