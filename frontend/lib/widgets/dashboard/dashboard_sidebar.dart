/// Dashboard Sidebar Widget
///
/// Glassmorphic sidebar navigation for manufacturer dashboard

import 'package:flutter/material.dart';
import 'dart:ui' show ImageFilter;
import '../../constants/app_theme.dart';

class DashboardSidebar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const DashboardSidebar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 900;
    
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: isDesktop ? 260 : 200,
          decoration: BoxDecoration(
            color: AppColors.glassWhite,
            border: Border(
              right: BorderSide(
                color: AppColors.glassWhiteBorder,
                width: 1,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo section
              Padding(
                padding: EdgeInsets.all(isDesktop ? AppSpacing.lg : AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            gradient: AppGradients.accentGradient,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.local_gas_station,
                            color: AppColors.white,
                            size: 24,
                          ),
                        ),
                        if (isDesktop) ...[
                          const SizedBox(width: AppSpacing.sm),
                          Text(
                            'GasChain',
                            style: AppTextStyles.logo.copyWith(fontSize: 20),
                          ),
                        ],
                      ],
                    ),
                    if (isDesktop) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'Manufacturer Portal',
                        style: AppTextStyles.buttonSecondary.copyWith(
                          color: AppColors.lightGray,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              
              Divider(
                color: AppColors.glassWhiteBorder,
                height: 1,
                thickness: 1,
              ),
              
              const SizedBox(height: AppSpacing.md),
              
              // Navigation items
              Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(
                    horizontal: isDesktop ? AppSpacing.md : AppSpacing.sm,
                  ),
                  children: [
                    _buildNavItem(
                      context: context,
                      index: 0,
                      icon: Icons.dashboard_outlined,
                      activeIcon: Icons.dashboard,
                      label: 'Overview',
                      isDesktop: isDesktop,
                    ),
                    _buildNavItem(
                      context: context,
                      index: 1,
                      icon: Icons.gas_meter_outlined,
                      activeIcon: Icons.gas_meter,
                      label: 'Cylinders',
                      isDesktop: isDesktop,
                    ),
                    _buildNavItem(
                      context: context,
                      index: 2,
                      icon: Icons.shopping_bag_outlined,
                      activeIcon: Icons.shopping_bag,
                      label: 'Orders',
                      isDesktop: isDesktop,
                    ),
                    _buildNavItem(
                      context: context,
                      index: 3,
                      icon: Icons.analytics_outlined,
                      activeIcon: Icons.analytics,
                      label: 'Analytics',
                      isDesktop: isDesktop,
                    ),
                    _buildNavItem(
                      context: context,
                      index: 4,
                      icon: Icons.message_outlined,
                      activeIcon: Icons.message,
                      label: 'Messages',
                      isDesktop: isDesktop,
                    ),
                    
                    const SizedBox(height: AppSpacing.xl),
                    
                    Divider(
                      color: AppColors.glassWhiteBorder,
                      thickness: 1,
                    ),
                    
                    const SizedBox(height: AppSpacing.sm),
                    
                    _buildNavItem(
                      context: context,
                      index: 5,
                      icon: Icons.settings_outlined,
                      activeIcon: Icons.settings,
                      label: 'Settings',
                      isDesktop: isDesktop,
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

  Widget _buildNavItem({
    required BuildContext context,
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required bool isDesktop,
  }) {
    final isSelected = selectedIndex == index;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onItemSelected(index),
          borderRadius: BorderRadius.circular(12),
          child: AnimatedContainer(
            duration: AppAnimations.buttonPress,
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? AppSpacing.md : AppSpacing.sm,
              vertical: AppSpacing.md,
            ),
            decoration: BoxDecoration(
              gradient: isSelected ? AppGradients.accentGradient : null,
              color: isSelected ? null : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  isSelected ? activeIcon : icon,
                  color: isSelected ? AppColors.white : AppColors.lightGray,
                  size: 24,
                ),
                if (isDesktop) ...[
                  const SizedBox(width: AppSpacing.md),
                  Text(
                    label,
                    style: AppTextStyles.buttonPrimary.copyWith(
                      color: isSelected ? AppColors.white : AppColors.lightGray,
                      fontSize: 15,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
