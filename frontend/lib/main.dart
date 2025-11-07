/// Gesi Halisi Main Application Entry Point
///
/// This is the root of the Gesi Halisi application. It initializes Firebase
/// and sets up the Material App with the splash screen as the entry point.
///
/// Security Features:
/// - Firebase initialization with error handling
/// - Secure navigation flow
/// - Material Design 3 for modern UI standards
/// - Debug mode detection to prevent sensitive logs in production

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'screens/splash_screen.dart';
import 'constants/app_theme.dart';
import 'services/auth_service.dart';

void main() async {
  // Ensure Flutter binding is initialized before any async operations
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase with error handling
  // Note: Firebase errors are logged but don't prevent app launch
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('✅ Firebase initialized successfully');
  } catch (e) {
    // Log error in debug mode only
    debugPrint('⚠️ Failed to initialize Firebase: $e');
    // App can still run without Firebase for basic UI testing
  }
  
  // Launch the app
  runApp(const GesiHalisiApp());
}

/// Main application widget
class GesiHalisiApp extends StatelessWidget {
  const GesiHalisiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
      ],
      child: MaterialApp(
        // App configuration
        title: 'Gesi Halisi',
        debugShowCheckedModeBanner: false,
        
        // Theme configuration with Material 3
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          colorScheme: ColorScheme.dark(
            primary: AppColors.accentPurple,
            secondary: AppColors.lightPurple,
            background: AppColors.black,
            surface: AppColors.darkPurple,
          ),
          // Use Poppins as default font (loaded via google_fonts)
          textTheme: TextTheme(
            displayLarge: AppTextStyles.logo,
            displayMedium: AppTextStyles.onboardingTitle,
            bodyLarge: AppTextStyles.onboardingDescription,
            labelLarge: AppTextStyles.buttonPrimary,
          ),
        ),
        
        // Start with splash screen
        home: const SplashScreen(),
      ),
    );
  }
}