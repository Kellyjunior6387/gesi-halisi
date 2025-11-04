# GasChain UI Flow Documentation

## 📱 Visual Flow Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                         APP LAUNCH                              │
│                         (main.dart)                             │
│                                                                 │
│  • Initialize Flutter bindings                                 │
│  • Connect to Firebase (with error handling)                   │
│  • Launch MaterialApp with dark theme                          │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             ↓
┌─────────────────────────────────────────────────────────────────┐
│                    SPLASH SCREEN (3 seconds)                    │
│                   (splash_screen.dart)                          │
│                                                                 │
│  ┌───────────────────────────────────────────────────┐         │
│  │         Dark Gradient Background                  │         │
│  │       (Deep Blue → Purple → Black)                │         │
│  │                                                   │         │
│  │              ┌─────────────┐                      │         │
│  │              │             │                      │         │
│  │              │  🛡️ LOGO   │  ← Animated          │         │
│  │              │             │    (fade + scale)    │         │
│  │              └─────────────┘                      │         │
│  │                                                   │         │
│  │              "GasChain"      ← Bold, white       │         │
│  │                                                   │         │
│  │   "Verify your gas — stay safe                   │         │
│  │        with blockchain."     ← Tagline           │         │
│  │                                                   │         │
│  │              ⭕ Loading...                         │         │
│  └───────────────────────────────────────────────────┘         │
│                                                                 │
│  Animation: Fade in (0→1) + Scale (0.5→1)                     │
│  Duration: 800ms animation + 3s display                        │
│  Auto-navigate: → Onboarding Screen                            │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             ↓
┌─────────────────────────────────────────────────────────────────┐
│                    ONBOARDING SCREEN                            │
│                  (onboarding_screen.dart)                       │
│                                                                 │
│  ┌─────────────────────────────────────────────┐  [Skip] ←──┐ │
│  │         PageView (Swipeable)                │             │ │
│  │                                             │             │ │
│  │  ╔════════════════════════════════════╗     │             │ │
│  │  ║   PAGE 1: Safe Gas for Everyone   ║     │             │ │
│  │  ║                                    ║     │             │ │
│  │  ║          ┌──────────┐              ║     │             │ │
│  │  ║          │ Icon/    │              ║     │             │ │
│  │  ║          │ Lottie   │ ← Animated   ║     │             │ │
│  │  ║          └──────────┘              ║     │             │ │
│  │  ║                                    ║     │             │ │
│  │  ║  ┌──────────────────────────────┐  ║     │             │ │
│  │  ║  │  Glassmorphic Card          │  ║     │             │ │
│  │  ║  │  (Blur effect + transparent)│  ║     │             │ │
│  │  ║  │                              │  ║     │             │ │
│  │  ║  │  "Safe Gas for Everyone"     │  ║     │             │ │
│  │  ║  │                              │  ║     │             │ │
│  │  ║  │  "Verify your gas cylinder   │  ║     │             │ │
│  │  ║  │   authenticity instantly..." │  ║     │             │ │
│  │  ║  └──────────────────────────────┘  ║     │             │ │
│  │  ╚════════════════════════════════════╝     │             │ │
│  │                                             │             │ │
│  │  ← Swipe left/right to change pages →      │             │ │
│  └─────────────────────────────────────────────┘             │ │
│                                                               │ │
│             ● ○ ○  ← Page Indicators                         │ │
│                                                               │ │
│         ┌────────────────────────┐                           │ │
│         │   [Next →]  Button     │                           │ │
│         └────────────────────────────┘                       │ │
│                                                               │ │
│  Page 1: Safe Gas (Green icon)                               │ │
│  Page 2: Blockchain (Blue icon)                              │ │
│  Page 3: AI Assistant (Orange icon)                          │ │
│                                                               │ │
│  On Page 3: Button changes to "Get Started ✓"               │ │
└────────────────────────────┬──────────────────────────────────┘
                             │
                             ↓ (Click "Get Started")
                             │
┌─────────────────────────────────────────────────────────────────┐
│                      AUTH SCREEN (Placeholder)                  │
│                      (auth_screen.dart)                         │
│                                                                 │
│  ┌───────────────────────────────────────────────────┐         │
│  │         Dark Gradient Background                  │         │
│  │                                                   │         │
│  │              🛡️ Icon                              │         │
│  │                                                   │         │
│  │         "Welcome to GasChain"                     │         │
│  │                                                   │         │
│  │    "Login/Signup screen will be                  │         │
│  │     implemented here"                             │         │
│  │                                                   │         │
│  │         ┌──────────────────────┐                 │         │
│  │         │  🔐 Login            │                 │         │
│  │         └──────────────────────┘                 │         │
│  │                                                   │         │
│  │         ┌──────────────────────┐                 │         │
│  │         │  👤 Sign Up          │                 │         │
│  │         └──────────────────────┘                 │         │
│  │                                                   │         │
│  │  (Buttons show snackbar message)                 │         │
│  └───────────────────────────────────────────────────┘         │
│                                                                 │
│  Future: Will implement Firebase Authentication                │
└─────────────────────────────────────────────────────────────────┘
```

## 🎨 Design System Overview

### Color Palette

```
┌─────────────────┬─────────────────┬─────────────────┐
│  Deep Blue      │  Dark Purple    │  Rich Purple    │
│  #0A0E27        │  #1A1A2E        │  #16213E        │
│  Background     │  Surface        │  Cards          │
└─────────────────┴─────────────────┴─────────────────┘

