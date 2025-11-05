/// Settings Screen
///
/// Manufacturer profile and settings

import 'package:flutter/material.dart';
import 'dart:ui' show ImageFilter;
import 'package:provider/provider.dart';
import '../../constants/app_theme.dart';
import '../../services/auth_service.dart';
import '../auth_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProfileCard(),
          const SizedBox(height: AppSpacing.lg),
          _buildSettingsSection(
            'Account Settings',
            [
              _buildSettingItem(
                Icons.person,
                'Edit Profile',
                () {},
              ),
              _buildSettingItem(
                Icons.lock,
                'Change Password',
                () {},
              ),
              _buildSettingItem(
                Icons.notifications,
                'Notifications',
                () {},
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          _buildSettingsSection(
            'Manufacturer Info',
            [
              _buildSettingItem(
                Icons.business,
                'Company Details',
                () {},
              ),
              _buildSettingItem(
                Icons.verified,
                'Verification',
                () {},
              ),
              _buildSettingItem(
                Icons.description,
                'Documents',
                () {},
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          _buildSettingsSection(
            'App Settings',
            [
              _buildSettingItem(
                Icons.palette,
                'Theme',
                () {},
              ),
              _buildSettingItem(
                Icons.language,
                'Language',
                () {},
              ),
              _buildSettingItem(
                Icons.help,
                'Help & Support',
                () {},
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          _buildLogoutButton(context),
        ],
      ),
    );
  }

  Widget _buildProfileCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.xl),
          decoration: AppDecorations.glassCard(),
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: AppColors.accentPurple,
                child: const Icon(
                  Icons.factory,
                  color: AppColors.white,
                  size: 48,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'GasChain Manufacturer',
                style: AppTextStyles.onboardingTitle.copyWith(fontSize: 20),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'manufacturer@gaschain.com',
                style: AppTextStyles.buttonSecondary.copyWith(
                  color: AppColors.lightGray,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  gradient: AppGradients.accentGradient,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Verified Manufacturer',
                  style: TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: AppSpacing.sm, bottom: AppSpacing.sm),
          child: Text(
            title,
            style: AppTextStyles.buttonPrimary.copyWith(
              fontSize: 16,
              color: AppColors.lightGray,
            ),
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: AppDecorations.glassCard(borderRadius: 16),
              child: Column(children: items),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingItem(IconData icon, String title, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: AppColors.glassWhiteBorder,
                width: 0.5,
              ),
            ),
          ),
          child: Row(
            children: [
              Icon(icon, color: AppColors.lightGray),
              const SizedBox(width: AppSpacing.md),
              Text(
                title,
                style: AppTextStyles.buttonPrimary.copyWith(fontSize: 15),
              ),
              const Spacer(),
              Icon(
                Icons.arrow_forward_ios,
                color: AppColors.lightGray,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.withOpacity(0.5)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            try {
              await context.read<AuthService>().signOut();
              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const AuthScreen(),
                  ),
                  (route) => false,
                );
              }
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error signing out: $e'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          borderRadius: BorderRadius.circular(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.logout, color: Colors.red),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Logout',
                style: AppTextStyles.buttonPrimary.copyWith(
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
