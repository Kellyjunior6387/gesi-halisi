/// Customer Dashboard for Gesi Halisi Application
///
/// Main dashboard for customers with verification and chatbot features.
/// Features:
/// - QR code scanning for cylinder verification
/// - AI chatbot assistance in Swahili
/// - Clean, modern UI consistent with app theme

import 'package:flutter/material.dart';
import 'dart:ui' show ImageFilter;
import '../../constants/app_theme.dart';
import '../../services/auth_service.dart';
import 'package:provider/provider.dart';
import '../verify_cylinder_screen.dart';
import '../chatbot_screen.dart';

class CustomerDashboard extends StatefulWidget {
  const CustomerDashboard({super.key});

  @override
  State<CustomerDashboard> createState() => _CustomerDashboardState();
}

class _CustomerDashboardState extends State<CustomerDashboard> {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final user = authService.currentUser;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppGradients.primaryBackground,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top App Bar
              _buildTopAppBar(),
              
              // Main content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Welcome message
                      _buildWelcomeSection(user?.email ?? 'Customer'),
                      
                      const SizedBox(height: AppSpacing.xl),
                      
                      // Main action cards
                      _buildActionCards(context),
                      
                      const SizedBox(height: AppSpacing.xl),
                      
                      // Information section
                      _buildInfoSection(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // Floating action button for chatbot
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ChatbotScreen(),
            ),
          );
        },
        backgroundColor: AppColors.accentPurple,
        icon: const Icon(Icons.chat_bubble_outline, color: AppColors.white),
        label: const Text(
          'Msaada',
          style: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildTopAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'SafeCyl',
            style: AppTextStyles.logo.copyWith(fontSize: 28),
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.white),
            onPressed: () async {
              final authService = context.read<AuthService>();
              await authService.signOut();
              if (mounted) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/',
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection(String email) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Karibu!',
          style: AppTextStyles.onboardingTitle.copyWith(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Thibitisha uhalisi wa silinda yako',
          style: AppTextStyles.onboardingDescription.copyWith(
            color: AppColors.lightGray,
          ),
        ),
      ],
    );
  }

  Widget _buildActionCards(BuildContext context) {
    return Column(
      children: [
        // Verify Cylinder Card
        _buildGlassCard(
          icon: Icons.qr_code_scanner,
          iconColor: AppColors.accentPurple,
          title: 'Thibitisha Silinda',
          description: 'Scan QR code ya silinda',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const VerifyCylinderScreen(),
              ),
            );
          },
        ),
        
        const SizedBox(height: AppSpacing.md),
        
        // How it Works Card
        _buildGlassCard(
          icon: Icons.info_outline,
          iconColor: AppColors.blockchainBlue,
          title: 'Jinsi Inavyofanya Kazi',
          description: 'Jifunze kuhusu usalama wa silinda',
          onTap: () {
            _showHowItWorksDialog();
          },
        ),
      ],
    );
  }

  Widget _buildGlassCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppBorderRadius.lg),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          gradient: AppGradients.glassGradient,
          borderRadius: BorderRadius.circular(AppBorderRadius.lg),
          border: Border.all(
            color: AppColors.glassWhiteBorder,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(AppBorderRadius.md),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 32,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      color: AppColors.lightGray.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: AppColors.lightGray,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: AppGradients.glassGradient,
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        border: Border.all(
          color: AppColors.glassWhiteBorder,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.security,
                color: AppColors.safetyGreen,
                size: 24,
              ),
              const SizedBox(width: AppSpacing.sm),
              const Text(
                'Usalama Wako ni Muhimu',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _buildInfoItem('✓', 'Thibitisha silinda kabla ya kununua'),
          _buildInfoItem('✓', 'Hakikisha ni halisi kutoka kwa mtengenezaji'),
          _buildInfoItem('✓', 'Pata taarifa za silinda kwa haraka'),
          _buildInfoItem('✓', 'Uliza maswali yoyote kwa chatbot yetu'),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String bullet, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            bullet,
            style: const TextStyle(
              color: AppColors.safetyGreen,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: AppColors.lightGray.withOpacity(0.9),
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showHowItWorksDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.darkPurple,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        ),
        title: const Text(
          'Jinsi Inavyofanya Kazi',
          style: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDialogStep(
              '1',
              'Bonyeza "Thibitisha Silinda"',
              'Fungua scanner ya QR code',
            ),
            const SizedBox(height: AppSpacing.md),
            _buildDialogStep(
              '2',
              'Scan QR Code',
              'Elekeza kamera kwenye QR code iliyopo kwenye silinda',
            ),
            const SizedBox(height: AppSpacing.md),
            _buildDialogStep(
              '3',
              'Pata Matokeo',
              'Angalia kama silinda ni halisi na taarifa zake',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Sawa',
              style: TextStyle(color: AppColors.accentPurple),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDialogStep(String number, String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: AppColors.accentPurple,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  color: AppColors.lightGray.withOpacity(0.8),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
