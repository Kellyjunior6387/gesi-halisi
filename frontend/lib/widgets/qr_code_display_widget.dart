/// QR Code Display Widget for Gesi Halisi Application
///
/// Displays a QR code for a minted cylinder with options to share/download
/// Features:
/// - QR code generation from cylinder data
/// - Share functionality
/// - Download/save option

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:convert';
import '../constants/app_theme.dart';
import '../models/cylinder_model.dart';

class QRCodeDisplayWidget extends StatelessWidget {
  final CylinderModel cylinder;

  const QRCodeDisplayWidget({
    super.key,
    required this.cylinder,
  });

  String _generateQRData() {
    // Generate JSON data for QR code
    final qrData = {
      'cylinderId': cylinder.id,
      'serialNumber': cylinder.serialNumber,
      'manufacturer': cylinder.manufacturer,
      'batchNumber': cylinder.batchNumber,
      'timestamp': cylinder.mintedAt?.millisecondsSinceEpoch ?? DateTime.now().millisecondsSinceEpoch,
    };
    return json.encode(qrData);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          gradient: AppGradients.glassGradient,
          borderRadius: BorderRadius.circular(AppBorderRadius.lg),
          border: Border.all(
            color: AppColors.glassWhiteBorder,
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'QR Code ya Silinda',
                  style: AppTextStyles.onboardingTitle.copyWith(fontSize: 20),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: AppColors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            
            const SizedBox(height: AppSpacing.lg),
            
            // QR Code
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppBorderRadius.md),
              ),
              child: QrImageView(
                data: _generateQRData(),
                version: QrVersions.auto,
                size: 250.0,
                backgroundColor: AppColors.white,
              ),
            ),
            
            const SizedBox(height: AppSpacing.lg),
            
            // Cylinder info
            Text(
              'S/N: ${cylinder.serialNumber}',
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: AppSpacing.sm),
            
            Text(
              cylinder.manufacturer,
              style: TextStyle(
                color: AppColors.lightGray.withOpacity(0.8),
                fontSize: 14,
              ),
            ),
            
            const SizedBox(height: AppSpacing.xl),
            
            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // TODO: Implement share functionality
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Share functionality coming soon'),
                          backgroundColor: AppColors.accentPurple,
                        ),
                      );
                    },
                    icon: const Icon(Icons.share, color: AppColors.white),
                    label: const Text(
                      'Share',
                      style: TextStyle(color: AppColors.white),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.accentPurple),
                      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppBorderRadius.md),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Implement download functionality
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Download functionality coming soon'),
                          backgroundColor: AppColors.accentPurple,
                        ),
                      );
                    },
                    icon: const Icon(Icons.download, color: AppColors.white),
                    label: const Text('Download'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accentPurple,
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppBorderRadius.md),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
