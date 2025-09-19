import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../l10n/app_localizations.dart';
import '../providers/medicine_provider.dart';
import '../providers/water_provider.dart';
import '../providers/history_provider.dart';
import '../widgets/upcoming_medicines_card.dart';
import '../widgets/water_progress_card.dart';
import '../widgets/adherence_card.dart';
import '../widgets/quick_actions_card.dart';
import 'add_medicine_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.dashboard_rounded,
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              l10n.dashboard,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.add_rounded, color: Colors.white),
              onPressed: () => _navigateToAddMedicine(context),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _refreshData(context),
        color: Theme.of(context).colorScheme.primary,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildEnhancedGreeting(context),
              const SizedBox(height: 24),
              const QuickActionsCard(),
              const SizedBox(height: 20),
              const UpcomingMedicinesCard(),
              const SizedBox(height: 20),
              const WaterProgressCard(),
              const SizedBox(height: 20),
              const AdherenceCard(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedGreeting(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final hour = now.hour;
    
    String greeting;
    IconData greetingIcon;
    Color greetingColor;
    
    if (hour < 12) {
      greeting = l10n.goodMorning;
      greetingIcon = Icons.wb_sunny_rounded;
      greetingColor = const Color(0xFFFF9800);
    } else if (hour < 17) {
      greeting = l10n.goodAfternoon;
      greetingIcon = Icons.brightness_5_rounded;
      greetingColor = const Color(0xFFF44336);
    } else {
      greeting = l10n.goodEvening;
      greetingIcon = Icons.brightness_3_rounded;
      greetingColor = const Color(0xFF3F51B5);
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.1),
            Theme.of(context).colorScheme.secondary.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: greetingColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              greetingIcon,
              color: greetingColor,
              size: 32,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  greeting,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.stayHealthy,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  DateFormat('EEEE, MMMM d, y').format(now),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGreeting(BuildContext context) {
    final now = DateTime.now();
    final hour = now.hour;
    final l10n = AppLocalizations.of(context)!;
    
    String greeting;
    if (hour < 12) {
      greeting = l10n.goodMorning;
    } else if (hour < 17) {
      greeting = l10n.goodAfternoon;
    } else {
      greeting = l10n.goodEvening;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          greeting,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          DateFormat('EEEE, MMMM d').format(now),
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Future<void> _refreshData(BuildContext context) async {
    // Trigger refresh for all providers
    final medicineProvider = Provider.of<MedicineProvider>(context, listen: false);
    final waterProvider = Provider.of<WaterProvider>(context, listen: false);
    final historyProvider = Provider.of<HistoryProvider>(context, listen: false);
    
    // The providers will automatically refresh when their underlying data changes
    // due to the Hive listeners, so we don't need to manually refresh here
    await Future.delayed(const Duration(milliseconds: 500));
  }

  void _navigateToAddMedicine(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddMedicineScreen()),
    );
  }
}