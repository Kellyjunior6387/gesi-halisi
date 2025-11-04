/// GasChain Onboarding Screen
///
/// This screen introduces users to the app's key features through
/// a series of interactive pages with smooth transitions.
///
/// Features:
/// - 3 onboarding pages with glassmorphic design
/// - Smooth page transitions with PageView
/// - Animated page indicators
/// - Skip and Next navigation buttons
/// - Auto-navigation to login/signup on completion
///
/// Security Features:
/// - No user data collection during onboarding
/// - Safe navigation flow
/// - Proper state management

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../constants/app_theme.dart';
import '../widgets/onboarding_page.dart';
import 'auth_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  // PageView controller for managing page transitions
  final PageController _pageController = PageController();
  
  // Current page index
  int _currentPage = 0;
  
  // Total number of onboarding pages
  static const int _totalPages = 3;

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
    
    // Note: Page changes are handled by onPageChanged callback in PageView
    // This prevents memory leaks from listeners
  }

  @override
  void dispose() {
    // Clean up controller to prevent memory leaks
    _pageController.dispose();
    super.dispose();
  }

  /// Navigates to the next page or auth screen if on last page
  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: AppAnimations.pageTransition,
        curve: Curves.easeInOut,
      );
    } else {
      _navigateToAuth();
    }
  }

  /// Skips onboarding and navigates to auth screen
  void _skipOnboarding() {
    _navigateToAuth();
  }

  /// Navigates to authentication screen
  void _navigateToAuth() {
    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const AuthScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOut,
                )),
                child: child,
              ),
            );
          },
          transitionDuration: AppAnimations.pageTransition,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        // Apply gradient background
        decoration: const BoxDecoration(
          gradient: AppGradients.primaryBackground,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Skip button at the top
              _buildTopBar(),
              
              // Onboarding pages
              Expanded(
                child: _buildPageView(),
              ),
              
              // Page indicators and navigation buttons
              _buildBottomSection(),
              
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the top bar with skip button
  Widget _buildTopBar() {
    // Don't show skip button on last page
    if (_currentPage == _totalPages - 1) {
      return const SizedBox(height: 60);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: _skipOnboarding,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.sm,
              ),
            ),
            child: Text(
              'Skip',
              style: AppTextStyles.buttonSecondary,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the PageView with onboarding pages
  Widget _buildPageView() {
    return PageView(
      controller: _pageController,
      onPageChanged: (index) {
        if (mounted) {
          setState(() {
            _currentPage = index;
          });
        }
      },
      children: [
        // Page 1: Safety
        OnboardingPage(
          title: 'Safe Gas for Everyone',
          description:
              'Verify your gas cylinder authenticity instantly with our advanced scanning technology. Stay protected from counterfeit cylinders.',
          icon: Icons.verified_user_outlined,
          iconColor: AppColors.safetyGreen,
        ),
        
        // Page 2: Blockchain
        OnboardingPage(
          title: 'Powered by Blockchain',
          description:
              'Track every cylinder securely using NFT ownership. Complete transparency and security through decentralized technology.',
          icon: Icons.link_outlined,
          iconColor: AppColors.blockchainBlue,
        ),
        
        // Page 3: AI Assistant
        OnboardingPage(
          title: 'AI Assistant in Swahili',
          description:
              'Ask anything about safety or refills in your language! Get instant help with our intelligent Swahili-speaking assistant.',
          icon: Icons.psychology_outlined,
          iconColor: AppColors.aiOrange,
        ),
      ],
    );
  }

  /// Builds the bottom section with indicators and buttons
  Widget _buildBottomSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Column(
        children: [
          // Page indicators
          _buildPageIndicators(),
          
          const SizedBox(height: AppSpacing.xl),
          
          // Navigation button
          _buildNavigationButton(),
        ],
      ),
    );
  }

  /// Builds animated page indicators
  Widget _buildPageIndicators() {
    return SmoothPageIndicator(
      controller: _pageController,
      count: _totalPages,
      effect: ExpandingDotsEffect(
        activeDotColor: AppColors.accentPurple,
        dotColor: AppColors.lightGray.withOpacity(0.3),
        dotHeight: 8,
        dotWidth: 8,
        expansionFactor: 4,
        spacing: 8,
      ),
    );
  }

  /// Builds the navigation button (Next or Get Started)
  Widget _buildNavigationButton() {
    final isLastPage = _currentPage == _totalPages - 1;
    final buttonText = isLastPage ? 'Get Started' : 'Next';

    return AnimatedContainer(
      duration: AppAnimations.buttonPress,
      width: double.infinity,
      height: 56,
      decoration: AppDecorations.primaryButton(),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _nextPage,
          borderRadius: BorderRadius.circular(12),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  buttonText,
                  style: AppTextStyles.buttonPrimary,
                ),
                const SizedBox(width: AppSpacing.sm),
                Icon(
                  isLastPage ? Icons.check : Icons.arrow_forward,
                  color: AppColors.white,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
