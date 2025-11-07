/// Overview Screen for Manufacturer Dashboard
///
/// Displays key metrics and statistics

import 'package:flutter/material.dart';
import 'dart:ui' show ImageFilter;
import 'package:fl_chart/fl_chart.dart';
import '../../constants/app_theme.dart';
import '../../widgets/dashboard/metric_card.dart';
import '../../widgets/dashboard/register_cylinder_dialog.dart';

class OverviewScreen extends StatelessWidget {
  const OverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 900;
    final isTablet = MediaQuery.of(context).size.width > 600 &&
        MediaQuery.of(context).size.width <= 900;

    return SingleChildScrollView(
      padding: EdgeInsets.all(isDesktop ? AppSpacing.xl : AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome message
          Text(
            'Welcome back! 👋',
            style: AppTextStyles.onboardingTitle.copyWith(fontSize: 28),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Here\'s what\'s happening with your cylinders today.',
            style: AppTextStyles.onboardingDescription,
          ),

          const SizedBox(height: AppSpacing.xl),

          // Metrics Grid
          _buildMetricsGrid(isDesktop, isTablet),

          const SizedBox(height: AppSpacing.xl),

          // Register button and chart
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: _buildMintingChart(),
              ),
              if (isDesktop || isTablet) const SizedBox(width: AppSpacing.lg),
              if (isDesktop || isTablet)
                Expanded(
                  child: _buildQuickActions(context),
                ),
            ],
          ),

          if (!isDesktop && !isTablet) ...[
            const SizedBox(height: AppSpacing.lg),
            _buildQuickActions(context),
          ],
        ],
      ),
    );
  }

  Widget _buildMetricsGrid(bool isDesktop, bool isTablet) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount;
        if (isDesktop) {
          crossAxisCount = 4;
        } else if (isTablet) {
          crossAxisCount = 2;
        } else {
          crossAxisCount = 1;
        }

        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: AppSpacing.md,
          crossAxisSpacing: AppSpacing.md,
          childAspectRatio: isDesktop ? 1.5 : (isTablet ? 2 : 3),
          children: const [
            MetricCard(
              title: 'Total Cylinders',
              value: '1,234',
              icon: Icons.gas_meter,
              gradient: LinearGradient(
                colors: [Color(0xFF667eea), Color(0xFF764ba2)],
              ),
              trend: '+12%',
              trendUp: true,
            ),
            MetricCard(
              title: 'Verified Cylinders',
              value: '1,089',
              icon: Icons.verified,
              gradient: LinearGradient(
                colors: [Color(0xFF11998e), Color(0xFF38ef7d)],
              ),
              trend: '+8%',
              trendUp: true,
            ),
            MetricCard(
              title: 'Active Orders',
              value: '45',
              icon: Icons.shopping_bag,
              gradient: LinearGradient(
                colors: [Color(0xFFf093fb), Color(0xFFf5576c)],
              ),
              trend: '+5%',
              trendUp: true,
            ),
            MetricCard(
              title: 'Minted NFTs',
              value: '987',
              icon: Icons.diamond,
              gradient: LinearGradient(
                colors: [Color(0xFFfa709a), Color(0xFFfee140)],
              ),
              trend: '-2%',
              trendUp: false,
            ),
          ],
        );
      },
    );
  }

  Widget _buildMintingChart() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: AppDecorations.glassCard(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Monthly Minting Activity',
                    style: AppTextStyles.onboardingTitle.copyWith(fontSize: 18),
                  ),
                  Icon(
                    Icons.trending_up,
                    color: AppColors.safetyGreen,
                    size: 24,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),
              SizedBox(
                height: 200,
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: 50,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: AppColors.glassWhiteBorder,
                          strokeWidth: 1,
                        );
                      },
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
                            if (value.toInt() >= 0 && value.toInt() < months.length) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  months[value.toInt()],
                                  style: TextStyle(
                                    color: AppColors.lightGray,
                                    fontSize: 12,
                                  ),
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              value.toInt().toString(),
                              style: TextStyle(
                                color: AppColors.lightGray,
                                fontSize: 12,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: const [
                          FlSpot(0, 120),
                          FlSpot(1, 145),
                          FlSpot(2, 135),
                          FlSpot(3, 165),
                          FlSpot(4, 180),
                          FlSpot(5, 195),
                        ],
                        isCurved: true,
                        gradient: AppGradients.accentGradient,
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) {
                            return FlDotCirclePainter(
                              radius: 4,
                              color: AppColors.accentPurple,
                              strokeWidth: 2,
                              strokeColor: AppColors.white,
                            );
                          },
                        ),
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              AppColors.accentPurple.withOpacity(0.3),
                              AppColors.accentPurple.withOpacity(0.0),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: AppDecorations.glassCard(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Quick Actions',
                style: AppTextStyles.onboardingTitle.copyWith(fontSize: 18),
              ),
              const SizedBox(height: AppSpacing.lg),
              _buildActionButton(
                context: context,
                icon: Icons.add_circle_outline,
                label: 'Register New Cylinder',
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => const RegisterCylinderDialog(),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.md),
              _buildActionButton(
                context: context,
                icon: Icons.qr_code_scanner,
                label: 'Scan QR Code',
                onTap: () {
                  // TODO: Implement QR scanning
                },
              ),
              const SizedBox(height: AppSpacing.md),
              _buildActionButton(
                context: context,
                icon: Icons.upload_file,
                label: 'Batch Upload',
                onTap: () {
                  // TODO: Implement batch upload
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.glassWhite,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.glassWhiteBorder),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: AppGradients.accentGradient,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: AppColors.white, size: 20),
            ),
            const SizedBox(width: AppSpacing.md),
            Text(
              label,
              style: AppTextStyles.buttonPrimary.copyWith(fontSize: 14),
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
    );
  }
}
