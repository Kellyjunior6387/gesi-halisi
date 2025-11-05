/// Register Cylinder Dialog
///
/// Modal dialog for registering new cylinders

import 'package:flutter/material.dart';
import 'dart:ui' show ImageFilter;
import '../../constants/app_theme.dart';

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
                                  onTap: () => Navigator.pop(context),
                                  isPrimary: false,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.md),
                              Expanded(
                                child: _buildButton(
                                  label: 'Register',
                                  onTap: _handleRegister,
                                  isPrimary: true,
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
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(color: AppColors.white),
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
    required VoidCallback onTap,
    required bool isPrimary,
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
            child: Text(
              label,
              style: AppTextStyles.buttonPrimary,
            ),
          ),
        ),
      ),
    );
  }

  void _handleRegister() {
    // TODO: Implement cylinder registration with Firebase
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Cylinder registration will be connected to Firebase',
          style: AppTextStyles.buttonSecondary.copyWith(color: AppColors.white),
        ),
        backgroundColor: AppColors.accentPurple,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
