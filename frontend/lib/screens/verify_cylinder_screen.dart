/// Verify Cylinder Screen for Gesi Halisi Application
///
/// Allows customers to scan QR codes and verify cylinder authenticity
/// Features:
/// - QR code scanner
/// - Firestore verification
/// - Display cylinder details

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants/app_theme.dart';
import '../models/cylinder_model.dart';
import 'dart:convert';

class VerifyCylinderScreen extends StatefulWidget {
  const VerifyCylinderScreen({super.key});

  @override
  State<VerifyCylinderScreen> createState() => _VerifyCylinderScreenState();
}

class _VerifyCylinderScreenState extends State<VerifyCylinderScreen> {
  final MobileScannerController _scannerController = MobileScannerController();
  bool _isScanning = true;
  bool _isVerifying = false;
  CylinderModel? _verifiedCylinder;
  String? _errorMessage;

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                child: _buildContent(),
              ),
            ],
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
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.white),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            'Thibitisha Silinda',
            style: AppTextStyles.onboardingTitle.copyWith(fontSize: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_isVerifying) {
      return _buildLoadingState();
    }

    if (_verifiedCylinder != null) {
      return _buildVerificationResult();
    }

    if (_errorMessage != null) {
      return _buildErrorResult();
    }

    return _buildScannerView();
  }

  Widget _buildScannerView() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Text(
            'Elekeza kamera kwenye QR code ya silinda',
            style: AppTextStyles.onboardingDescription.copyWith(
              color: AppColors.lightGray,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppBorderRadius.lg),
              child: MobileScanner(
                controller: _scannerController,
                onDetect: (capture) {
                  final List<Barcode> barcodes = capture.barcodes;
                  if (barcodes.isNotEmpty && _isScanning) {
                    final String? code = barcodes.first.rawValue;
                    if (code != null) {
                      _handleQRCodeScanned(code);
                    }
                  }
                },
              ),
            ),
          ),
        ),
        
        Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: ElevatedButton.icon(
            onPressed: () {
              setState(() {
                _isScanning = true;
                _errorMessage = null;
                _verifiedCylinder = null;
              });
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Rudia Scan'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentPurple,
              foregroundColor: AppColors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xl,
                vertical: AppSpacing.md,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppBorderRadius.md),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.accentPurple),
          ),
          SizedBox(height: AppSpacing.lg),
          Text(
            'Inathibitisha...',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerificationResult() {
    final cylinder = _verifiedCylinder!;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          // Success icon
          Container(
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(
              color: AppColors.safetyGreen.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle,
              color: AppColors.safetyGreen,
              size: 80,
            ),
          ),
          
          const SizedBox(height: AppSpacing.xl),
          
          Text(
            '✅ Silinda Halisi',
            style: AppTextStyles.onboardingTitle.copyWith(
              color: AppColors.safetyGreen,
              fontSize: 28,
            ),
          ),
          
          const SizedBox(height: AppSpacing.md),
          
          Text(
            'Silinda hii imethibitishwa na ni halisi',
            style: AppTextStyles.onboardingDescription.copyWith(
              color: AppColors.lightGray,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: AppSpacing.xl),
          
          // Cylinder details card
          Container(
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
                const Text(
                  'Maelezo ya Silinda',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                _buildDetailRow('Nambari ya Silinda', cylinder.serialNumber),
                _buildDetailRow('Mtengenezaji', cylinder.manufacturer),
                _buildDetailRow('Aina', cylinder.cylinderType),
                _buildDetailRow('Uzito', '${cylinder.weight} kg'),
                _buildDetailRow('Uwezo', '${cylinder.capacity} kg'),
                _buildDetailRow('Batch', cylinder.batchNumber),
                if (cylinder.mintedAt != null)
                  _buildDetailRow(
                    'Tarehe',
                    _formatDate(cylinder.mintedAt!),
                  ),
              ],
            ),
          ),
          
          const SizedBox(height: AppSpacing.xl),
          
          // Scan another button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _isScanning = true;
                  _verifiedCylinder = null;
                  _errorMessage = null;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentPurple,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppBorderRadius.md),
                ),
              ),
              child: const Text(
                'Thibitisha Silinda Nyingine',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorResult() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 60),
          
          // Error icon
          Container(
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.cancel,
              color: Colors.red,
              size: 80,
            ),
          ),
          
          const SizedBox(height: AppSpacing.xl),
          
          Text(
            '❌ Silinda Batili',
            style: AppTextStyles.onboardingTitle.copyWith(
              color: Colors.red,
              fontSize: 28,
            ),
          ),
          
          const SizedBox(height: AppSpacing.md),
          
          Text(
            _errorMessage ?? 'Silinda hii haikupatikana katika mfumo wetu',
            style: AppTextStyles.onboardingDescription.copyWith(
              color: AppColors.lightGray,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: AppSpacing.xl),
          
          // Warning message
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppBorderRadius.md),
              border: Border.all(
                color: Colors.red.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.warning_amber,
                  color: Colors.orange,
                  size: 32,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    'Usitumie silinda hii. Inaweza kuwa bandia au hatari.',
                    style: TextStyle(
                      color: AppColors.lightGray.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: AppSpacing.xl),
          
          // Try again button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _isScanning = true;
                  _verifiedCylinder = null;
                  _errorMessage = null;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentPurple,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppBorderRadius.md),
                ),
              ),
              child: const Text(
                'Jaribu Tena',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
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
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleQRCodeScanned(String code) async {
    setState(() {
      _isScanning = false;
      _isVerifying = true;
    });

    try {
      // Parse QR code data (expecting JSON)
      Map<String, dynamic> qrData;
      try {
        qrData = json.decode(code);
      } catch (e) {
        // If not JSON, try to use as cylinder ID directly
        qrData = {'cylinderId': code};
      }

      final cylinderId = qrData['cylinderId'] as String?;
      
      if (cylinderId == null) {
        setState(() {
          _errorMessage = 'QR code si sahihi';
          _isVerifying = false;
        });
        return;
      }

      // Query Firestore for cylinder
      final cylinderDoc = await FirebaseFirestore.instance
          .collection('cylinders')
          .doc(cylinderId)
          .get();

      if (cylinderDoc.exists) {
        final cylinder = CylinderModel.fromFirestore(cylinderDoc);
        
        // Check if cylinder is minted (valid)
        if (cylinder.status == CylinderStatus.minted) {
          setState(() {
            _verifiedCylinder = cylinder;
            _isVerifying = false;
          });
        } else {
          setState(() {
            _errorMessage = 'Silinda bado haijakamilika';
            _isVerifying = false;
          });
        }
      } else {
        setState(() {
          _errorMessage = 'Silinda hii haikupatikana';
          _isVerifying = false;
        });
      }
    } catch (e) {
      debugPrint('Error verifying cylinder: $e');
      setState(() {
        _errorMessage = 'Hitilafu imetokea. Jaribu tena.';
        _isVerifying = false;
      });
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
