import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../models/settings.dart';
import '../utils/time_utils.dart';
import '../l10n/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
      ),
      body: Consumer<SettingsProvider>(
        builder: (context, settingsProvider, child) {
          final settings = settingsProvider.settings;
          
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildLanguageSection(context, settingsProvider),
              const SizedBox(height: 24),
              _buildMealTimesSection(context, settings, settingsProvider),
              const SizedBox(height: 24),
              _buildNotificationSection(context, settings, settingsProvider),
              const SizedBox(height: 24),
              _buildWaterSection(context, settings, settingsProvider),
              const SizedBox(height: 24),
              _buildDataSection(context, settingsProvider),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMealTimesSection(
    BuildContext context,
    Settings settings,
    SettingsProvider provider,
  ) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.restaurant_menu_rounded,
                    color: Theme.of(context).colorScheme.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  l10n.setMealTimes,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              l10n.setMealTimesDescription,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 20),
            _buildEnhancedMealTimeItem(context, l10n.breakfast, settings.mealTimes.breakfast, 
              Icons.free_breakfast_rounded, const Color(0xFFFF9800), () {
              _editMealTime(context, 'breakfast', settings.mealTimes.breakfast, (time) {
                final newMealTimes = settings.mealTimes.copyWith(breakfast: time);
                provider.updateMealTimes(newMealTimes);
              });
            }),
            const SizedBox(height: 12),
            _buildEnhancedMealTimeItem(context, l10n.lunch, settings.mealTimes.lunch, 
              Icons.lunch_dining_rounded, const Color(0xFF4CAF50), () {
              _editMealTime(context, 'lunch', settings.mealTimes.lunch, (time) {
                final newMealTimes = settings.mealTimes.copyWith(lunch: time);
                provider.updateMealTimes(newMealTimes);
              });
            }),
            const SizedBox(height: 12),
            _buildEnhancedMealTimeItem(context, l10n.dinner, settings.mealTimes.dinner, 
              Icons.dinner_dining_rounded, const Color(0xFF9C27B0), () {
              _editMealTime(context, 'dinner', settings.mealTimes.dinner, (time) {
                final newMealTimes = settings.mealTimes.copyWith(dinner: time);
                provider.updateMealTimes(newMealTimes);
              });
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildEnhancedMealTimeItem(BuildContext context, String label, String time, IconData icon, Color color, VoidCallback onTap) {
    final formattedTime = TimeUtils.formatTimeString12Hour(time);
    
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
        color: color.withOpacity(0.05),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        title: Text(
          label,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
        subtitle: Row(
          children: [
            Icon(
              Icons.access_time_rounded,
              size: 16,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
            const SizedBox(width: 4),
            Text(
              formattedTime,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        trailing: Container(
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(8),
          child: Icon(
            Icons.edit_rounded,
            color: color,
            size: 20,
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildMealTimeItem(BuildContext context, String label, String time, VoidCallback onTap) {
    // Convert 24-hour format to 12-hour format
    final formattedTime = TimeUtils.formatTimeString12Hour(time);
    
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        _getMealIcon(label),
        color: Theme.of(context).colorScheme.primary,
      ),
      title: Text(
        label,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        formattedTime,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(8),
        child: Icon(
          Icons.edit_rounded,
          color: Theme.of(context).colorScheme.primary,
          size: 20,
        ),
      ),
      onTap: onTap,
    );
  }

  IconData _getMealIcon(String mealName) {
    switch (mealName.toLowerCase()) {
      case 'breakfast':
        return Icons.free_breakfast_rounded;
      case 'lunch':
        return Icons.lunch_dining_rounded;
      case 'dinner':
        return Icons.dinner_dining_rounded;
      default:
        return Icons.schedule_rounded;
    }
  }

  Widget _buildNotificationSection(
    BuildContext context,
    Settings settings,
    SettingsProvider provider,
  ) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.notifications,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.enableNotifications),
              subtitle: Text(l10n.medicineWaterReminders),
              value: settings.notificationsEnabled,
              onChanged: provider.toggleNotifications,
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.sound),
              subtitle: Text(l10n.playSoundNotifications),
              value: settings.soundEnabled,
              onChanged: settings.notificationsEnabled ? provider.toggleSound : null,
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.vibration),
              subtitle: Text(l10n.vibrateNotifications),
              value: settings.vibrationEnabled,
              onChanged: settings.notificationsEnabled ? provider.toggleVibration : null,
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.snooze),
              title: Text(l10n.snoozeDuration),
              subtitle: Text('${settings.snoozeDuration} ${l10n.minutes}'),
              trailing: const Icon(Icons.edit),
              onTap: () => _editSnoozeDuration(context, settings.snoozeDuration, provider),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWaterSection(
    BuildContext context,
    Settings settings,
    SettingsProvider provider,
  ) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.waterTracking,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.local_drink),
              title: Text(l10n.dailyTarget),
              subtitle: Text('${settings.waterTarget} ${l10n.glasses}'),
              trailing: const Icon(Icons.edit),
              onTap: () => _editWaterTarget(context, settings.waterTarget, provider),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.waterReminders),
              subtitle: Text(l10n.regularHydrationReminders),
              value: settings.waterRemindersEnabled,
              onChanged: settings.notificationsEnabled ? provider.toggleWaterReminders : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataSection(BuildContext context, SettingsProvider provider) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.dataManagement,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.download),
              title: Text(l10n.exportData),
              subtitle: Text(l10n.downloadDataAsJSON),
              onTap: () => _exportData(context, provider),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.refresh, color: Colors.orange),
              title: Text(l10n.resetSettings),
              subtitle: Text(l10n.restoreDefaultSettings),
              onTap: () => _resetSettings(context, provider),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.delete_forever, color: Colors.red),
              title: Text(l10n.clearAllData),
              subtitle: Text(l10n.deleteAllMedicinesHistory),
              onTap: () => _clearAllData(context, provider),
            ),
          ],
        ),
      ),
    );
  }

  void _editMealTime(
    BuildContext context,
    String mealName,
    String currentTime,
    Function(String) onSave,
  ) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _parseTime(currentTime),
    );
    
    if (picked != null) {
      final timeString = _formatTime(picked);
      onSave(timeString);
    }
  }

  void _editSnoozeDuration(
    BuildContext context,
    int currentDuration,
    SettingsProvider provider,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController(text: currentDuration.toString());
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.snoozeDuration),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: l10n.minutes,
            suffixText: l10n.min,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              final duration = int.tryParse(controller.text);
              if (duration != null && duration > 0) {
                provider.updateSnoozeDuration(duration);
                Navigator.pop(context);
              }
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }

  void _editWaterTarget(
    BuildContext context,
    int currentTarget,
    SettingsProvider provider,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController(text: currentTarget.toString());
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.dailyTarget),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: l10n.glassesPerDay,
            suffixText: l10n.glasses,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              final target = int.tryParse(controller.text);
              if (target != null && target > 0) {
                provider.updateWaterTarget(target);
                Navigator.pop(context);
              }
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }

  Future<void> _exportData(BuildContext context, SettingsProvider provider) async {
    final l10n = AppLocalizations.of(context)!;
    try {
      final data = await provider.exportData();
      // In a real app, you would save this to a file or share it
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(l10n.exportData),
            content: const Text('Data export feature would save your data to a file in a real implementation.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(l10n.ok),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Export failed: $e')),
        );
      }
    }
  }

  void _resetSettings(BuildContext context, SettingsProvider provider) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.resetSettings),
        content: const Text('Are you sure you want to reset all settings to default?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              provider.resetSettings();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.settingsResetToDefault)),
              );
            },
            child: Text(l10n.reset),
          ),
        ],
      ),
    );
  }

  void _clearAllData(BuildContext context, SettingsProvider provider) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.clearAllData),
        content: const Text('This will permanently delete all your medicines, logs, and history. This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              provider.resetAllData();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.allDataCleared)),
              );
            },
            child: Text(l10n.clearAll, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageSection(BuildContext context, SettingsProvider provider) {
    final l10n = AppLocalizations.of(context)!;
    final settings = provider.settings;
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.language_rounded,
                    color: Theme.of(context).colorScheme.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  l10n.language,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Compact language switcher
            Row(
              children: [
                Expanded(
                  child: _buildCompactLanguageOption(
                    context,
                    'English',
                    'en',
                    Icons.language,
                    settings.languageCode == 'en',
                    () {
                      if (settings.languageCode != 'en') {
                        provider.updateLanguage('en');
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Language changed to English'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildCompactLanguageOption(
                    context,
                    'বাংলা',
                    'bn',
                    Icons.translate,
                    settings.languageCode == 'bn',
                    () {
                      if (settings.languageCode != 'bn') {
                        provider.updateLanguage('bn');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('ভাষা বাংলায় পরিবর্তন করা হয়েছে'),
                            duration: const Duration(seconds: 2),
                            backgroundColor: Theme.of(context).colorScheme.primary,
                          ),
                        );
                      }
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

  Widget _buildCompactLanguageOption(
    BuildContext context,
    String title,
    String code,
    IconData icon,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected 
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.outline.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
          color: isSelected
            ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
            : Colors.transparent,
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected 
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurface,
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: Theme.of(context).colorScheme.primary,
                size: 16,
              ),
          ],
        ),
      ),
    );
  }

  TimeOfDay _parseTime(String timeString) {
    final parts = timeString.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  String _formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}