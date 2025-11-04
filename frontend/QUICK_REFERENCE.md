# GasChain Quick Reference Guide

## 🚀 Quick Start

```bash
# Navigate to frontend directory
cd frontend

# Install dependencies
flutter pub get

# Run the app
flutter run
```

## 📁 File Locations

| What you want to change | File to edit |
|------------------------|--------------|
| Colors & Theme | `lib/constants/app_theme.dart` |
| Splash Screen | `lib/screens/splash_screen.dart` |
| Onboarding Pages | `lib/screens/onboarding_screen.dart` |
| Single Page Layout | `lib/widgets/onboarding_page.dart` |
| App Entry Point | `lib/main.dart` |
| Dependencies | `pubspec.yaml` |
| Assets (images) | `assets/images/` |

## 🎨 Common Customizations

### Change Splash Duration

**File:** `lib/constants/app_theme.dart`

```dart
static const Duration splashDelay = Duration(seconds: 3);
// Change to any number of seconds you want
```

### Change Primary Color

**File:** `lib/constants/app_theme.dart`

```dart
static const Color accentPurple = Color(0xFF6C63FF);
// Change to: Color(0xFFRRGGBB) where RR=red, GG=green, BB=blue
// Example: Color(0xFFFF0000) = Red
```

### Change App Name

**File:** `lib/screens/splash_screen.dart`

```dart
Text(
  'GasChain',  // ← Change this
  style: AppTextStyles.logo,
)
```

### Change Tagline

**File:** `lib/screens/splash_screen.dart`

```dart
Text(
  'Verify your gas — stay safe with blockchain.',  // ← Change this
  style: AppTextStyles.tagline,
  textAlign: TextAlign.center,
)
```

### Change Onboarding Content

**File:** `lib/screens/onboarding_screen.dart`

```dart
OnboardingPage(
  title: 'Safe Gas for Everyone',  // ← Change title
  description: 'Your description here...',  // ← Change description
  icon: Icons.verified_user_outlined,  // ← Change icon
  iconColor: const Color(0xFF4CAF50),  // ← Change color
),
```

### Add More Onboarding Pages

**File:** `lib/screens/onboarding_screen.dart`

1. Update total pages:
```dart
static const int _totalPages = 4;  // ← Change from 3 to 4
```

2. Add page in PageView:
```dart
PageView(
  children: [
    OnboardingPage(...),  // Page 1
    OnboardingPage(...),  // Page 2
    OnboardingPage(...),  // Page 3
    OnboardingPage(...),  // Page 4 ← Add here
  ],
)
```

### Change Font

**File:** `lib/constants/app_theme.dart`

```dart
static TextStyle logo = GoogleFonts.poppins(  // ← Change poppins to another font
  fontSize: 48,
  fontWeight: FontWeight.bold,
  color: AppColors.white,
);

// Available fonts: roboto, openSans, lato, montserrat, etc.
// See: https://fonts.google.com/
```

## 🎯 Common Icons

```dart
// Safety & Security
Icons.verified_user_outlined
Icons.shield_outlined
Icons.security_outlined
Icons.lock_outlined

// Blockchain & Tech
Icons.link_outlined
Icons.layers_outlined
Icons.account_tree_outlined
Icons.hub_outlined

// AI & Communication
Icons.psychology_outlined
Icons.chat_bubble_outline
Icons.mic_outlined
Icons.smart_toy_outlined

// Actions
Icons.arrow_forward
Icons.check
Icons.close
Icons.done_all
```

## 🔧 Useful Commands

```bash
# Install dependencies
flutter pub get

# Run on connected device
flutter run

# Run on specific device
flutter run -d <device_id>

# List devices
flutter devices

# Hot reload (during development)
Press 'r' in terminal

# Hot restart (during development)
Press 'R' in terminal

# Quit running app
Press 'q' in terminal

# Analyze code
flutter analyze

# Format code
flutter format lib/

# Build APK (Android)
flutter build apk

# Build iOS (macOS only)
flutter build ios

# Clean build files
flutter clean
```

## 🐛 Common Issues & Fixes

### Dependencies Not Found

```bash
cd frontend
flutter pub get
```

### Changes Not Appearing

1. Try hot reload: Press `r`
2. Try hot restart: Press `R`
3. Stop and run again: `Ctrl+C` then `flutter run`

### Build Errors

```bash
flutter clean
flutter pub get
flutter run
```

### Assets Not Loading

1. Check `pubspec.yaml` has correct indentation
2. Verify file exists in correct folder
3. Run `flutter pub get`
4. Do hot restart (`R`)

## 📊 Project Structure Quick Map

```
frontend/
│
├── lib/                          ← All Dart code
│   ├── main.dart                ← Start here
│   ├── constants/
│   │   └── app_theme.dart       ← Colors, styles
│   ├── screens/
│   │   ├── splash_screen.dart   ← 1st screen
│   │   ├── onboarding_screen.dart ← 2nd screen
│   │   └── auth_screen.dart     ← 3rd screen
│   └── widgets/
│       └── onboarding_page.dart ← Reusable component
│
├── assets/                       ← Images, animations
│   ├── images/
│   │   └── logo.png             ← Add your logo here
│   └── lottie/
│       └── *.json               ← Add animations here
│
├── pubspec.yaml                 ← Dependencies & assets
│
├── IMPLEMENTATION_GUIDE.md      ← Full technical guide
├── SECURITY.md                  ← Security documentation
├── BEGINNER_GUIDE.md            ← Step-by-step tutorial
├── UI_FLOW.md                   ← Visual flow diagrams
└── QUICK_REFERENCE.md           ← This file
```

