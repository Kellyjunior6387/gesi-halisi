/// GasChain Application Theme Constants
/// 
/// This file contains all theme-related constants including colors, gradients,
/// text styles, and glassmorphism effects used throughout the application.
/// 
/// Security Note: All visual constants are safe and do not contain sensitive data.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// App Color Palette
/// Uses a modern dark theme with deep blue, purple, and black gradients
class AppColors {
  AppColors._(); // Private constructor to prevent instantiation

  // Primary gradient colors
  static const Color deepBlue = Color(0xFF0A0E27);
  static const Color darkPurple = Color(0xFF1A1A2E);
  static const Color richPurple = Color(0xFF16213E);
  static const Color accentPurple = Color(0xFF6C63FF);
  static const Color lightPurple = Color(0xFF9D8DF1);
  
  // Neutral colors
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color lightGray = Color(0xFFB0B0B0);
  static const Color darkGray = Color(0xFF2A2A2A);
  
  // Feature-specific colors for onboarding
  static const Color safetyGreen = Color(0xFF4CAF50);
  static const Color blockchainBlue = Color(0xFF2196F3);
  static const Color aiOrange = Color(0xFFFF9800);
  
  // Glassmorphism colors
  static Color glassWhite = Colors.white.withOpacity(0.1);
  static Color glassWhiteBorder = Colors.white.withOpacity(0.2);
  static Color glassBackground = Colors.white.withOpacity(0.05);
}

/// App Gradients
/// Predefined gradients for backgrounds and effects
class AppGradients {
  AppGradients._();

  /// Main background gradient (deep blue → purple → black)
  static const LinearGradient primaryBackground = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.deepBlue,
      AppColors.darkPurple,
      AppColors.richPurple,
      AppColors.black,
    ],
    stops: [0.0, 0.3, 0.6, 1.0],
  );

  /// Accent gradient for highlights
  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.accentPurple,
      AppColors.lightPurple,
    ],
  );

  /// Glass card gradient
  /// Note: Cannot be const due to withOpacity() runtime calculation
  static final LinearGradient glassGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Colors.white.withOpacity(0.1),
      Colors.white.withOpacity(0.05),
    ],
  );
}

/// App Text Styles
/// Uses Poppins font family for modern, readable text
class AppTextStyles {
  AppTextStyles._();

  // Logo and brand text
  static TextStyle logo = GoogleFonts.poppins(
    fontSize: 48,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
    letterSpacing: 1.5,
  );

  static TextStyle tagline = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w300,
    color: AppColors.lightGray,
    letterSpacing: 0.5,
  );

  // Onboarding text styles
  static TextStyle onboardingTitle = GoogleFonts.poppins(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
    height: 1.3,
  );

  static TextStyle onboardingDescription = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.lightGray,
    height: 1.5,
  );

  // Button text styles
  static TextStyle buttonPrimary = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
    letterSpacing: 0.5,
  );

  static TextStyle buttonSecondary = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.lightGray,
  );
}

/// App Decorations
/// Reusable decoration styles for glassmorphism and other effects
class AppDecorations {
  AppDecorations._();

  /// Glassmorphic card decoration
  /// Uses blur effect and transparent background for modern UI
  static BoxDecoration glassCard({
    double borderRadius = 20,
    Color? borderColor,
  }) {
    return BoxDecoration(
      gradient: AppGradients.glassGradient,
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: borderColor ?? AppColors.glassWhiteBorder,
        width: 1.5,
      ),
    );
  }

  /// Primary button decoration with gradient
  static BoxDecoration primaryButton({
    double borderRadius = 12,
  }) {
    return BoxDecoration(
      gradient: AppGradients.accentGradient,
      borderRadius: BorderRadius.circular(borderRadius),
      boxShadow: [
        BoxShadow(
          color: AppColors.accentPurple.withOpacity(0.3),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ],
    );
  }

  /// Secondary button decoration with glass effect
  static BoxDecoration secondaryButton({
    double borderRadius = 12,
  }) {
    return BoxDecoration(
      color: AppColors.glassWhite,
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: AppColors.glassWhiteBorder,
        width: 1.5,
      ),
    );
  }
}

/// App Animation Durations
/// Standard animation durations for consistency
class AppAnimations {
  AppAnimations._();

  static const Duration splashDelay = Duration(seconds: 3);
  static const Duration fadeIn = Duration(milliseconds: 800);
  static const Duration slideIn = Duration(milliseconds: 600);
  static const Duration buttonPress = Duration(milliseconds: 200);
  static const Duration pageTransition = Duration(milliseconds: 400);
}

/// App Spacing
/// Standard spacing values for consistency
class AppSpacing {
  AppSpacing._();

  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
}
