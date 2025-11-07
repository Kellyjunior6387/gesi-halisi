/// Gesi Halisi Sign Up Screen
///
/// This screen allows new users to create an account with email/password
/// or through OAuth providers (Google, Apple, GitHub).
///
/// Features:
/// - Email and password registration
/// - OAuth sign-in options
/// - Input validation (UI only, Firebase logic to be added)
/// - Phone number with country code selection
/// - Navigation to login screen
///
/// Security Features:
/// - Password confirmation field
/// - Input validation will be implemented with Firebase
/// - OAuth handled by Firebase Authentication

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui' show ImageFilter;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../constants/app_theme.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import 'login_screen.dart';
import 'dashboard/manufacturer_dashboard.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // Form key for validation
  final _formKey = GlobalKey<FormState>();
  
  // Text controllers
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  // Password visibility toggles
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  
  // Selected country code
  String _selectedCountryCode = '+1';
  
  // Selected user role
  UserRole _selectedRole = UserRole.customer;
  
  // Loading state
  bool _isLoading = false;
  
  // Common country codes
  final List<Map<String, String>> _countryCodes = [
    {'code': '+1', 'country': 'US/CA'},
    {'code': '+44', 'country': 'UK'},
    {'code': '+254', 'country': 'Kenya'},
    {'code': '+255', 'country': 'Tanzania'},
    {'code': '+256', 'country': 'Uganda'},
    {'code': '+91', 'country': 'India'},
    {'code': '+234', 'country': 'Nigeria'},
  ];

  @override
  void initState() {
    super.initState();
    
    // Set status bar to transparent
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  @override
  void dispose() {
    // Clean up controllers
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
          child: CustomScrollView(
            slivers: [
              // App bar
              SliverAppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: AppColors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              
              // Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        'Create Account',
                        style: AppTextStyles.logo.copyWith(fontSize: 36),
                      ),
                      
                      const SizedBox(height: AppSpacing.sm),
                      
                      // Subtitle
                      Text(
                        'Sign up to get started',
                        style: AppTextStyles.onboardingDescription,
                      ),
                      
                      const SizedBox(height: AppSpacing.xxl),
                      
                      // Sign up form
                      _buildSignUpForm(),
                      
                      const SizedBox(height: AppSpacing.xl),
                      
                      // Divider with "OR"
                      _buildDivider(),
                      
                      const SizedBox(height: AppSpacing.xl),
                      
                      // OAuth buttons
                      _buildOAuthButtons(),
                      
                      const SizedBox(height: AppSpacing.xl),
                      
                      // Login link
                      _buildLoginLink(),
                      
                      const SizedBox(height: AppSpacing.xl),
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

  /// Builds the sign up form with glassmorphic style
  Widget _buildSignUpForm() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: AppDecorations.glassCard(),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // First Name
                _buildTextField(
                  controller: _firstNameController,
                  label: 'First Name',
                  hint: 'Enter your first name',
                  icon: Icons.person_outline,
                ),
                
                const SizedBox(height: AppSpacing.md),
                
                // Last Name
                _buildTextField(
                  controller: _lastNameController,
                  label: 'Last Name',
                  hint: 'Enter your last name',
                  icon: Icons.person_outline,
                ),
                
                const SizedBox(height: AppSpacing.md),
                
                // Phone Number with Country Code
                _buildPhoneField(),
                
                const SizedBox(height: AppSpacing.md),
                
                // Email
                _buildTextField(
                  controller: _emailController,
                  label: 'Email',
                  hint: 'Enter your email',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                ),
                
                const SizedBox(height: AppSpacing.md),
                
                // Role Selection
                _buildRoleSelector(),
                
                const SizedBox(height: AppSpacing.md),
                
                // Password
                _buildTextField(
                  controller: _passwordController,
                  label: 'Password',
                  hint: 'Enter your password',
                  icon: Icons.lock_outline,
                  isPassword: true,
                  obscureText: _obscurePassword,
                  onToggleVisibility: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
                
                const SizedBox(height: AppSpacing.md),
                
                // Confirm Password
                _buildTextField(
                  controller: _confirmPasswordController,
                  label: 'Confirm Password',
                  hint: 'Re-enter your password',
                  icon: Icons.lock_outline,
                  isPassword: true,
                  obscureText: _obscureConfirmPassword,
                  onToggleVisibility: () {
                    setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    });
                  },
                ),
                
                const SizedBox(height: AppSpacing.xl),
                
                // Sign Up Button
                _buildSignUpButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the role selector dropdown
  Widget _buildRoleSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Your Role',
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
            child: DropdownButton<UserRole>(
              value: _selectedRole,
              isExpanded: true,
              dropdownColor: AppColors.darkPurple,
              icon: const Icon(Icons.arrow_drop_down, color: AppColors.white),
              style: const TextStyle(color: AppColors.white, fontSize: 16),
              items: UserRole.values.map((role) {
                IconData icon;
                switch (role) {
                  case UserRole.manufacturer:
                    icon = Icons.factory;
                    break;
                  case UserRole.distributor:
                    icon = Icons.local_shipping;
                    break;
                  case UserRole.customer:
                    icon = Icons.person;
                    break;
                }
                
                return DropdownMenuItem<UserRole>(
                  value: role,
                  child: Row(
                    children: [
                      Icon(icon, color: AppColors.accentPurple, size: 20),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        role.displayName,
                        style: const TextStyle(color: AppColors.white),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedRole = value!;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  /// Builds a text field with glassmorphic style
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onToggleVisibility,
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
          obscureText: obscureText,
          keyboardType: keyboardType,
          style: const TextStyle(color: AppColors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: AppColors.lightGray.withOpacity(0.5)),
            prefixIcon: Icon(icon, color: AppColors.lightGray),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                      color: AppColors.lightGray,
                    ),
                    onPressed: onToggleVisibility,
                  )
                : null,
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

  /// Builds the phone number field with country code dropdown
  Widget _buildPhoneField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Phone Number',
          style: AppTextStyles.buttonSecondary.copyWith(
            color: AppColors.white,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            // Country Code Dropdown
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.glassWhite,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.glassWhiteBorder),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedCountryCode,
                  dropdownColor: AppColors.darkPurple,
                  icon: const Icon(Icons.arrow_drop_down, color: AppColors.white),
                  style: const TextStyle(color: AppColors.white),
                  items: _countryCodes.map((country) {
                    return DropdownMenuItem<String>(
                      value: country['code'],
                      child: Text(
                        '${country['code']} ${country['country']}',
                        style: const TextStyle(color: AppColors.white),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCountryCode = value!;
                    });
                  },
                ),
              ),
            ),
            
            const SizedBox(width: AppSpacing.md),
            
            // Phone Number Input
            Expanded(
              child: TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                style: const TextStyle(color: AppColors.white),
                decoration: InputDecoration(
                  hintText: 'Phone number',
                  hintStyle: TextStyle(color: AppColors.lightGray.withOpacity(0.5)),
                  prefixIcon: const Icon(Icons.phone_outlined, color: AppColors.lightGray),
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
            ),
          ],
        ),
      ],
    );
  }

  /// Builds the sign up button
  Widget _buildSignUpButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: AppDecorations.primaryButton(),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _isLoading ? null : _handleSignUp,
          borderRadius: BorderRadius.circular(12),
          child: Center(
            child: _isLoading
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      color: AppColors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    'Sign Up',
                    style: AppTextStyles.buttonPrimary,
                  ),
          ),
        ),
      ),
    );
  }

  /// Handle sign up with Firebase
  Future<void> _handleSignUp() async {
    // Validate inputs
    if (_firstNameController.text.trim().isEmpty) {
      _showErrorSnackBar('Please enter your first name');
      return;
    }
    if (_lastNameController.text.trim().isEmpty) {
      _showErrorSnackBar('Please enter your last name');
      return;
    }
    if (_emailController.text.trim().isEmpty) {
      _showErrorSnackBar('Please enter your email');
      return;
    }
    if (_passwordController.text.isEmpty) {
      _showErrorSnackBar('Please enter a password');
      return;
    }
    if (_passwordController.text.length < 6) {
      _showErrorSnackBar('Password must be at least 6 characters');
      return;
    }
    if (_passwordController.text != _confirmPasswordController.text) {
      _showErrorSnackBar('Passwords do not match');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final authService = context.read<AuthService>();
      final firestoreService = FirestoreService();

      // Create user with Firebase Auth
      final userCredential = await authService.signUpWithEmailPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (userCredential?.user != null) {
        // Create user profile in Firestore
        final userModel = UserModel(
          uid: userCredential!.user!.uid,
          email: _emailController.text.trim(),
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          phoneNumber: _phoneController.text.trim().isNotEmpty
              ? '$_selectedCountryCode${_phoneController.text.trim()}'
              : null,
          role: _selectedRole,
          createdAt: DateTime.now(),
        );

        await firestoreService.saveUserProfile(userModel);

        if (mounted) {
          // Navigate to appropriate screen based on role
          if (_selectedRole == UserRole.manufacturer) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const ManufacturerDashboard(),
              ),
            );
          } else {
            // For now, show success message for other roles
            _showSuccessSnackBar('Account created successfully!');
            // TODO: Navigate to appropriate dashboard for distributor/customer
          }
        }
      }
    } on FirebaseAuthException catch (e) {
      _showErrorSnackBar(AuthService.getErrorMessage(e));
    } catch (e) {
      // More detailed error message
      _showErrorSnackBar('Failed to save user profile: ${e.toString()}');
      debugPrint('Sign up error: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  /// Handle Google sign-in
  Future<void> _handleGoogleSignIn() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final authService = context.read<AuthService>();
      final userCredential = await authService.signInWithGoogle();

      if (userCredential?.user != null && mounted) {
        final firestoreService = FirestoreService();
        
        // Check if user profile exists
        final exists = await firestoreService.userProfileExists(
          userCredential!.user!.uid,
        );

        if (!exists) {
          // Create profile for new user - default to customer role
          final userModel = UserModel(
            uid: userCredential.user!.uid,
            email: userCredential.user!.email!,
            firstName: userCredential.user!.displayName?.split(' ').first ?? 'User',
            lastName: userCredential.user!.displayName?.split(' ').last ?? '',
            role: _selectedRole,
            createdAt: DateTime.now(),
            profileImageUrl: userCredential.user!.photoURL,
          );

          await firestoreService.saveUserProfile(userModel);
        }

        if (mounted) {
          _showSuccessSnackBar('Signed in with Google successfully!');
          // Navigate based on role
          if (_selectedRole == UserRole.manufacturer) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const ManufacturerDashboard(),
              ),
            );
          }
        }
      }
    } on FirebaseAuthException catch (e) {
      _showErrorSnackBar(AuthService.getErrorMessage(e));
    } catch (e) {
      _showErrorSnackBar('Google sign-in failed. Please try again.');
      debugPrint('Google sign-in error: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  /// Handle GitHub sign-in
  Future<void> _handleGitHubSignIn() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final authService = context.read<AuthService>();
      final userCredential = await authService.signInWithGitHub();

      if (userCredential?.user != null && mounted) {
        final firestoreService = FirestoreService();
        
        // Check if user profile exists
        final exists = await firestoreService.userProfileExists(
          userCredential!.user!.uid,
        );

        if (!exists) {
          // Create profile for new user
          final userModel = UserModel(
            uid: userCredential.user!.uid,
            email: userCredential.user!.email!,
            firstName: userCredential.user!.displayName?.split(' ').first ?? 'User',
            lastName: userCredential.user!.displayName?.split(' ').last ?? '',
            role: _selectedRole,
            createdAt: DateTime.now(),
            profileImageUrl: userCredential.user!.photoURL,
          );

          await firestoreService.saveUserProfile(userModel);
        }

        if (mounted) {
          _showSuccessSnackBar('Signed in with GitHub successfully!');
          // Navigate based on role
          if (_selectedRole == UserRole.manufacturer) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const ManufacturerDashboard(),
              ),
            );
          }
        }
      }
    } on FirebaseAuthException catch (e) {
      _showErrorSnackBar(AuthService.getErrorMessage(e));
    } catch (e) {
      _showErrorSnackBar('GitHub sign-in failed. Please try again.');
      debugPrint('GitHub sign-in error: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  /// Show error snackbar
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: AppTextStyles.buttonSecondary.copyWith(color: AppColors.white),
        ),
        backgroundColor: Colors.red.shade900,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  /// Show success snackbar
  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: AppTextStyles.buttonSecondary.copyWith(color: AppColors.white),
        ),
        backgroundColor: AppColors.safetyGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  /// Builds the divider with "OR" text
  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: AppColors.lightGray.withOpacity(0.3),
            thickness: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Text(
            'OR',
            style: AppTextStyles.buttonSecondary.copyWith(
              color: AppColors.lightGray,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: AppColors.lightGray.withOpacity(0.3),
            thickness: 1,
          ),
        ),
      ],
    );
  }

  /// Builds OAuth sign-in buttons
  Widget _buildOAuthButtons() {
    return Column(
      children: [
        // Google Sign In
        _buildOAuthButton(
          label: 'Continue with Google',
          icon: Icons.g_mobiledata,
          onTap: _handleGoogleSignIn,
        ),
        
        const SizedBox(height: AppSpacing.md),
        
        // Apple Sign In
        _buildOAuthButton(
          label: 'Continue with Apple',
          icon: Icons.apple,
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Apple OAuth will be implemented with Firebase',
                  style: AppTextStyles.buttonSecondary.copyWith(color: AppColors.white),
                ),
                backgroundColor: AppColors.darkPurple,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          },
        ),
        
        const SizedBox(height: AppSpacing.md),
        
        // GitHub Sign In
        _buildOAuthButton(
          label: 'Continue with GitHub',
          icon: Icons.code,
          onTap: _handleGitHubSignIn,
        ),
      ],
    );
  }

  /// Builds an OAuth button with glassmorphic style
  Widget _buildOAuthButton({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: AppDecorations.secondaryButton(),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: AppColors.white, size: 24),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  label,
                  style: AppTextStyles.buttonPrimary.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the login link at the bottom
  Widget _buildLoginLink() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Already have an account? ',
            style: AppTextStyles.buttonSecondary.copyWith(
              color: AppColors.lightGray,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
              );
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, 0),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'Login',
              style: AppTextStyles.buttonSecondary.copyWith(
                color: AppColors.accentPurple,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
