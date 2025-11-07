# GasChain Testing Guide

## Quick Start Testing

### Prerequisites
1. Flutter SDK installed (3.9.2 or higher)
2. Firebase project configured
3. Dependencies installed: `flutter pub get`

### Test User Authentication

#### Test Email/Password Sign Up
1. Open the app
2. Navigate through splash and onboarding screens
3. Click "Get Started" → "Sign Up"
4. Fill in the form:
   - First Name: John
   - Last Name: Doe
   - Phone: 1234567890
   - Email: john@example.com
   - **Select Role: Manufacturer**
   - Password: test123456
   - Confirm Password: test123456
5. Click "Sign Up"
6. Should redirect to Manufacturer Dashboard

#### Test Google OAuth
1. On Sign Up screen, click "Continue with Google"
2. Select Google account
3. **Important**: After Google sign-in, the role selector value will be used
4. Should save profile with selected role to Firestore
5. Redirects to appropriate dashboard

#### Test GitHub OAuth
1. On Sign Up screen, click "Continue with GitHub"
2. Authorize with GitHub
3. Profile created with selected role
4. Redirects to dashboard

#### Test Login
1. Navigate to Login screen
2. Enter email and password
3. Click "Login"
4. Should redirect to dashboard based on user role

### Test Manufacturer Dashboard

#### Desktop View (>900px width)
- ✅ Sidebar visible on left
- ✅ Top app bar with search, notifications, profile
- ✅ Large content area
- ✅ All navigation items clickable

#### Tablet View (600-900px width)
- ✅ Compact sidebar visible
- ✅ Medium-sized content area
- ✅ Responsive layout adjusts

#### Mobile View (<600px width)
- ✅ No sidebar
- ✅ Bottom navigation bar visible
- ✅ Full-width content
- ✅ Search icon in top bar (instead of search bar)

### Test Dashboard Sections

#### 1. Overview Screen
Test these elements:
- [ ] 4 metric cards display correctly
- [ ] Metric cards show gradients and icons
- [ ] Trend indicators (arrows) visible
- [ ] Monthly minting chart renders
- [ ] Chart shows 6 months of data
- [ ] Quick Actions panel visible
- [ ] "Register New Cylinder" button opens modal
- [ ] Modal form has all fields
- [ ] Modal Cancel button closes dialog

#### 2. Cylinders Screen
Test:
- [ ] Filter chips visible (All, Verified, Pending, Minted)
- [ ] Filter chips are clickable
- [ ] Cylinder cards display mock data
- [ ] Status badges show different colors
- [ ] "View Details" button clickable
- [ ] "Mint NFT" button visible on verified cylinders
- [ ] Card layout responsive

#### 3. Orders Screen
Test:
- [ ] Placeholder card shows
- [ ] Mock order cards display
- [ ] Order status badges visible
- [ ] Icons and gradients render correctly

#### 4. Analytics Screen
Test:
- [ ] Verification rate pie chart renders
- [ ] Pie chart shows 88% / 12% split
- [ ] Legend displays below chart
- [ ] Top batches bar chart renders
- [ ] Bar chart shows 4 batches
- [ ] Colors and gradients applied

#### 5. Messages Screen
Test:
- [ ] Message cards display
- [ ] Different icon colors for message types
- [ ] Timestamps shown
- [ ] Layout is scrollable

#### 6. Settings Screen
Test:
- [ ] Profile card displays at top
- [ ] Avatar icon visible
- [ ] Three settings sections render
- [ ] All setting items clickable
- [ ] Logout button visible at bottom
- [ ] Logout button has red styling

### Test Responsive Behavior

#### Resize Window (Web/Desktop)
1. Start at desktop width (>900px)
   - Should see sidebar
2. Resize to tablet (600-900px)
   - Sidebar should become compact
3. Resize to mobile (<600px)
   - Sidebar should hide
   - Bottom navigation should appear

#### Test Navigation
1. Click each sidebar item
2. Verify screen changes
3. Check top bar title updates
4. Test bottom navigation (mobile)
5. Ensure smooth transitions

### Test Glassmorphism Effects

Visual checks:
- [ ] All cards have blur effect
- [ ] Transparent backgrounds visible
- [ ] Border glows present
- [ ] Shadows on buttons
- [ ] Gradient backgrounds on metrics
- [ ] Purple accent colors throughout

