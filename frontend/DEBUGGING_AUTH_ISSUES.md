# Debugging Authentication Issues

## Problem: User Created in Firebase Auth but Login Fails

### Symptoms
- Sign-up appears to fail with "An error occurred" message
- Firebase Console shows user was created successfully
- Login fails with "User profile not found" or generic error

### Root Cause
The user is successfully created in Firebase Authentication, but the user profile fails to save in Firestore. This can happen due to:

1. **Firestore Security Rules** - Most common cause
2. **Network issues** 
3. **Firestore not initialized properly**

---

## Step-by-Step Debugging

### Step 1: Check Firestore Security Rules

Open Firebase Console → Firestore Database → Rules

**Current Issue**: If your rules look like this:
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if false;  // ❌ This blocks all writes!
    }
  }
}
```

**Fix**: Update to allow authenticated users to write their own profile:
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users collection - users can read any profile, write only their own
    match /users/{userId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Cylinders collection
    match /cylinders/{cylinderId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && 
                      get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'manufacturer';
    }
    
    // Orders collection
    match /orders/{orderId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null;
    }
  }
}
```

**Steps to Update Rules:**
1. Go to Firebase Console
2. Navigate to Firestore Database
3. Click on "Rules" tab
4. Replace the rules with the ones above
5. Click "Publish"

---

### Step 2: Enable Flutter Debug Logs

Run your app with verbose logging:

```bash
flutter run --verbose
```

Look for these messages in the console:
- ✅ `User profile saved: [uid]` - Profile saved successfully
- ❌ `Error saving user profile: [error]` - Profile save failed

**Common Errors:**

**Error**: `[cloud_firestore/permission-denied] Missing or insufficient permissions`
- **Cause**: Firestore security rules are blocking the write
- **Fix**: Update rules as shown in Step 1

**Error**: `[cloud_firestore/unavailable] The service is currently unavailable`
- **Cause**: Network connectivity issue or Firestore is down
- **Fix**: Check internet connection, try again later

**Error**: `[cloud_firestore/not-found] The project was not found`
- **Cause**: Firebase not configured properly
- **Fix**: Check `firebase_options.dart` has correct project ID

---

### Step 3: Check Firebase Console

1. **Authentication Tab**:
   - Go to Firebase Console → Authentication
   - Check if user appears in the list
   - Note the UID

2. **Firestore Tab**:
   - Go to Firebase Console → Firestore Database
   - Check if `users` collection exists
   - Look for document with the same UID
   - If missing, the profile save failed

---

### Step 4: Test Firestore Connection

Add this test button to your app temporarily to verify Firestore works:

```dart
ElevatedButton(
  onPressed: () async {
    try {
      final firestore = FirebaseFirestore.instance;
      await firestore.collection('test').doc('test').set({
        'timestamp': FieldValue.serverTimestamp(),
        'message': 'Hello Firestore',
      });
      print('✅ Firestore write successful!');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Firestore connection works!')),
      );
    } catch (e) {
      print('❌ Firestore error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Firestore error: $e')),
      );
    }
  },
  child: Text('Test Firestore'),
)
```

---

## Quick Fix for Existing Users

If you have users stuck in Firebase Auth without Firestore profiles:

### Option 1: Manual Fix (Firebase Console)

1. Go to Firebase Console → Firestore Database
2. Click "Start collection" → Enter `users`
3. Add document with user's UID
4. Add fields:
   ```
   email: user@example.com
   firstName: John
   lastName: Doe
   role: manufacturer (or distributor/customer)
   createdAt: (timestamp) - current time
   phoneNumber: null
   profileImageUrl: null
   updatedAt: null
   ```

### Option 2: Code Fix (Add to app)

Add a "Retry Profile Creation" button on the error screen:

```dart
Future<void> _retryProfileCreation(String uid) async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && user.uid == uid) {
      final firestoreService = FirestoreService();
      
      // Show dialog to collect missing info
      final result = await showDialog<Map<String, dynamic>>(
        context: context,
        builder: (context) => ProfileSetupDialog(),
      );
      
      if (result != null) {
        final userModel = UserModel(
          uid: uid,
          email: user.email!,
          firstName: result['firstName'],
          lastName: result['lastName'],
          role: result['role'],
          createdAt: DateTime.now(),
        );
        
        await firestoreService.saveUserProfile(userModel);
        _showSuccessSnackBar('Profile created successfully!');
        
        // Navigate to dashboard
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const ManufacturerDashboard(),
          ),
        );
      }
    }
  } catch (e) {
    _showErrorSnackBar('Failed to create profile: $e');
  }
}
```

---

## Prevention: Improved Error Handling

The code has been updated with better error messages:

### Sign-up Screen
- Now shows: `"Failed to save user profile: [specific error]"`
- Instead of: `"An error occurred. Please try again."`

### Login Screen  
- Now shows: `"User profile not found. Please contact support or sign up again."`
- Instead of: Silent failure with no message

---

## Testing Your Fix

1. **Delete test user** from Firebase Authentication
2. **Try signing up again**
3. **Check console logs** for success/error messages
4. **Verify in Firestore** that user document was created
5. **Try logging in** with the new user

---

## Most Common Solution

**90% of the time, the issue is Firestore security rules blocking writes.**

Quick fix:
1. Go to Firebase Console → Firestore → Rules
2. Change rules to allow authenticated writes (see Step 1)
3. Click "Publish"
4. Try sign-up again

---

## Still Having Issues?

### Check Console Output

When you run the app, look for these logs:

**Successful flow:**
```
✅ Firebase initialized successfully
✅ User profile saved: abc123xyz
```

**Failed flow:**
```
✅ Firebase initialized successfully
❌ Error saving user profile: [cloud_firestore/permission-denied] ...
```

### Enable Detailed Logging

Add this to `main.dart` before `runApp()`:

```dart
FirebaseFirestore.instance.settings = const Settings(
  persistenceEnabled: true,
  cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
);

// Enable detailed logging (development only)
if (kDebugMode) {
  FirebaseFirestore.setLoggingEnabled(true);
}
```

---

## Contact Support

If none of these fixes work, gather this information:

1. **Error message** from console logs
2. **Screenshot** of Firestore security rules
3. **Screenshot** of Firebase Authentication users list
4. **Screenshot** of Firestore Database showing collections
5. **Flutter doctor output**: `flutter doctor -v`

This will help diagnose the issue quickly.
