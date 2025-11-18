# Customer Dashboard and Chatbot Features

## Overview

This implementation adds three major features to the Gesi Halisi (SafeCyl) app:

1. **Customer Dashboard** - A dedicated dashboard for customers to verify cylinders
2. **QR Code Generation & Scanning** - Generate and scan QR codes for cylinder verification
3. **Swahili AI Chatbot** - AI assistant to help users understand the app

## Features Implemented

### 1. Customer Dashboard (`customer_dashboard.dart`)

A clean, user-friendly dashboard designed for customers with:
- Swahili-first interface ("Karibu!", "Thibitisha Silinda")
- Quick access to cylinder verification
- Information about safety and how the app works
- Floating action button for instant chatbot access
- Logout functionality

**Key UI Elements:**
- Welcome section with user greeting
- Action cards for verification and information
- Safety information section
- Consistent glassmorphism design matching app theme

### 2. QR Code Verification (`verify_cylinder_screen.dart`)

Allows customers to scan QR codes on gas cylinders:

**Features:**
- Mobile camera scanner integration
- Real-time QR code detection
- Firestore database verification
- Three states:
  - Scanning mode
  - Verified (✅ Silinda Halisi)
  - Invalid (❌ Silinda Batili)

**Verification Process:**
1. User scans QR code on cylinder
2. App decodes JSON data (cylinderId, serialNumber, etc.)
3. Queries Firestore for cylinder details
4. Shows verification result with full cylinder information

**Security:**
- Only minted cylinders show as valid
- Warning message for invalid cylinders
- Full cylinder details on successful verification

### 3. Swahili AI Chatbot (`chatbot_screen.dart`)

AI-powered assistant speaking Swahili:

**Features:**
- OpenAI GPT-4o-mini integration
- Swahili conversational interface
- FAQ assistance about:
  - How to scan QR codes
  - Understanding cylinder information
  - Safety importance
  - What to do with invalid cylinders

**Implementation Details:**
- System prompt configured for Swahili responses
- Mock responses for demo (when API key not configured)
- Chat history with timestamps
- Typing indicator for better UX

### 4. QR Code Generation (`qr_code_display_widget.dart`)

Generates QR codes for minted cylinders:

**Features:**
- Automatic QR code generation from cylinder data
- JSON encoded data includes:
  - Cylinder ID
  - Serial number
  - Manufacturer
  - Batch number
  - Timestamp
- Display dialog with QR code
- Share and download options (ready for implementation)

**Integration:**
- Added to cylinders screen
- Only shown for minted cylinders
- Accessible via "QR Code" button

## Technical Implementation

### Dependencies Added

```yaml
qr_flutter: ^4.1.0      # For generating QR codes
mobile_scanner: ^5.2.3  # For scanning QR codes
```

### Permissions Configured

**Android** (`AndroidManifest.xml`):
```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-feature android:name="android.hardware.camera" android:required="false" />
```

**iOS** (`Info.plist`):
```xml
<key>NSCameraUsageDescription</key>
<string>Camera is required to scan QR codes on gas cylinders for verification</string>
```

### Authentication Routing

Updated `login_screen.dart` to route users based on role:
- **Manufacturer** → ManufacturerDashboard
- **Customer** → CustomerDashboard
- **Distributor** → (To be implemented)

## Usage

### For Manufacturers

After minting a cylinder:
1. View the cylinder in the Cylinders screen
2. Click "QR Code" button on minted cylinders
3. QR code is displayed and can be shared/downloaded
4. Print or attach QR code to physical cylinder

### For Customers

To verify a cylinder:
1. Login as a customer
2. On dashboard, click "Thibitisha Silinda"
3. Point camera at QR code on cylinder
4. View verification result
5. Check cylinder details if verified

To get help:
1. Click the "Msaada" floating button
2. Ask questions in Swahili or English
3. Get guidance on app features

## OpenAI API Configuration

To enable the chatbot with real AI responses:

1. Get an API key from [OpenAI](https://platform.openai.com/api-keys)
2. Open `frontend/lib/screens/chatbot_screen.dart`
3. Replace the placeholder:
   ```dart
   static const String _openAIApiKey = 'YOUR_OPENAI_API_KEY';
   ```
   with your actual key:
   ```dart
   static const String _openAIApiKey = 'sk-...'; // Your actual key
   ```

**Note:** For production, store the API key securely:
- Use environment variables
- Store in backend server
- Use Flutter secure storage
- Never commit API keys to version control

## File Structure

```
frontend/lib/
├── screens/
│   ├── chatbot_screen.dart              # AI chatbot interface
│   ├── verify_cylinder_screen.dart      # QR scanner and verification
│   ├── dashboard/
│   │   └── customer_dashboard.dart      # Customer main dashboard
│   └── login_screen.dart                # Updated with customer routing
└── widgets/
    └── qr_code_display_widget.dart      # QR code display dialog
```

## Testing

### Manual Testing Checklist

- [ ] Customer can login and see customer dashboard
- [ ] Dashboard shows all elements correctly
- [ ] QR scanner opens and requests camera permission
- [ ] QR code can be scanned (test with generated code)
- [ ] Verified cylinders show correct information
- [ ] Invalid cylinders show error message
- [ ] Chatbot opens and shows welcome message
- [ ] Chatbot responds to messages (mock or real)
- [ ] QR code generation works for minted cylinders
- [ ] QR code display shows correctly

### Test Data

Create test cylinders in Firestore with:
- Status: `minted`
- All required fields (serialNumber, manufacturer, etc.)
- Generate QR codes for testing

## Future Enhancements

1. **QR Code Features:**
   - Implement share functionality
   - Implement download/save to gallery
   - Print-ready QR code format

2. **Chatbot Improvements:**
   - Save conversation history to Firestore
   - Multi-language support (English, Swahili, more)
   - Voice input/output
   - Image recognition for damaged QR codes

3. **Verification Features:**
   - Scan history for customers
   - Report fake cylinders
   - Location-based verification
   - Offline mode with cached data

4. **Customer Dashboard:**
   - Statistics (scans performed, verified cylinders)
   - Saved/favorite cylinders
   - Notifications for cylinder recalls
   - Educational content

## Troubleshooting

### Camera Permission Denied
- Check AndroidManifest.xml and Info.plist are correctly configured
- Ensure app has camera permission in device settings
- On iOS, user must grant permission in popup

### QR Code Not Scanning
- Ensure good lighting
- Hold camera steady
- QR code must be clear and not damaged
- Try rescanning or manually entering cylinder ID

### Chatbot Not Responding
- Check API key is configured correctly
- Verify internet connection
- Check OpenAI API quota/billing
- Mock responses work without API key

### Verification Fails for Valid Cylinder
- Check Firestore connection
- Verify cylinder exists in database
- Ensure cylinder status is "minted"
- Check QR code data format

## Support

For issues or questions:
1. Check this documentation
2. Use the in-app chatbot for common questions
3. Contact support team
4. Submit GitHub issue

## License

Same as main Gesi Halisi project.
