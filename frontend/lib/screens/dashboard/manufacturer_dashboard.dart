/// Manufacturer Dashboard for Gesi Halisi Application
///
/// Main dashboard for manufacturers with glassmorphism design.
/// Features:
/// - Sidebar navigation
/// - Overview with key metrics
/// - Cylinder management
/// - Orders, Analytics, Messages, Settings

import 'package:flutter/material.dart';
import 'dart:ui' show ImageFilter;
import '../../constants/app_theme.dart';
import '../../widgets/dashboard/dashboard_sidebar.dart';
import 'overview_screen.dart';
import 'cylinders_screen.dart';
import 'orders_screen.dart';
import 'analytics_screen.dart';
import 'messages_screen.dart';
import 'settings_screen.dart';

class ManufacturerDashboard extends StatefulWidget {
  const ManufacturerDashboard({super.key});

  @override
  State<ManufacturerDashboard> createState() => _ManufacturerDashboardState();
}

class _ManufacturerDashboardState extends State<ManufacturerDashboard> {
  int _selectedIndex = 0;

  // Dashboard sections
  final List<Widget> _screens = [
    const OverviewScreen(),
    const CylindersScreen(),
    const OrdersScreen(),
    const AnalyticsScreen(),
    const MessagesScreen(),
    const SettingsScreen(),
  ];

  final List<String> _titles = [
    'Overview',
    'Cylinders',
    'Orders',
    'Analytics',
    'Messages',
    'Settings',
  ];

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 900;
    final isTablet = MediaQuery.of(context).size.width > 600 && 
                     MediaQuery.of(context).size.width <= 900;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppGradients.primaryBackground,
        ),
        child: SafeArea(
          child: Row(
            children: [
              // Sidebar - show on desktop and tablet
              if (isDesktop || isTablet)
                DashboardSidebar(
                  selectedIndex: _selectedIndex,
                  onItemSelected: (index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                ),
              
              // Main content
              Expanded(
                child: Column(
                  children: [
                    // Top App Bar
                    _buildTopAppBar(),
                    
                    // Screen content
                    Expanded(
                      child: _screens[_selectedIndex],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      // Bottom navigation for mobile
      bottomNavigationBar: isDesktop || isTablet
          ? null
          : _buildBottomNavigation(),
    );
  }

  /// Build top app bar
  Widget _buildTopAppBar() {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          decoration: BoxDecoration(
            color: AppColors.glassWhite,
            border: Border(
              bottom: BorderSide(
                color: AppColors.glassWhiteBorder,
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              // Title
              Text(
                _titles[_selectedIndex],
                style: AppTextStyles.onboardingTitle.copyWith(fontSize: 24),
              ),
              
              const Spacer(),
              
              // Search icon (mobile)
              if (MediaQuery.of(context).size.width <= 600)
                IconButton(
                  icon: const Icon(Icons.search, color: AppColors.white),
                  onPressed: () {
                    // TODO: Implement search
                  },
                ),
              
              // Search bar (desktop/tablet)
              if (MediaQuery.of(context).size.width > 600)
                Container(
                  width: 300,
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.glassWhite,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.glassWhiteBorder),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: AppColors.lightGray, size: 20),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: TextField(
                          style: const TextStyle(color: AppColors.white),
                          decoration: InputDecoration(
                            hintText: 'Search cylinders...',
                            hintStyle: TextStyle(
                              color: AppColors.lightGray.withOpacity(0.5),
                              fontSize: 14,
                            ),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              
              const SizedBox(width: AppSpacing.md),
              
              // Notifications
              IconButton(
                icon: Stack(
                  children: [
                    const Icon(Icons.notifications_outlined, color: AppColors.white),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
                onPressed: () {
                  // TODO: Open notifications
                },
              ),
              
              const SizedBox(width: AppSpacing.sm),
              
              // Profile avatar
              GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedIndex = 5; // Navigate to settings
                  });
                },
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.accentPurple,
                  child: const Icon(Icons.person, color: AppColors.white, size: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build bottom navigation for mobile
  Widget _buildBottomNavigation() {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.glassWhite,
            border: Border(
              top: BorderSide(
                color: AppColors.glassWhiteBorder,
                width: 1,
              ),
            ),
          ),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            backgroundColor: Colors.transparent,
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: AppColors.accentPurple,
            unselectedItemColor: AppColors.lightGray,
            selectedLabelStyle: AppTextStyles.buttonSecondary.copyWith(fontSize: 12),
            unselectedLabelStyle: AppTextStyles.buttonSecondary.copyWith(fontSize: 12),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard_outlined),
                activeIcon: Icon(Icons.dashboard),
                label: 'Overview',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.gas_meter_outlined),
                activeIcon: Icon(Icons.gas_meter),
                label: 'Cylinders',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_bag_outlined),
                activeIcon: Icon(Icons.shopping_bag),
                label: 'Orders',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.analytics_outlined),
                activeIcon: Icon(Icons.analytics),
                label: 'Analytics',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.message_outlined),
                activeIcon: Icon(Icons.message),
                label: 'Messages',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings_outlined),
                activeIcon: Icon(Icons.settings),
                label: 'Settings',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
