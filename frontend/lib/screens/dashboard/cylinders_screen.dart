/// Cylinders Screen
///
/// Displays and manages all cylinders

import 'package:flutter/material.dart';
import 'dart:ui' show ImageFilter;
import '../../constants/app_theme.dart';

class CylindersScreen extends StatefulWidget {
  const CylindersScreen({super.key});

  @override
  State<CylindersScreen> createState() => _CylindersScreenState();
}

class _CylindersScreenState extends State<CylindersScreen> {
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Verified', 'Pending', 'Minted'];

  // Mock data - will be replaced with Firebase data
  final List<Map<String, dynamic>> _cylinders = [
    {
      'serial': 'CYL-2024-001',
      'status': 'verified',
      'type': 'LPG',
      'capacity': '14.2 kg',
      'batch': 'BATCH-2024-01',
      'mintDate': '2024-01-15',
      'tokenId': '#NFT-001',
    },
    {
      'serial': 'CYL-2024-002',
      'status': 'pending',
      'type': 'LPG',
      'capacity': '14.2 kg',
      'batch': 'BATCH-2024-01',
      'mintDate': null,
      'tokenId': null,
    },
    {
      'serial': 'CYL-2024-003',
      'status': 'verified',
      'type': 'Oxygen',
      'capacity': '10 kg',
      'batch': 'BATCH-2024-02',
      'mintDate': '2024-01-20',
      'tokenId': '#NFT-002',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter chips
          _buildFilterChips(),
          
          const SizedBox(height: AppSpacing.lg),
          
          // Cylinders list
          _buildCylindersList(),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Wrap(
      spacing: AppSpacing.sm,
      children: _filters.map((filter) {
        final isSelected = _selectedFilter == filter;
        return FilterChip(
          label: Text(
            filter,
            style: TextStyle(
              color: isSelected ? AppColors.white : AppColors.lightGray,
            ),
          ),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              _selectedFilter = filter;
            });
          },
          backgroundColor: AppColors.glassWhite,
          selectedColor: AppColors.accentPurple,
          checkmarkColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: isSelected ? AppColors.accentPurple : AppColors.glassWhiteBorder,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCylindersList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _cylinders.length,
      itemBuilder: (context, index) {
        final cylinder = _cylinders[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: _buildCylinderCard(cylinder),
        );
      },
    );
  }

  Widget _buildCylinderCard(Map<String, dynamic> cylinder) {
    final isVerified = cylinder['status'] == 'verified';
    final isMinted = cylinder['tokenId'] != null;

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: AppDecorations.glassCard(borderRadius: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: AppGradients.accentGradient,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.gas_meter,
                      color: AppColors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cylinder['serial'],
                          style: AppTextStyles.buttonPrimary.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${cylinder['type']} • ${cylinder['capacity']}',
                          style: AppTextStyles.buttonSecondary.copyWith(
                            color: AppColors.lightGray,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildStatusChip(cylinder['status']),
                ],
              ),
              
              const SizedBox(height: AppSpacing.md),
              
              Divider(color: AppColors.glassWhiteBorder),
              
              const SizedBox(height: AppSpacing.md),
              
              // Details
              Row(
                children: [
                  Expanded(
                    child: _buildInfoItem(
                      'Batch',
                      cylinder['batch'],
                      Icons.inventory_2,
                    ),
                  ),
                  Expanded(
                    child: _buildInfoItem(
                      'Mint Date',
                      cylinder['mintDate'] ?? 'Not minted',
                      Icons.calendar_today,
                    ),
                  ),
                ],
              ),
              
              if (isMinted) ...[
                const SizedBox(height: AppSpacing.sm),
                _buildInfoItem(
                  'Token ID',
                  cylinder['tokenId'],
                  Icons.diamond,
                ),
              ],
              
              const SizedBox(height: AppSpacing.md),
              
              // Actions
              Row(
                children: [
                  Expanded(
                    child: _buildActionButton(
                      'View Details',
                      Icons.info_outline,
                      () {},
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  if (!isMinted && isVerified)
                    Expanded(
                      child: _buildActionButton(
                        'Mint NFT',
                        Icons.diamond_outlined,
                        () {},
                        isPrimary: true,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    String label;
    IconData icon;

    switch (status) {
      case 'verified':
        color = AppColors.safetyGreen;
        label = 'Verified';
        icon = Icons.check_circle;
        break;
      case 'pending':
        color = Colors.orange;
        label = 'Pending';
        icon = Icons.pending;
        break;
      default:
        color = AppColors.lightGray;
        label = status;
        icon = Icons.info;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppColors.lightGray, size: 16),
        const SizedBox(width: AppSpacing.sm),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: AppColors.lightGray.withOpacity(0.7),
                fontSize: 12,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(
    String label,
    IconData icon,
    VoidCallback onTap, {
    bool isPrimary = false,
  }) {
    return Container(
      height: 40,
      decoration: isPrimary
          ? AppDecorations.primaryButton(borderRadius: 10)
          : AppDecorations.secondaryButton(borderRadius: 10),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: AppColors.white, size: 18),
              const SizedBox(width: 6),
              Text(
                label,
                style: AppTextStyles.buttonPrimary.copyWith(fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
