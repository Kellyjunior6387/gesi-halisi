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
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../constants/app_theme.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../models/user_model.dart';
import 'signup_screen.dart';
import 'dashboard/manufacturer_dashboard.dart';

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
  
  // Loading state
  bool _isLoading = false;

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
          onTap: _isLoading ? null : _handleLogin,
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
                    'Login',
                    style: AppTextStyles.buttonPrimary,
                  ),
          ),
        ),
      ),
    );
  }

  /// Handle login with Firebase
  Future<void> _handleLogin() async {
    // Validate inputs
    if (_emailController.text.trim().isEmpty) {
      _showErrorSnackBar('Please enter your email');
      return;
    }
    if (_passwordController.text.isEmpty) {
      _showErrorSnackBar('Please enter your password');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final authService = context.read<AuthService>();
      final userCredential = await authService.signInWithEmailPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (userCredential?.user != null && mounted) {
        final firestoreService = FirestoreService();
        final userProfile = await firestoreService.getUserProfile(
          userCredential!.user!.uid,
        );

        if (userProfile != null && mounted) {
          // Navigate based on user role
          if (userProfile.role == UserRole.manufacturer) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const ManufacturerDashboard(),
              ),
            );
          } else {
            _showSuccessSnackBar('Welcome back, ${userProfile.firstName}!');
            // TODO: Navigate to appropriate dashboard
          }
        }
      }
    } on FirebaseAuthException catch (e) {
      _showErrorSnackBar(AuthService.getErrorMessage(e));
    } catch (e) {
      _showErrorSnackBar('Login failed. Please try again.');
      debugPrint('Login error: $e');
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
        final userProfile = await firestoreService.getUserProfile(
          userCredential!.user!.uid,
        );

        if (userProfile != null && mounted) {
          // Navigate based on user role
          if (userProfile.role == UserRole.manufacturer) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const ManufacturerDashboard(),
              ),
            );
          } else {
            _showSuccessSnackBar('Welcome back, ${userProfile.firstName}!');
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
        final userProfile = await firestoreService.getUserProfile(
          userCredential!.user!.uid,
        );

        if (userProfile != null && mounted) {
          // Navigate based on user role
          if (userProfile.role == UserRole.manufacturer) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const ManufacturerDashboard(),
              ),
            );
          } else {
            _showSuccessSnackBar('Welcome back, ${userProfile.firstName}!');
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
