/// GasChain Splash Screen
///
/// This screen displays the app logo and tagline with smooth animations
/// before automatically navigating to the onboarding screen.
///
/// Features:
/// - Fullscreen dark gradient background
/// - Animated logo with fade-in and scale effects
/// - Auto-navigation after 3 seconds
/// - Material Design 3 compliance
///
/// Security Features:
/// - No sensitive data stored or displayed
/// - Safe navigation without data exposure
/// - Proper widget lifecycle management to prevent memory leaks

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async' show Timer;
import '../constants/app_theme.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  // Animation controller for logo animations
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
    // Set status bar to transparent for fullscreen effect
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: AppAnimations.fadeIn,
    );

    // Setup fade animation (0.0 to 1.0)
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));

    // Setup scale animation (0.5 to 1.0 for subtle zoom effect)
    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));

    // Start animations
    _animationController.forward();

    // Navigate to onboarding after delay
    _navigateToOnboarding();
  }

  /// Navigates to onboarding screen after splash delay
  /// Uses Timer to ensure proper delay before navigation
  void _navigateToOnboarding() {
    Timer(AppAnimations.splashDelay, () {
      // Check if widget is still mounted before navigating
      // This prevents navigation errors if widget is disposed early
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const OnboardingScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              // Smooth fade transition between screens
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            transitionDuration: AppAnimations.pageTransition,
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    // Clean up animation controller to prevent memory leaks
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Use transparent background to show gradient
      backgroundColor: Colors.transparent,
      body: Container(
        // Apply gradient background
        decoration: const BoxDecoration(
          gradient: AppGradients.primaryBackground,
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated logo section
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return FadeTransition(
                      opacity: _fadeAnimation,
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        child: Column(
                          children: [
                            // Logo container with glow effect
                            _buildLogoSection(),
                            
                            const SizedBox(height: AppSpacing.lg),
                            
                            // App name
                            _buildAppName(),
                            
                            const SizedBox(height: AppSpacing.md),
                            
                            // Tagline
                            _buildTagline(),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                
                // Loading indicator at the bottom
                const SizedBox(height: AppSpacing.xxl * 2),
                _buildLoadingIndicator(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the logo section with placeholder and glow effect
  Widget _buildLogoSection() {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: AppGradients.accentGradient,
        boxShadow: [
          BoxShadow(
            color: AppColors.accentPurple.withOpacity(0.5),
            blurRadius: 40,
            spreadRadius: 10,
          ),
        ],
      ),
      child: Center(
        child: Icon(
          // Placeholder icon - replace with actual logo image when available
          Icons.shield_outlined,
          size: 80,
          color: AppColors.white,
        ),
      ),
    );
    
    // Alternative: Use actual logo image (uncomment when logo is added)
    // return Container(
    //   width: 150,
    //   height: 150,
    //   decoration: BoxDecoration(
    //     shape: BoxShape.circle,
    //     boxShadow: [
    //       BoxShadow(
    //         color: AppColors.accentPurple.withOpacity(0.5),
    //         blurRadius: 40,
    //         spreadRadius: 10,
    //       ),
    //     ],
    //   ),
    //   child: ClipOval(
    //     child: Image.asset(
    //       'assets/logo.png',
    //       fit: BoxFit.cover,
    //       errorBuilder: (context, error, stackTrace) {
    //         return Icon(
    //           Icons.shield_outlined,
    //           size: 80,
    //           color: AppColors.white,
    //         );
    //       },
    //     ),
    //   ),
    // );
  }

  /// Builds the app name text
  Widget _buildAppName() {
    return Text(
      'GasChain',
      style: AppTextStyles.logo,
    );
  }

  /// Builds the tagline text
  Widget _buildTagline() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Text(
        'Verify your gas — stay safe with blockchain.',
        style: AppTextStyles.tagline,
        textAlign: TextAlign.center,
      ),
    );
  }

  /// Builds the loading indicator
  Widget _buildLoadingIndicator() {
    return SizedBox(
      width: 40,
      height: 40,
      child: CircularProgressIndicator(
        strokeWidth: 3,
        valueColor: AlwaysStoppedAnimation<Color>(
          AppColors.accentPurple,
        ),
      ),
    );
  }
}
