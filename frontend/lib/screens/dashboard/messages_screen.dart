/// Messages Screen (Placeholder)
///
/// Displays messages and notifications

import 'package:flutter/material.dart';
import 'dart:ui' show ImageFilter;
import '../../constants/app_theme.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          _buildMessageCard(
            'System Notification',
            'New cylinder batch has been verified',
            '2 hours ago',
            Icons.check_circle,
            AppColors.safetyGreen,
          ),
          const SizedBox(height: AppSpacing.md),
          _buildMessageCard(
            'Order Update',
            'Order #ORD-001 has been shipped',
            '5 hours ago',
            Icons.local_shipping,
            AppColors.blockchainBlue,
          ),
          const SizedBox(height: AppSpacing.md),
          _buildMessageCard(
            'NFT Minted',
            '50 new NFTs have been successfully minted',
            '1 day ago',
            Icons.diamond,
            AppColors.accentPurple,
          ),
        ],
      ),
    );
  }

  Widget _buildMessageCard(
    String title,
    String message,
    String time,
    IconData icon,
    Color color,
  ) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: AppDecorations.glassCard(borderRadius: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.buttonPrimary.copyWith(fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      message,
                      style: AppTextStyles.buttonSecondary.copyWith(
                        color: AppColors.lightGray,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      time,
                      style: TextStyle(
                        color: AppColors.lightGray.withOpacity(0.7),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
