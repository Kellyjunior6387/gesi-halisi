/// GasChain Authentication Screen (Placeholder)
///
/// This is a placeholder screen for the login/signup functionality.
/// Will be implemented in future iterations with Firebase Authentication.
///
/// Security Features:
/// - Placeholder only - no authentication logic yet
/// - Will implement secure Firebase Auth in next phase
/// - Input validation will be added
/// - Password encryption will be handled by Firebase

import 'package:flutter/material.dart';
import '../constants/app_theme.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppGradients.primaryBackground,
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  Icon(
                    Icons.shield_outlined,
                    size: 100,
                    color: AppColors.accentPurple,
                  ),
                  
                  const SizedBox(height: AppSpacing.xl),
                  
                  // Title
                  Text(
                    'Welcome to GasChain',
                    style: AppTextStyles.onboardingTitle,
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: AppSpacing.md),
                  
                  // Description
                  Text(
                    'Login/Signup screen will be implemented here',
                    style: AppTextStyles.onboardingDescription,
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: AppSpacing.xxl),
                  
                  // Placeholder buttons
                  _buildPlaceholderButton(
                    context,
                    'Login',
                    Icons.login,
                  ),
                  
                  const SizedBox(height: AppSpacing.md),
                  
                  _buildPlaceholderButton(
                    context,
                    'Sign Up',
                    Icons.person_add,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Builds a placeholder button
  Widget _buildPlaceholderButton(
    BuildContext context,
    String label,
    IconData icon,
  ) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: AppDecorations.primaryButton(),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Show snackbar indicating this is a placeholder
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  '$label functionality will be implemented in the next phase',
                  style: AppTextStyles.buttonSecondary.copyWith(
                    color: AppColors.white,
                  ),
                ),
                backgroundColor: AppColors.darkPurple,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(12),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: AppColors.white),
                const SizedBox(width: AppSpacing.sm),
                Text(label, style: AppTextStyles.buttonPrimary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
