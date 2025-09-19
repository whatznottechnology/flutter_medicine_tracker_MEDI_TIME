import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'l10n/app_localizations.dart';
import 'services/database_service.dart';
import 'services/notification_service.dart';
import 'services/seed_data_service.dart';
import 'providers/medicine_provider.dart';
import 'providers/water_provider.dart';
import 'providers/settings_provider.dart';
import 'providers/history_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/main_navigation_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize services
  await DatabaseService.initialize();
  await NotificationService.initialize();
  
  // Add sample data for demo (only if no data exists)
  // await SeedDataService.addSampleData();
  
  runApp(const MedicineTrackerApp());
}

class MedicineTrackerApp extends StatelessWidget {
  const MedicineTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => MedicineProvider()),
        ChangeNotifierProvider(create: (_) => WaterProvider()),
        ChangeNotifierProvider(create: (_) => HistoryProvider()),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settingsProvider, child) {
          return MaterialApp(
            title: 'Medi Time',
            debugShowCheckedModeBanner: false,
            theme: _buildLightTheme(),
            darkTheme: _buildDarkTheme(),
            themeMode: ThemeMode.system,
            locale: Locale(settingsProvider.languageCode),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', ''), // English
              Locale('bn', ''), // Bengali
            ],
            home: _getInitialScreen(settingsProvider),
          );
        },
      ),
    );
  }

  Widget _getInitialScreen(SettingsProvider settingsProvider) {
    if (settingsProvider.isLoading) {
      return SplashScreen(
        onNavigateToOnboarding: () {
          // This will be handled by the SettingsProvider automatically
          // when isLoading becomes false
        },
      );
    }
    
    if (!settingsProvider.isOnboardingCompleted) {
      return const OnboardingScreen();
    }
    
    return const MainNavigationScreen();
  }

  ThemeData _buildLightTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF4CAF50), // Green primary
        brightness: Brightness.light,
      ).copyWith(
        primary: const Color(0xFF4CAF50), // Green
        secondary: const Color(0xFFFFC107), // Yellow
        surface: Colors.white,
        onSurface: Colors.black,
        background: Colors.white,
        onBackground: Colors.black,
        tertiary: const Color(0xFF8BC34A), // Light green
      ),
      brightness: Brightness.light,
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
      ),
      cardTheme: const CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
      ),
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF4CAF50), // Green primary
        brightness: Brightness.dark,
      ).copyWith(
        primary: const Color(0xFF66BB6A), // Lighter green for dark theme
        secondary: const Color(0xFFFFC107), // Yellow
        surface: const Color(0xFF121212),
        onSurface: Colors.white,
        background: Colors.black,
        onBackground: Colors.white,
        tertiary: const Color(0xFF8BC34A), // Light green
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
      ),
      cardTheme: const CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
      ),
    );
  }
}
