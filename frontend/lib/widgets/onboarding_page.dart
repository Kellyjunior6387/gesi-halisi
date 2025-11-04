/// Reusable Onboarding Page Widget
///
/// This widget represents a single page in the onboarding flow.
/// It displays an illustration, title, and description in a glassmorphic card.
///
/// Features:
/// - Glassmorphism UI with blur effects
/// - Smooth animations
/// - Responsive layout
/// - Support for Lottie animations or static images
///
/// Security: No sensitive data handled, all content is static

import 'package:flutter/material.dart';
import 'dart:ui' show ImageFilter;
import '../constants/app_theme.dart';

class OnboardingPage extends StatelessWidget {
  /// Title of the onboarding page
  final String title;
  
  /// Description text explaining the feature
  final String description;
  
  /// Icon to display (used when Lottie is not available)
  final IconData icon;
  
  /// Color for the icon
  final Color iconColor;
  
  /// Optional Lottie animation path
  /// If provided, will be used instead of icon (when lottie files are added)
  final String? lottiePath;

  const OnboardingPage({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    this.iconColor = AppColors.accentPurple,
    this.lottiePath,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Top spacer
          const Spacer(flex: 1),
          
          // Illustration section
          _buildIllustration(),
          
          const SizedBox(height: AppSpacing.xxl),
          
          // Glassmorphic content card
          _buildContentCard(),
          
          // Bottom spacer
          const Spacer(flex: 2),
        ],
      ),
    );
  }

  /// Builds the illustration section
  /// Uses icon placeholder - can be replaced with Lottie when files are added
  /// 
  /// Alternative implementation for Lottie animations:
  /// When lottie files are added, you can check lottiePath and use Lottie.asset
  /// Example:
  /// ```dart
  /// if (lottiePath != null) {
  ///   return Container(
  ///     width: 250,
  ///     height: 250,
  ///     child: Lottie.asset(
  ///       lottiePath!,
  ///       fit: BoxFit.contain,
  ///       errorBuilder: (context, error, stackTrace) {
  ///         return _buildIconPlaceholder();
  ///       },
  ///     ),
  ///   );
  /// }
  /// return _buildIconPlaceholder();
  /// ```
  Widget _buildIllustration() {
    return Container(
      width: 250,
      height: 250,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            iconColor.withOpacity(0.2),
            iconColor.withOpacity(0.1),
          ],
        ),
      ),
      child: Center(
        child: Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                iconColor.withOpacity(0.3),
                iconColor.withOpacity(0.15),
              ],
            ),
          ),
          child: Icon(
            icon,
            size: 100,
            color: iconColor,
          ),
        ),
      ),
    );
  }

  /// Builds the glassmorphic content card with title and description
  Widget _buildContentCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        // Blur effect for glassmorphism
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.xl),
          decoration: AppDecorations.glassCard(),
          child: Column(
            children: [
              // Title
              Text(
                title,
                style: AppTextStyles.onboardingTitle,
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: AppSpacing.md),
              
              // Description
              Text(
                description,
                style: AppTextStyles.onboardingDescription,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
