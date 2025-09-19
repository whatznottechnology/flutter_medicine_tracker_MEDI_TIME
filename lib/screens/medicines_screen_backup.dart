import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../l10n/app_localizations.dart';
import '../providers/medicine_provider.dart';
import '../models/medicine.dart';
import 'add_medicine_screen.dart';

class MedicinesScreen extends StatelessWidget {
  const MedicinesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.medicines),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _navigateToAddMedicine(context),
          ),
        ],
      ),
      body: Consumer<MedicineProvider>(
        builder: (context, medicineProvider, child) {
          if (medicineProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (medicineProvider.error != null) {
            return Center(
              child: Container(
                margin: const EdgeInsets.all(24),
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.red.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.error_outline_rounded,
                        size: 48,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.somethingWentWrong,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Error: ${medicineProvider.error}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () => medicineProvider.clearError(),
                      icon: const Icon(Icons.refresh_rounded),
                      label: Text(l10n.tryAgain),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final medicines = medicineProvider.activeMedicines;

          if (medicines.isEmpty) {
            return _buildEmptyState(context);
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: medicines.length,
            itemBuilder: (context, index) {
              final medicine = medicines[index];
              return _buildMedicineCard(context, medicine, medicineProvider);
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.medication_outlined,
              size: 80,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 24),
            Text(
              l10n.noMedicinesAdded,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              l10n.addYourFirstMedicine,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => _navigateToAddMedicine(context),
              icon: const Icon(Icons.add),
              label: Text(l10n.addMedicine),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicineCard(
    BuildContext context,
    Medicine medicine,
    MedicineProvider medicineProvider,
  ) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => _showMedicineDetails(context, medicine),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                Theme.of(context).cardColor,
                Theme.of(context).cardColor.withOpacity(0.95),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Enhanced Medicine Image or Icon
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: medicine.imagePath != null && File(medicine.imagePath!).existsSync()
                          ? Hero(
                              tag: 'medicine_${medicine.id}',
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.file(
                                  File(medicine.imagePath!),
                                  fit: BoxFit.cover,
                                  width: 80,
                                  height: 80,
                                ),
                              ),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Icon(
                                _getMedicineIcon(medicine.form),
                                color: Theme.of(context).colorScheme.primary,
                                size: 36,
                              ),
                            ),
                    ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          medicine.name,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${medicine.dose} • ${medicine.form.displayName(context)}',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        // Stock information with enhanced styling
                        if (medicine.currentStock != null)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: medicine.isLowStock 
                                  ? Colors.orange.withOpacity(0.1)
                                  : Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: medicine.isLowStock 
                                    ? Colors.orange.withOpacity(0.3)
                                    : Colors.green.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  medicine.isLowStock 
                                    ? Icons.warning_amber_rounded
                                    : Icons.inventory_2_outlined,
                                  size: 16,
                                  color: medicine.isLowStock 
                                    ? Colors.orange
                                    : Colors.green,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  medicine.stockDisplayText,
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: medicine.isLowStock 
                                      ? Colors.orange
                                      : Colors.green,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) => _handleMenuAction(
                      context,
                      medicine,
                      medicineProvider,
                      value,
                    ),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            const Icon(Icons.edit),
                            const SizedBox(width: 8),
                            Text(l10n.edit),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            const Icon(Icons.delete, color: Colors.red),
                            const SizedBox(width: 8),
                            Text(l10n.delete),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // Enhanced Schedule Times Section
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.schedule_rounded,
                          size: 16,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          l10n.timing,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: medicine.scheduleTimes.map((time) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 14,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                time,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    if (medicine.relationToFood != FoodRelation.independent) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.restaurant,
                            size: 14,
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            medicine.relationToFood.displayName(context),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              if (medicine.notes?.isNotEmpty == true) ...[
                const SizedBox(height: 8),
                Text(
                  medicine.notes!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getMedicineIcon(MedicineForm form) {
    switch (form) {
      case MedicineForm.tablet:
        return Icons.medication;
      case MedicineForm.capsule:
        return Icons.medication_liquid;
      case MedicineForm.liquid:
        return Icons.opacity;
      case MedicineForm.injection:
        return Icons.healing;
      case MedicineForm.drops:
        return Icons.water_drop;
      case MedicineForm.cream:
        return Icons.healing;
      case MedicineForm.spray:
        return Icons.air;
      case MedicineForm.powder:
        return Icons.grain;
      case MedicineForm.other:
        return Icons.medical_services;
    }
  }

  void _navigateToAddMedicine(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddMedicineScreen()),
    );
  }

  void _showMedicineDetails(BuildContext context, Medicine medicine) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(medicine.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${l10n.dose}: ${medicine.dose}'),
            Text('${l10n.medicineForm}: ${medicine.form.displayName(context)}'),
            Text('${l10n.relationToFood}: ${medicine.relationToFood.displayName(context)}'),
            const SizedBox(height: 8),
            Text('${l10n.timing}:'),
            ...medicine.scheduleTimes.map((time) => Text('• $time')),
            if (medicine.notes?.isNotEmpty == true) ...[
              const SizedBox(height: 8),
              Text('Notes: ${medicine.notes}'),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.close),
          ),
        ],
      ),
    );
  }

  void _handleMenuAction(
    BuildContext context,
    Medicine medicine,
    MedicineProvider medicineProvider,
    String action,
  ) {
    switch (action) {
      case 'edit':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AddMedicineScreen(medicine: medicine),
          ),
        );
        break;
      case 'delete':
        _showDeleteConfirmation(context, medicine, medicineProvider);
        break;
    }
  }

  void _showDeleteConfirmation(
    BuildContext context,
    Medicine medicine,
    MedicineProvider medicineProvider,
  ) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteMedicine),
        content: Text('Are you sure you want to delete ${medicine.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              medicineProvider.deleteMedicine(medicine.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${medicine.name} deleted')),
              );
            },
            child: Text(l10n.delete, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}