┌─────────────────┬─────────────────┬─────────────────┐
│  Accent Purple  │  Light Purple   │  White          │
│  #6C63FF        │  #9D8DF1        │  #FFFFFF        │
│  Primary CTA    │  Highlights     │  Text           │
└─────────────────┴─────────────────┴─────────────────┘
```

### Typography (Poppins Font)

```
┌────────────────────────────────────────────────────────┐
│  Logo          48px  Bold     White      Letter: 1.5  │
│  Tagline       16px  Light    Gray       Letter: 0.5  │
│  Title         28px  Bold     White      Height: 1.3  │
│  Description   16px  Regular  Gray       Height: 1.5  │
│  Button        16px  SemiBold White      Letter: 0.5  │
└────────────────────────────────────────────────────────┘
```

### Spacing System

```
XS:   4px   • Tight spacing (icon to text)
SM:   8px   • Small gaps
MD:  16px   • Default spacing
LG:  24px   • Section spacing
XL:  32px   • Large gaps
XXL: 48px   • Screen sections
```

### Animation Timings

```
Splash Display:      3000ms  (3 seconds)
Fade In:              800ms  (smooth fade)
Slide In:             600ms  (quick slide)
Button Press:         200ms  (instant feedback)
Page Transition:      400ms  (smooth navigation)
```

## 🔄 User Interaction Flow

### Splash Screen Interactions

```
User Action:          System Response:
────────────────      ─────────────────────────────────
App Opens        →    1. Initialize Firebase
                      2. Show splash with animation
                      3. Start 3-second timer
                      4. Auto-navigate to onboarding
```

### Onboarding Screen Interactions

```
User Action:          System Response:
────────────────      ─────────────────────────────────
Swipe Left       →    Next page (if not last page)
Swipe Right      →    Previous page (if not first page)
Tap "Skip"       →    Navigate to Auth Screen
Tap "Next"       →    Next page (or Auth if last page)
Tap "Get Started" →   Navigate to Auth Screen

Page Indicator Updates Automatically
```

### Auth Screen Interactions

```
User Action:          System Response:
────────────────      ─────────────────────────────────
Tap "Login"      →    Show snackbar: "Will be implemented"
Tap "Sign Up"    →    Show snackbar: "Will be implemented"
```

## 📐 Layout Structure

### Splash Screen Layout

```
SafeArea
└── Container (Gradient Background)
    └── Column
        ├── Spacer (flex: 1)
        ├── AnimatedBuilder
        │   └── FadeTransition + ScaleTransition
        │       └── Column
        │           ├── Logo Container (150x150)
        │           │   └── Icon/Image
        │           ├── SizedBox (24px gap)
        │           ├── App Name Text
        │           ├── SizedBox (16px gap)
        │           └── Tagline Text
        ├── Spacer (flex: 2)
        └── Loading Indicator
```

### Onboarding Screen Layout

```
SafeArea
└── Container (Gradient Background)
    └── Column
        ├── TopBar (Skip Button)
        ├── PageView (Expanded)
        │   ├── OnboardingPage 1
        │   ├── OnboardingPage 2
        │   └── OnboardingPage 3
        └── BottomSection
            ├── SmoothPageIndicator
            ├── SizedBox (32px gap)
            └── Navigation Button
```

### OnboardingPage Widget Layout

```
Padding
└── Column
    ├── Spacer (flex: 1)
    ├── Illustration Container (250x250)
    │   └── Icon (100px)
    ├── SizedBox (48px gap)
    ├── ClipRRect
    │   └── BackdropFilter (Blur)
    │       └── Container (Glass Effect)
    │           └── Padding
    │               └── Column
    │                   ├── Title Text
    │                   ├── SizedBox (16px gap)
    │                   └── Description Text
    └── Spacer (flex: 2)
