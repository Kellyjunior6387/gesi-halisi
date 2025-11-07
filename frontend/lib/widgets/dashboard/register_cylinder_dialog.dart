/// Register Cylinder Dialog
///
/// Modal dialog for registering new cylinders

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'dart:ui' show ImageFilter;
import '../../constants/app_theme.dart';
import '../../services/firestore_service.dart';
import '../../services/auth_service.dart';
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
            child: Column(
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
                        child: const Icon(
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
                        icon: const Icon(Icons.close, color: AppColors.white),
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
                                  label: _isLoading ? 'Registering...' : 'Register',
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
            ),
          ),
        ),
      ),
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
                ? const SizedBox(
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please fill in all fields',
            style: AppTextStyles.buttonSecondary.copyWith(color: AppColors.white),
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final firestoreService = FirestoreService();
      final user = authService.currentUser;

      if (user == null) {
        throw Exception('User not authenticated');
      }

      // Get user profile to get manufacturer info
      final userProfile = await firestoreService.getUserProfile(user.uid);
      if (userProfile == null) {
        throw Exception('User profile not found');
      }

      final capacity = double.tryParse(_capacityController.text.trim()) ?? 0.0;

      // Register the cylinder in Firestore
      // This will trigger the Cloud Function to mint the NFT
      final cylinderId = await firestoreService.registerCylinder(
        serialNumber: _serialNumberController.text.trim(),
        manufacturer: userProfile.fullName,
        manufacturerId: user.uid,
        cylinderType: _selectedType,
        weight: capacity, // Using capacity as weight for now
        capacity: capacity,
        batchNumber: _batchNumberController.text.trim(),
      );

      if (!mounted) return;

      Navigator.pop(context, true); // Return true to indicate success

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Cylinder registered successfully! NFT minting in progress...',
            style: AppTextStyles.buttonSecondary.copyWith(color: AppColors.white),
          ),
          backgroundColor: AppColors.safetyGreen,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );

      debugPrint('✅ Cylinder registered: $cylinderId');
    } catch (e) {
      debugPrint('❌ Error registering cylinder: $e');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error: ${e.toString()}',
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
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
