/// Gesi Halisi Login Screen
///
/// This screen allows existing users to log in with email/password
/// or through OAuth providers (Google, Apple, GitHub).
///
/// Features:
/// - Email and password login
/// - OAuth sign-in options
/// - Navigation to sign up screen
/// - Forgot password link (placeholder)
///
/// Security Features:
/// - Input validation will be implemented with Firebase
/// - OAuth handled by Firebase Authentication

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui' show ImageFilter;
import '../constants/app_theme.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Form key for validation
  final _formKey = GlobalKey<FormState>();
  
  // Text controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  // Password visibility toggle
  bool _obscurePassword = true;

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
    _emailController.dispose();
    _passwordController.dispose();
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
                        'Welcome Back',
                        style: AppTextStyles.logo.copyWith(fontSize: 36),
                      ),
                      
                      const SizedBox(height: AppSpacing.sm),
                      
                      // Subtitle
                      Text(
                        'Login to continue',
                        style: AppTextStyles.onboardingDescription,
                      ),
                      
                      const SizedBox(height: AppSpacing.xxl),
                      
                      // Login form
                      _buildLoginForm(),
                      
                      const SizedBox(height: AppSpacing.xl),
                      
                      // Divider with "OR"
                      _buildDivider(),
                      
                      const SizedBox(height: AppSpacing.xl),
                      
                      // OAuth buttons
                      _buildOAuthButtons(),
                      
                      const SizedBox(height: AppSpacing.xl),
                      
                      // Sign up link
                      _buildSignUpLink(),
                      
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

  /// Builds the login form with glassmorphic style
  Widget _buildLoginForm() {
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
                // Email
                _buildTextField(
                  controller: _emailController,
                  label: 'Email',
                  hint: 'Enter your email',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                ),
                
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
                
                const SizedBox(height: AppSpacing.sm),
                
                // Forgot Password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Password reset will be implemented with Firebase',
                            style: AppTextStyles.buttonSecondary.copyWith(
                              color: AppColors.white,
                            ),
                          ),
                          backgroundColor: AppColors.darkPurple,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      );
                    },
                    child: Text(
                      'Forgot Password?',
                      style: AppTextStyles.buttonSecondary.copyWith(
                        color: AppColors.accentPurple,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: AppSpacing.md),
                
                // Login Button
                _buildLoginButton(),
              ],
            ),
          ),
        ),
      ),
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

  /// Builds the login button
  Widget _buildLoginButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: AppDecorations.primaryButton(),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // TODO: Implement Firebase login logic
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Firebase authentication will be implemented next',
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
          borderRadius: BorderRadius.circular(12),
          child: Center(
            child: Text(
              'Login',
              style: AppTextStyles.buttonPrimary,
            ),
          ),
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
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Google OAuth will be implemented with Firebase',
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
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'GitHub OAuth will be implemented with Firebase',
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

  /// Builds the sign up link at the bottom
  Widget _buildSignUpLink() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Don't have an account? ",
            style: AppTextStyles.buttonSecondary.copyWith(
              color: AppColors.lightGray,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const SignUpScreen(),
                ),
              );
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, 0),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'Sign Up',
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
