/// Register Cylinder Dialog
///
/// Modal dialog for registering new cylinders

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:frontend/models/cylinder_model.dart';
import 'dart:ui' show ImageFilter;
import '../../constants/app_theme.dart';
import '../../services/firestore_service.dart';
import '../../services/auth_service.dart';
import '../../services/blockchain_service.dart';
import 'package:provider/provider.dart';

class RegisterCylinderDialog extends StatefulWidget {
  const RegisterCylinderDialog({super.key});

  @override
  State<RegisterCylinderDialog> createState() => _RegisterCylinderDialogState();
}

class _RegisterCylinderDialogState extends State<RegisterCylinderDialog> {
  final _formKey = GlobalKey<FormState>();
  final _serialNumberController = TextEditingController();
  final _capacityController = TextEditingController();
  final _batchNumberController = TextEditingController();
  
  String _selectedType = 'LPG';
  final List<String> _cylinderTypes = ['LPG', 'Oxygen', 'CO2', 'Nitrogen'];
  bool _isLoading = false;
  bool _showSuccess = false;
  String? _transactionHash;
  String? _contractAddress;
  String? _tokenId;

  @override
  void dispose() {
    _serialNumberController.dispose();
    _capacityController.dispose();
    _batchNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: MediaQuery.of(context).size.width > 600 ? 500 : double.infinity,
            constraints: const BoxConstraints(maxHeight: 600),
            decoration: BoxDecoration(
              color: AppColors.darkPurple.withOpacity(0.9),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.glassWhiteBorder),
            ),
            child: _showSuccess ? _buildSuccessView() : _buildFormView(),
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.safetyGreen, AppColors.safetyGreen.withOpacity(0.7)],
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Icon(
                  Icons.check_circle,
                  color: AppColors.safetyGreen,
                  size: 32,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  'NFT Minted Successfully!',
                  style: AppTextStyles.onboardingTitle.copyWith(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Success content
        Flexible(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Your cylinder has been successfully registered on the blockchain!',
                  style: TextStyle(
                    color: AppColors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
                
                const SizedBox(height: AppSpacing.xl),
                
                _buildInfoRow('Contract Address', _contractAddress ?? 'N/A', Icons.article),
                const SizedBox(height: AppSpacing.md),
                _buildInfoRow('Transaction Hash', _transactionHash ?? 'N/A', Icons.receipt_long),
                const SizedBox(height: AppSpacing.md),
                _buildInfoRow('Token ID', _tokenId ?? 'N/A', Icons.diamond),
                
                const SizedBox(height: AppSpacing.xl),
                
                // View on Explorer button
                Container(
                  width: double.infinity,
                  height: 50,
                  decoration: AppDecorations.secondaryButton(),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _openBlockchainExplorer,
                      borderRadius: BorderRadius.circular(12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.open_in_new, color: AppColors.white, size: 20),
                          const SizedBox(width: AppSpacing.sm),
                          Text(
                            'View on Explorer',
                            style: AppTextStyles.buttonPrimary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: AppSpacing.md),
                
                // Close button
                Container(
                  width: double.infinity,
                  height: 50,
                  decoration: AppDecorations.primaryButton(),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _handleClose,
                      borderRadius: BorderRadius.circular(12),
                      child: Center(
                        child: Text(
                          'Done',
                          style: AppTextStyles.buttonPrimary,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.glassWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.glassWhiteBorder),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.accentPurple, size: 20),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: AppColors.lightGray.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value.length > 40 ? '${value.substring(0, 20)}...${value.substring(value.length - 20)}' : value,
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.glassWhite,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: AppGradients.accentGradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.add_circle_outline,
                  color: AppColors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Text(
                'Register New Cylinder',
                style: AppTextStyles.onboardingTitle.copyWith(fontSize: 20),
              ),
              const Spacer(),
              IconButton(
                icon: Icon(Icons.close, color: AppColors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),

        // Form
        Flexible(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextField(
                    controller: _serialNumberController,
                    label: 'Serial Number',
                    hint: 'Enter cylinder serial number',
                    icon: Icons.tag,
                  ),

                  const SizedBox(height: AppSpacing.md),

                  _buildTypeDropdown(),

                  const SizedBox(height: AppSpacing.md),

                  _buildTextField(
                    controller: _capacityController,
                    label: 'Capacity (kg)',
                    hint: 'Enter capacity',
                    icon: Icons.scale,
                    keyboardType: TextInputType.number,
                  ),

                  const SizedBox(height: AppSpacing.md),

                  _buildTextField(
                    controller: _batchNumberController,
                    label: 'Batch Number',
                    hint: 'Enter batch number',
                    icon: Icons.inventory_2,
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  // Buttons
                  Row(
                    children: [
                      Expanded(
                        child: _buildButton(
                          label: 'Cancel',
                          onTap: _isLoading ? null : () => Navigator.pop(context),
                          isPrimary: false,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: _buildButton(
                          label: _isLoading ? 'Minting NFT...' : 'Register & Mint',
                          onTap: _isLoading ? null : _handleRegister,
                          isPrimary: true,
                          isLoading: _isLoading,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.buttonSecondary.copyWith(
            color: AppColors.white,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(color: AppColors.white),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'This field is required';
            }
            if (keyboardType == TextInputType.number) {
              if (double.tryParse(value) == null) {
                return 'Please enter a valid number';
              }
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: AppColors.lightGray.withOpacity(0.5)),
            prefixIcon: Icon(icon, color: AppColors.lightGray),
            filled: true,
            fillColor: AppColors.glassWhite,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.glassWhiteBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.glassWhiteBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.accentPurple, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            errorStyle: const TextStyle(color: Colors.red, fontSize: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildTypeDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Cylinder Type',
          style: AppTextStyles.buttonSecondary.copyWith(
            color: AppColors.white,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.glassWhite,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.glassWhiteBorder),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedType,
              isExpanded: true,
              dropdownColor: AppColors.darkPurple,
              icon: const Icon(Icons.arrow_drop_down, color: AppColors.white),
              style: const TextStyle(color: AppColors.white, fontSize: 16),
              items: _cylinderTypes.map((type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedType = value!;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildButton({
    required String label,
    required VoidCallback? onTap,
    required bool isPrimary,
    bool isLoading = false,
  }) {
    return Container(
      height: 50,
      decoration: isPrimary
          ? AppDecorations.primaryButton()
          : AppDecorations.secondaryButton(),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Center(
            child: isLoading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                    ),
                  )
                : Text(
                    label,
                    style: AppTextStyles.buttonPrimary,
                  ),
          ),
        ),
      ),
    );
  }

  void _handleRegister() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_serialNumberController.text.trim().isEmpty ||
        _capacityController.text.trim().isEmpty ||
        _batchNumberController.text.trim().isEmpty) {
      _showErrorSnackBar('Please fill in all fields');
      return;
    }

    setState(() {
      _isLoading = true;
      _showSuccess = false;
    });

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final firestoreService = FirestoreService();
      final blockchainService = BlockchainService();
      final user = authService.currentUser;

      if (user == null) {
        throw Exception('User not authenticated');
      }

      // Get user profile to get manufacturer info
      final userProfile = await firestoreService.getUserProfile(user.uid);
      if (userProfile == null) {
        throw Exception('User profile not found');
      }

      // Check if user is a manufacturer (admin validation)
      if (userProfile.role.name != 'manufacturer') {
        throw Exception('Only manufacturers can register cylinders');
      }

      final capacity = double.tryParse(_capacityController.text.trim()) ?? 0.0;
      final serialNumber = _serialNumberController.text.trim();
      final batchNumber = _batchNumberController.text.trim();

      // First, create cylinder document in Firestore with pending status
      final cylinderId = await firestoreService.registerCylinder(
        serialNumber: serialNumber,
        manufacturer: userProfile.fullName,
        manufacturerId: user.uid,
        cylinderType: _selectedType,
        weight: capacity,
        capacity: capacity,
        batchNumber: batchNumber,
      );

      if (!mounted) return;

      // Call blockchain webhook to mint NFT
      debugPrint('🔗 Calling blockchain webhook...');
      final response = await blockchainService.mintCylinderNFT(
        serialNumber: serialNumber,
        manufacturer: userProfile.fullName,
        manufacturerId: user.uid,
        cylinderType: _selectedType,
        weight: capacity,
        capacity: capacity,
        batchNumber: batchNumber,
      );

      if (!mounted) return;

      if (response.success && 
          response.transactionHash != null && 
          response.contractAddress != null && 
          response.tokenId != null) {
        // Success! Update Firestore with blockchain data
        await firestoreService.updateCylinderBlockchainData(
          cylinderId: cylinderId,
          transactionHash: response.transactionHash!,
          contractAddress: response.contractAddress!,
          tokenId: response.tokenId!,
        );

        // Show success UI
        setState(() {
          _isLoading = false;
          _showSuccess = true;
          _transactionHash = response.transactionHash;
          _contractAddress = response.contractAddress;
          _tokenId = response.tokenId;
        });

        debugPrint('✅ Cylinder registered and minted successfully!');
      } else {
        // Minting failed - update status to error
                await firestoreService.updateCylinderStatus(
                  cylinderId: cylinderId,
                  status: CylinderStatus.error,
                  errorMessage: response.errorMessage ?? 'NFT minting failed',
                );

        throw Exception(response.errorMessage ?? 'Failed to mint NFT');
      }
    } catch (e) {
      debugPrint('❌ Error registering cylinder: $e');

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      _showErrorSnackBar('Error: ${e.toString()}');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: AppTextStyles.buttonSecondary.copyWith(color: AppColors.white),
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _handleClose() {
    Navigator.pop(context, _showSuccess);
  }

  void _openBlockchainExplorer() {
    if (_transactionHash != null) {
      // For now, just show the hash in a snackbar
      // In production, use url_launcher to open the actual block explorer
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Transaction: $_transactionHash\nOpen in block explorer',
            style: const TextStyle(color: AppColors.white),
          ),
          backgroundColor: AppColors.accentPurple,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }
}