### Test Logout Flow
1. Navigate to Settings
2. Scroll to bottom
3. Click "Logout" button
4. Should return to Auth screen
5. Firebase auth state cleared
6. Cannot navigate back to dashboard

### Performance Tests

#### Check Smooth Animations
- [ ] Page transitions smooth
- [ ] Button presses have feedback
- [ ] Hover effects work (web/desktop)
- [ ] No lag when switching tabs

#### Check Memory Usage
- [ ] App doesn't crash on navigation
- [ ] Charts render without lag
- [ ] Scrolling is smooth

## Common Issues and Solutions

### Issue: Firebase Authentication Errors
**Solution**: Ensure Firebase project has authentication methods enabled

### Issue: Google Sign-In Not Working
**Solution**: 
- Check Firebase console for Google OAuth setup
- Ensure SHA-1 fingerprint added (Android)
- OAuth consent screen configured

### Issue: GitHub Sign-In Not Working
**Solution**:
- Enable GitHub provider in Firebase Console
- Configure GitHub OAuth app
- Add callback URL from Firebase

### Issue: Charts Not Rendering
**Solution**:
- Check `fl_chart` package installed
- Verify imports in analytics and overview screens

### Issue: Navigation Not Working
**Solution**:
- Check all screen imports in manufacturer_dashboard.dart
- Ensure all screens exist

### Issue: Role Selection Not Saving
**Solution**:
- Check Firestore rules allow writes to /users/ collection
- Verify user is authenticated before saving

## Manual Testing Checklist

### Authentication Flow
- [ ] Sign up with email/password
- [ ] Sign up with Google
- [ ] Sign up with GitHub
- [ ] Login with email/password
- [ ] Login with Google
- [ ] Login with GitHub
- [ ] Logout functionality

### Dashboard UI
- [ ] Sidebar navigation (desktop/tablet)
- [ ] Bottom navigation (mobile)
- [ ] Top app bar
- [ ] Search bar (desktop/tablet)
- [ ] Notifications icon
- [ ] Profile avatar

### All Screens
- [ ] Overview screen
- [ ] Cylinders screen
- [ ] Orders screen
- [ ] Analytics screen
- [ ] Messages screen
- [ ] Settings screen

### Responsive Design
- [ ] Desktop layout (>900px)
- [ ] Tablet layout (600-900px)
- [ ] Mobile layout (<600px)

### Dialogs and Modals
- [ ] Register Cylinder dialog
- [ ] Dialog fields functional
- [ ] Cancel/Register buttons work

### Visual Design
- [ ] Glassmorphism effects
- [ ] Gradient backgrounds
- [ ] Icon rendering
- [ ] Color scheme consistent
- [ ] Font styles (Poppins)

## Testing on Different Platforms

### Android
```bash
flutter run -d android
```
Test:
- Splash screen
- Status bar transparency
- Bottom navigation bar
- Back button behavior
- Google Sign-In

### iOS (requires macOS)
```bash
flutter run -d ios
```
Test:
- App bar notch handling
- Safe area rendering
- Apple Sign-In (if configured)

### Web
```bash
flutter run -d chrome
```
Test:
- Responsive breakpoints
- Sidebar visibility
- OAuth popup flow
- Chart rendering
- Browser compatibility

### Windows/macOS/Linux Desktop
```bash
flutter run -d windows  # or macos, linux
```
Test:
- Window resizing
- Sidebar behavior
- Desktop-specific layouts

## Automated Testing Setup (Future)

### Unit Tests
Create tests for:
- User model serialization
- Auth service methods
- Firestore service methods

### Widget Tests
Test:
- Dashboard navigation
- Form validation
- Button interactions
- Screen rendering

### Integration Tests
Test:
- Complete sign-up flow
- Login to dashboard flow
- Cylinder registration
- Logout flow

## Debugging Tips

### Enable Debug Logging
Check console for:
- `✅ Firebase initialized successfully`
- `✅ User profile saved: [uid]`
- `❌ Error` messages (if any)

### Firebase Console Checks
1. Authentication tab: Check registered users
2. Firestore tab: Check /users/ collection
3. Usage tab: Monitor read/write operations

### Flutter DevTools
Use for:
- Widget inspector
- Performance profiling
- Network monitoring
- Memory analysis

---

**Last Updated**: January 2025
**Version**: 1.0
