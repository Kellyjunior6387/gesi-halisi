/// Cylinders Screen
///
/// Displays and manages all cylinders

import 'package:flutter/material.dart';
import 'dart:ui' show ImageFilter;
import '../../constants/app_theme.dart';
import '../../services/firestore_service.dart';
import '../../services/auth_service.dart';
import '../../models/cylinder_model.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CylindersScreen extends StatefulWidget {
  const CylindersScreen({super.key});

  @override
  State<CylindersScreen> createState() => _CylindersScreenState();
}

class _CylindersScreenState extends State<CylindersScreen> {
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Minted', 'Pending', 'Error'];
  final FirestoreService _firestoreService = FirestoreService();

  // Mock data - will be replaced with Firebase data
  final List<Map<String, dynamic>> _cylinders = [];

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final user = authService.currentUser;

    if (user == null) {
      return const Center(
        child: Text(
          'Please log in to view cylinders',
          style: TextStyle(color: AppColors.white),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter chips
          _buildFilterChips(),
          
          const SizedBox(height: AppSpacing.lg),
          
          // Cylinders list from Firestore
          StreamBuilder<List<CylinderModel>>(
            stream: _firestoreService.streamCylindersForManufacturer(user.uid),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error loading cylinders: ${snapshot.error}',
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.accentPurple),
                  ),
                );
              }

              final cylinders = snapshot.data ?? [];

              if (cylinders.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 50),
                      Icon(
                        Icons.gas_meter_outlined,
                        size: 80,
                        color: AppColors.lightGray.withOpacity(0.3),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        'No cylinders registered yet',
                        style: AppTextStyles.onboardingTitle.copyWith(
                          fontSize: 18,
                          color: AppColors.lightGray,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Register your first cylinder to get started',
                        style: AppTextStyles.buttonSecondary.copyWith(
                          color: AppColors.lightGray.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                );
              }

              // Filter cylinders based on selected filter
              final filteredCylinders = _filterCylinders(cylinders);

              if (filteredCylinders.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    child: Text(
                      'No cylinders match the selected filter',
                      style: TextStyle(
                        color: AppColors.lightGray.withOpacity(0.7),
                      ),
                    ),
                  ),
                );
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredCylinders.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: _buildCylinderCard(filteredCylinders[index]),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  List<CylinderModel> _filterCylinders(List<CylinderModel> cylinders) {
    if (_selectedFilter == 'All') {
      return cylinders;
    }
    
    return cylinders.where((cylinder) {
      switch (_selectedFilter) {
        case 'Minted':
          return cylinder.status == CylinderStatus.minted;
        case 'Pending':
          return cylinder.status == CylinderStatus.pending;
        case 'Error':
          return cylinder.status == CylinderStatus.error;
        default:
          return true;
      }
    }).toList();
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

  Widget _buildCylinderCard(CylinderModel cylinder) {
    final isMinted = cylinder.isMinted;

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
                          cylinder.serialNumber,
                          style: AppTextStyles.buttonPrimary.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${cylinder.cylinderType} • ${cylinder.capacity} kg',
                          style: AppTextStyles.buttonSecondary.copyWith(
                            color: AppColors.lightGray,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildStatusChip(cylinder.status),
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
                      cylinder.batchNumber,
                      Icons.inventory_2,
                    ),
                  ),
                  Expanded(
                    child: _buildInfoItem(
                      'Mint Date',
                      cylinder.mintedAt != null 
                        ? _formatDate(cylinder.mintedAt!)
                        : 'Not minted',
                      Icons.calendar_today,
                    ),
                  ),
                ],
              ),
              
              if (isMinted) ...[
                const SizedBox(height: AppSpacing.sm),
                _buildInfoItem(
                  'Token ID',
                  '#${cylinder.tokenId}',
                  Icons.diamond,
                ),
                const SizedBox(height: AppSpacing.sm),
                _buildInfoItem(
                  'Transaction',
                  '${cylinder.transactionHash?.substring(0, 10)}...',
                  Icons.receipt_long,
                ),
              ],

              if (cylinder.hasError) ...[
                const SizedBox(height: AppSpacing.sm),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red, size: 20),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          cylinder.errorMessage ?? 'Minting failed',
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
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
                      () => _showCylinderDetails(cylinder),
                    ),
                  ),
                  if (isMinted && cylinder.explorerUrl != null) ...[
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: _buildActionButton(
                        'View on Chain',
                        Icons.open_in_new,
                        () => _openExplorer(cylinder.explorerUrl!),
                        isPrimary: true,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  void _showCylinderDetails(CylinderModel cylinder) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.darkPurple,
        title: Text(
          cylinder.serialNumber,
          style: const TextStyle(color: AppColors.white),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('Type', cylinder.cylinderType),
              _buildDetailRow('Weight', '${cylinder.weight} kg'),
              _buildDetailRow('Capacity', '${cylinder.capacity} kg'),
              _buildDetailRow('Batch', cylinder.batchNumber),
              _buildDetailRow('Manufacturer', cylinder.manufacturer),
              _buildDetailRow('Status', cylinder.status.displayName),
              if (cylinder.tokenId != null)
                _buildDetailRow('Token ID', cylinder.tokenId!),
              if (cylinder.transactionHash != null)
                _buildDetailRow('TX Hash', cylinder.transactionHash!),
              if (cylinder.blockNumber != null)
                _buildDetailRow('Block', cylinder.blockNumber.toString()),
              if (cylinder.blockchainNetwork != null)
                _buildDetailRow('Network', cylinder.blockchainNetwork!),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Close',
              style: TextStyle(color: AppColors.accentPurple),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: TextStyle(
                color: AppColors.lightGray.withOpacity(0.7),
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openExplorer(String url) {
    // In a real app, use url_launcher package
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Open: $url',
          style: const TextStyle(color: AppColors.white),
        ),
        backgroundColor: AppColors.accentPurple,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildStatusChip(CylinderStatus status) {
    Color color;
    String label;
    IconData icon;

    switch (status) {
      case CylinderStatus.minted:
        color = AppColors.safetyGreen;
        label = 'Minted';
        icon = Icons.check_circle;
        break;
      case CylinderStatus.pending:
        color = Colors.orange;
        label = 'Pending';
        icon = Icons.pending;
        break;
      case CylinderStatus.error:
        color = Colors.red;
        label = 'Error';
        icon = Icons.error;
        break;
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
