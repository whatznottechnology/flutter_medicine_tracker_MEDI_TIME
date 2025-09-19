import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../models/settings.dart';
import '../utils/time_utils.dart';
import 'main_navigation_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  
  // Meal time controllers
  final TextEditingController _breakfastController = TextEditingController(text: '8:00 AM');
  final TextEditingController _lunchController = TextEditingController(text: '1:00 PM');
  final TextEditingController _dinnerController = TextEditingController(text: '7:00 PM');

  @override
  void dispose() {
    _pageController.dispose();
    _breakfastController.dispose();
    _lunchController.dispose();
    _dinnerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (page) => setState(() => _currentPage = page),
        children: [
          _buildWelcomePage(),
          _buildMealTimesPage(),
          _buildCompletePage(),
        ],
      ),
    );
  }

  Widget _buildWelcomePage() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Icon(
              Icons.medication,
              size: 120,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 32),
            Text(
              'Welcome to\nMedicine Tracker',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Track your medicines & water intake easily.\nNever miss a dose again!',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _nextPage(),
                child: const Text('Get Started'),
              ),
            ),
            const SizedBox(height: 16),
            _buildPageIndicator(),
          ],
        ),
      ),
    );
  }

  Widget _buildMealTimesPage() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 48),
            Icon(
              Icons.schedule,
              size: 80,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 24),
            Text(
              'Set Your Meal Times',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'This helps us suggest the best times for your medicine reminders.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 48),
            _buildTimeField('Breakfast', _breakfastController, Icons.breakfast_dining),
            const SizedBox(height: 16),
            _buildTimeField('Lunch', _lunchController, Icons.lunch_dining),
            const SizedBox(height: 16),
            _buildTimeField('Dinner', _dinnerController, Icons.dinner_dining),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _previousPage(),
                    child: const Text('Back'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _nextPage(),
                    child: const Text('Continue'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildPageIndicator(),
          ],
        ),
      ),
    );
  }

  Widget _buildCompletePage() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Icon(
              Icons.check_circle,
              size: 120,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 32),
            Text(
              'You\'re All Set!',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Start tracking your medicines and water intake.\nWe\'ll send you helpful reminders!',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _completeOnboarding(),
                child: const Text('Start Tracking'),
              ),
            ),
            const SizedBox(height: 16),
            _buildPageIndicator(),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeField(String label, TextEditingController controller, IconData icon) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        hintText: 'HH:MM',
      ),
      onTap: () => _selectTime(controller),
      readOnly: true,
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentPage == index
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outline,
          ),
        );
      }),
    );
  }

  Future<void> _selectTime(TextEditingController controller) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _parseTime(controller.text),
    );
    
    if (picked != null) {
      controller.text = _formatTime(picked);
    }
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

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _completeOnboarding() async {
    final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
    
    // Update meal times (convert 12-hour to 24-hour for storage)
    final mealTimes = MealTimes(
      breakfast: TimeUtils.parse12HourTo24Hour(_breakfastController.text),
      lunch: TimeUtils.parse12HourTo24Hour(_lunchController.text),
      dinner: TimeUtils.parse12HourTo24Hour(_dinnerController.text),
    );
    
    await settingsProvider.updateMealTimes(mealTimes);
    await settingsProvider.completeOnboarding();
    
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
      );
    }
  }
}