## 🎨 Color Picker Quick Reference

```dart
// Basic Colors
Color(0xFFFFFFFF)  // White
Color(0xFF000000)  // Black
Color(0xFFFF0000)  // Red
Color(0xFF00FF00)  // Green
Color(0xFF0000FF)  // Blue
Color(0xFFFFFF00)  // Yellow
Color(0xFFFF00FF)  // Magenta
Color(0xFF00FFFF)  // Cyan

// Material Colors
Colors.red
Colors.blue
Colors.green
Colors.purple
Colors.orange
Colors.pink

// With Opacity
Colors.white.withOpacity(0.5)  // 50% transparent white
```

## 📏 Spacing Quick Reference

```dart
// Use predefined spacing
AppSpacing.xs    //   4px
AppSpacing.sm    //   8px
AppSpacing.md    //  16px
AppSpacing.lg    //  24px
AppSpacing.xl    //  32px
AppSpacing.xxl   //  48px

// Usage
SizedBox(height: AppSpacing.md)  // 16px vertical gap
Padding(padding: EdgeInsets.all(AppSpacing.lg))  // 24px all sides
```

## ⏱️ Animation Duration Quick Reference

```dart
// Use predefined durations
AppAnimations.splashDelay      // 3000ms (3 seconds)
AppAnimations.fadeIn           //  800ms
AppAnimations.slideIn          //  600ms
AppAnimations.buttonPress      //  200ms
AppAnimations.pageTransition   //  400ms

// Usage
Timer(AppAnimations.splashDelay, () { ... })
AnimationController(duration: AppAnimations.fadeIn, ...)
```

## 🎭 Navigation Quick Reference

```dart
// Replace current screen
Navigator.pushReplacement(
  context,
  MaterialPageRoute(builder: (context) => NewScreen()),
);

// Add screen on top (can go back)
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => NewScreen()),
);

// Go back
Navigator.pop(context);

// Custom transition
Navigator.pushReplacement(
  context,
  PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => NewScreen(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(opacity: animation, child: child);
    },
  ),
);
```

## 🧪 Testing Checklist

- [ ] Splash screen displays
- [ ] Logo animates smoothly
- [ ] Auto-navigation after 3 seconds
- [ ] Can swipe between onboarding pages
- [ ] Page indicators update
- [ ] Skip button works
- [ ] Next button works
- [ ] Get Started button works
- [ ] UI looks good on small screens
- [ ] UI looks good on large screens
- [ ] Colors match design
- [ ] Fonts are readable
- [ ] Animations are smooth
- [ ] No errors in console

## 📚 Package Documentation Links

- [lottie](https://pub.dev/packages/lottie) - Animations
- [smooth_page_indicator](https://pub.dev/packages/smooth_page_indicator) - Page dots
- [google_fonts](https://pub.dev/packages/google_fonts) - Fonts
- [firebase_core](https://pub.dev/packages/firebase_core) - Firebase

## 🔍 Debug Tips

### Print Statements

```dart
print('Current page: $_currentPage');  // Simple print
debugPrint('Debug info: $value');      // Removed in release builds
```

### Check if Widget Mounted

```dart
if (mounted) {
  setState(() { ... });
}
```

### Error Handling

```dart
try {
  // Code that might fail
} catch (e) {
  debugPrint('Error: $e');
}
```

## 💡 Pro Tips

1. **Save often** - Flutter hot reload is fast
2. **Use const** - Makes app faster
3. **Format code** - Run `flutter format lib/`
4. **Check errors** - Read error messages carefully
5. **Test on device** - Emulator doesn't show everything
6. **Use hot reload** - Press `r` for quick updates
7. **Comment code** - Help future you
8. **Git commit often** - Small, frequent commits

## 🆘 Getting Help

1. **Flutter Docs**: https://docs.flutter.dev
2. **Stack Overflow**: Tag questions with `flutter`
3. **GitHub Issues**: For project-specific issues
4. **Flutter Community**: https://flutter.dev/community

## 📝 Quick Snippets

### Add a new screen

```dart
class MyNewScreen extends StatelessWidget {
  const MyNewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppGradients.primaryBackground,
        ),
        child: SafeArea(
          child: Center(
            child: Text(
              'My New Screen',
              style: AppTextStyles.onboardingTitle,
            ),
          ),
        ),
      ),
    );
  }
}
```

### Add a button

```dart
Container(
  width: double.infinity,
  height: 56,
  decoration: AppDecorations.primaryButton(),
  child: Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: () {
        // Button action
      },
      borderRadius: BorderRadius.circular(12),
      child: Center(
        child: Text(
          'Button Text',
          style: AppTextStyles.buttonPrimary,
        ),
      ),
    ),
  ),
)
```

### Add a glass card

```dart
ClipRRect(
  borderRadius: BorderRadius.circular(20),
  child: BackdropFilter(
    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
    child: Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: AppDecorations.glassCard(),
      child: Text('Content'),
    ),
  ),
)
```

---

**Keep this file handy for quick reference while developing!** 🚀
