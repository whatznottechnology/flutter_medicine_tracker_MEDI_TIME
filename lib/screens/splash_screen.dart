import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'dart:async';
import '../providers/medicine_provider.dart';
import '../providers/settings_provider.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback onNavigateToOnboarding;

  const SplashScreen({
    super.key,
    required this.onNavigateToOnboarding,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _pulseController;
  late AnimationController _iconController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _iconRotateAnimation;
  
  String _loadingText = 'Initializing...';
  bool _dataLoaded = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startAnimation();
    _loadAppData();
  }

  void _setupAnimations() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _iconController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.2, 0.8, curve: Curves.elasticOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.15,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _iconRotateAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _iconController,
      curve: Curves.easeInOut,
    ));
  }

  void _startAnimation() {
    _controller.forward();
    _pulseController.repeat(reverse: true);
    _iconController.repeat();
  }

  Future<void> _loadAppData() async {
    // Simulate data loading with progress updates
    setState(() => _loadingText = 'Loading medicines...');
    await Future.delayed(const Duration(milliseconds: 800));
    
    setState(() => _loadingText = 'Setting up notifications...');
    await Future.delayed(const Duration(milliseconds: 600));
    
    setState(() => _loadingText = 'Preparing your dashboard...');
    await Future.delayed(const Duration(milliseconds: 700));
    
    // Initialize default language if not set
    final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
    
    setState(() => _loadingText = 'Almost ready...');
    await Future.delayed(const Duration(milliseconds: 500));
    
    setState(() {
      _dataLoaded = true;
      _loadingText = 'Welcome to Medi Time!';
    });

    // Navigate after data is loaded
    Timer(const Duration(milliseconds: 800), () {
      if (mounted) {
        widget.onNavigateToOnboarding();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _pulseController.dispose();
    _iconController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark 
          ? const Color(0xFF0D1421) 
          : const Color(0xFFF0F8F5),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    const Color(0xFF0D1421),
                    const Color(0xFF1A2332),
                    const Color(0xFF2D4A3E),
                  ]
                : [
                    const Color(0xFFF0F8F5),
                    const Color(0xFFE8F5E8),
                    const Color(0xFFB8E6B8),
                  ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Background pattern
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  backgroundBlendMode: BlendMode.overlay,
                  color: Colors.transparent,
                ),
                child: CustomPaint(
                  painter: BackgroundPatternPainter(
                    color: theme.colorScheme.primary.withOpacity(0.05),
                  ),
                ),
              ),
            ),
            Column(
              children: [
                // Language switcher in top right
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50, right: 20),
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: _buildLanguageSwitcher(context),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Center(
                    child: AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return FadeTransition(
                          opacity: _fadeAnimation,
                          child: ScaleTransition(
                            scale: _scaleAnimation,
                            child: AnimatedBuilder(
                              animation: _pulseController,
                              builder: (context, child) {
                                return Transform.scale(
                                  scale: _pulseAnimation.value,
                                  child: Container(
                                    width: 140,
                                    height: 140,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          const Color(0xFF4CAF50), // Green
                                          const Color(0xFF66BB6A),
                                          const Color(0xFF81C784),
                                        ],
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFF4CAF50).withOpacity(0.4),
                                          blurRadius: 25,
                                          spreadRadius: 8,
                                          offset: const Offset(0, 8),
                                        ),
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 15,
                                          spreadRadius: 2,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        // Background icon
                                        RotationTransition(
                                          turns: _iconRotateAnimation,
                                          child: Icon(
                                            Icons.health_and_safety_outlined,
                                            size: 45,
                                            color: Colors.white.withOpacity(0.3),
                                          ),
                                        ),
                                        // Main icon
                                        const Icon(
                                          Icons.medical_services_rounded,
                                          size: 65,
                                          color: Colors.white,
                                        ),
                                        // Small pulse indicator
                                        Positioned(
                                          top: 25,
                                          right: 25,
                                          child: Container(
                                            width: 20,
                                            height: 20,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: const Color(0xFFFFEB3B), // Yellow
                                              boxShadow: [
                                                BoxShadow(
                                                  color: const Color(0xFFFFEB3B).withOpacity(0.6),
                                                  blurRadius: 10,
                                                  spreadRadius: 2,
                                                ),
                                              ],
                                            ),
                                            child: const Icon(
                                              Icons.favorite,
                                              size: 12,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // App title with gradient
                          ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              colors: [
                                Color(0xFF4CAF50),
                                Color(0xFF2E7D32),
                                Color(0xFF1B5E20),
                              ],
                            ).createShader(bounds),
                            child: Text(
                              'Medi Time',
                              style: theme.textTheme.headlineLarge?.copyWith(
                                fontWeight: FontWeight.w900,
                                fontSize: 36,
                                letterSpacing: 2.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Subtitle with icon
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.medical_information,
                                size: 20,
                                color: const Color(0xFF4CAF50),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Smart Health Assistant',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: const Color(0xFF4CAF50),
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: Text(
                              'Your Personal Medicine & Health Companion',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: theme.colorScheme.onSurface.withOpacity(0.8),
                                height: 1.5,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          const SizedBox(height: 28),
                          // Enhanced feature chips
                          Wrap(
                            spacing: 12,
                            runSpacing: 8,
                            alignment: WrapAlignment.center,
                            children: [
                              _buildFeatureChip(
                                context,
                                Icons.notifications_active_rounded,
                                'Smart Reminders',
                                const Color(0xFF4CAF50),
                              ),
                              _buildFeatureChip(
                                context,
                                Icons.analytics_rounded,
                                'Health Analytics',
                                const Color(0xFF2196F3),
                              ),
                              _buildFeatureChip(
                                context,
                                Icons.camera_alt_rounded,
                                'Medicine Photos',
                                const Color(0xFFFF9800),
                              ),
                              _buildFeatureChip(
                                context,
                                Icons.inventory_2_rounded,
                                'Stock Management',
                                const Color(0xFF9C27B0),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Enhanced progress indicator
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 50,
                              height: 50,
                              child: CircularProgressIndicator(
                                strokeWidth: 4,
                                backgroundColor: const Color(0xFF4CAF50).withOpacity(0.2),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  _dataLoaded 
                                    ? const Color(0xFF4CAF50) 
                                    : const Color(0xFF66BB6A),
                                ),
                              ),
                            ),
                            if (_dataLoaded)
                              Icon(
                                Icons.check_circle,
                                color: const Color(0xFF4CAF50),
                                size: 24,
                              ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Dynamic loading text
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: Text(
                            _loadingText,
                            key: ValueKey(_loadingText),
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: _dataLoaded 
                                ? const Color(0xFF4CAF50)
                                : theme.colorScheme.onSurface.withOpacity(0.7),
                              fontWeight: _dataLoaded ? FontWeight.w600 : FontWeight.normal,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Progress dots
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(4, (index) {
                            return AnimatedContainer(
                              duration: Duration(milliseconds: 300 + (index * 100)),
                              margin: const EdgeInsets.symmetric(horizontal: 3),
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _dataLoaded
                                  ? const Color(0xFF4CAF50)
                                  : const Color(0xFF4CAF50).withOpacity(0.3),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageSwitcher(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO: Implement language switching
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Language switching will be available in settings'),
            duration: Duration(seconds: 2),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          gradient: LinearGradient(
            colors: [
              const Color(0xFF4CAF50).withOpacity(0.2),
              const Color(0xFF66BB6A).withOpacity(0.1),
            ],
          ),
          border: Border.all(
            color: const Color(0xFF4CAF50).withOpacity(0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF4CAF50).withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.language_rounded,
              size: 18,
              color: const Color(0xFF4CAF50),
            ),
            const SizedBox(width: 6),
            Text(
              'EN',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: const Color(0xFF2E7D32),
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 16,
              color: const Color(0xFF4CAF50),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureChip(BuildContext context, IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.2),
            color.withOpacity(0.1),
          ],
        ),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: color,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color.withOpacity(0.9),
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

// Custom painter for background pattern
class BackgroundPatternPainter extends CustomPainter {
  final Color color;

  BackgroundPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Create a subtle pattern of medical icons
    const spacing = 80.0;
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(
          Offset(x + (y % 2 == 0 ? 0 : spacing / 2), y),
          2,
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}