```

## 🎭 Animation Details

### Splash Screen Animations

**Logo Animation (800ms):**
```
Time: 0ms     → Opacity: 0.0,  Scale: 0.5   (invisible, small)
Time: 800ms   → Opacity: 1.0,  Scale: 1.0   (visible, normal)
Curve: easeOutBack (slight bounce effect)
```

**Navigation Transition (400ms):**
```
From: Splash Screen
To: Onboarding Screen
Effect: Fade transition
Curve: Linear
```

### Onboarding Animations

**Page Change Animation (400ms):**
```
Effect: Horizontal slide
Curve: easeInOut
Distance: Full screen width
```

**Page Indicator Animation:**
```
Inactive Dot: 8x8px, Gray (30% opacity)
Active Dot: 8x32px (expands 4x), Purple
Transition: Smooth expansion/contraction
```

**Navigation to Auth (400ms):**
```
Effect: Fade + Slide
Fade: 0.0 → 1.0
Slide: Right to Center (1.0, 0.0) → (0.0, 0.0)
Curve: easeOut
```

## 🔐 Security Flow

```
┌─────────────────────────────────────────────────────────┐
│                   SECURITY LAYERS                       │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  App Launch                                             │
│    ↓                                                    │
│  ✓ Safe Firebase initialization (with error handling)  │
│    ↓                                                    │
│  Splash Screen                                          │
│    ↓                                                    │
│  ✓ No data collection                                  │
│  ✓ Safe navigation (mounted check)                     │
│  ✓ Memory leak prevention (dispose)                    │
│    ↓                                                    │
│  Onboarding Screen                                      │
│    ↓                                                    │
│  ✓ No data collection                                  │
│  ✓ Safe state management                               │
│  ✓ Proper controller cleanup                           │
│    ↓                                                    │
│  Auth Screen (Placeholder)                              │
│    ↓                                                    │
│  ⚠️  Future: Firebase Auth with security features       │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

## 📦 Component Hierarchy

```
GasChainApp (MaterialApp)
├── Theme Configuration
│   ├── Dark Theme
│   ├── Color Scheme
│   └── Text Theme
│
└── SplashScreen (Home)
    │
    ├── After 3 seconds
    │   ↓
    └── OnboardingScreen
        │
        ├── PageView
        │   ├── OnboardingPage (Widget)
        │   ├── OnboardingPage (Widget)
        │   └── OnboardingPage (Widget)
        │
        ├── SmoothPageIndicator (Package)
        │
        └── Navigation Button
            │
            ├── On "Skip" or "Get Started"
            │   ↓
            └── AuthScreen (Placeholder)
```

## 🎨 Glassmorphism Effect

```
Visual Breakdown:

┌─────────────────────────────────────────────────────┐
│  Parent Container (Gradient Background)             │
│                                                     │
│    ┌────────────────────────────────────────┐      │
│    │  ClipRRect (Rounded corners)           │      │
│    │                                         │      │
│    │    ┌──────────────────────────────┐    │      │
│    │    │  BackdropFilter              │    │      │
│    │    │  (Blur: 10px)                │    │      │
│    │    │                              │    │      │
│    │    │    ┌─────────────────────┐   │    │      │
│    │    │    │  Container          │   │    │      │
│    │    │    │  • White 10% opacity│   │    │      │
│    │    │    │  • Border: white 20%│   │    │      │
│    │    │    │  • Content inside   │   │    │      │
│    │    │    └─────────────────────┘   │    │      │
│    │    └──────────────────────────────┘    │      │
│    └────────────────────────────────────────┘      │
│                                                     │
└─────────────────────────────────────────────────────┘

Result: Frosted glass effect with blurred background
```

## 📱 Responsive Design

### Breakpoints

```
Small Phone:    Width < 360px   → Extra padding, smaller fonts
Medium Phone:   360px - 414px   → Default sizing
Large Phone:    414px - 480px   → Larger touch targets
Tablet:         > 480px         → Wider content, more spacing
```

### Layout Adaptations

```
Component         Small           Medium          Large
─────────────────────────────────────────────────────────
Logo Size         120x120         150x150         180x180
Title Font        24px            28px            32px
Description       14px            16px            18px
Button Height     48px            56px            64px
Horizontal Pad    16px            24px            32px
```

## 🔄 State Management

### Splash Screen States

```
State              Condition
─────────────────────────────────────────────────
Initializing   →   App starting, Firebase connecting
Animating      →   Logo fade-in and scale animation
Waiting        →   3-second timer counting down
Navigating     →   Transitioning to onboarding
```

### Onboarding Screen States

```
State              Variable
─────────────────────────────────────────────────
Current Page   →   _currentPage (0, 1, or 2)
Page Progress  →   _pageController.page
Can Skip       →   _currentPage < 2
Button Text    →   _currentPage == 2 ? "Get Started" : "Next"
```

## 🎯 User Experience Considerations

### Timing Rationale

```
Splash Duration: 3 seconds
  • 800ms: Animation
  • 2200ms: Brand recognition time
  • Total: Enough to recognize brand, not too long to annoy

Page Transitions: 400ms
  • Fast enough to feel responsive
  • Slow enough to be smooth and not jarring

Button Press: 200ms
  • Instant feedback
  • Matches iOS/Android standards
```

### Accessibility

```
Feature                   Implementation
────────────────────────────────────────────────────
Color Contrast        →   White text on dark background (WCAG AA)
Touch Targets         →   Min 48x48px (Material Design)
Font Sizing           →   Scales with system settings
Semantic Labels       →   Icons have descriptive labels
Navigation            →   Keyboard accessible (future)
Screen Reader         →   Semantic widget structure
```

---

**This document provides a comprehensive visual and structural overview of the GasChain UI implementation.**
