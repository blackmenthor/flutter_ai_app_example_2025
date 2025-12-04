# Haircut Recommendation App - Project Instructions

## 📋 Project Overview

This is a Flutter mobile application that provides personalized haircut recommendations using AI-powered image generation. Users upload photos of themselves, specify their preferences, and receive AI-generated images showing how they would look with different hairstyles.

---

## 🎯 App Flow

### 1. **Splash Screen**
- Display app logo/branding
- Animated entrance (fade-in, scale, or custom animation)
- Duration: 2-3 seconds
- Auto-navigate to Instructions Screen

### 2. **Instructions Screen**
Welcome users and explain how the app works:
- **Step 1:** Take or upload 3 photos (front face, side face, full body*)
- **Step 2:** Choose your hairstyle preferences
- **Step 3:** Get AI-generated hairstyle recommendations
- **Step 4:** Save your favorite look

*Note: Full body photo is optional

### 3. **Photo Capture Screen**
Users need to provide photos:

#### Required Photos:
- **Front Face Photo**
    - Clear, well-lit frontal view
    - Face should be centered
    - Options: Take photo with camera OR select from gallery

- **Side Face Photo**
    - Profile view (left or right side)
    - Face should be clearly visible
    - Options: Take photo with camera OR select from gallery

#### Optional Photo:
- **Full Body Photo**
    - Shows overall physique and proportions
    - Helps AI provide more contextualized recommendations
    - Options: Take photo with camera OR select from gallery OR skip

**UI Considerations:**
- Show image preview after capture
- Allow retake/re-select
- Clear indicators for required vs optional photos
- Progress indicator (e.g., "Photo 1 of 3")

### 4. **Preference Selection Screen**
Users specify their hairstyle preferences through **selectable options** (not free text):

#### Preference Categories:

**Hair Length:**
- [ ] Very Short
- [ ] Short
- [ ] Medium
- [ ] Long
- [ ] Very Long

**Style Type:**
- [ ] Fade
- [ ] Undercut
- [ ] Buzz Cut
- [ ] Crew Cut
- [ ] Pompadour
- [ ] Quiff
- [ ] Slicked Back
- [ ] Textured
- [ ] Curly/Wavy Style
- [ ] Natural/Messy

**Additional Preferences:**
- [ ] Clean/Professional Look
- [ ] Edgy/Modern
- [ ] Classic/Timeless
- [ ] Low Maintenance
- [ ] High Maintenance OK

**Optional Text Input:**
- "Any specific requests or styles you like?" (free text field for additional context)

### 5. **AI Processing Screen**
- Show loading indicator/animation
- Display message: "AI is generating your hairstyle recommendations..."
- Processing time: ~30-60 seconds (depending on API response)

### 6. **Recommendations Display Screen**
Display 1-3 AI-generated images showing the user with recommended hairstyles:

**For Each Recommendation:**
- Generated image preview
- Brief description of the style
- Tap to view full-screen

**User Actions:**
- Swipe or navigate between recommendations
- Select favorite recommendation
- Option to regenerate if not satisfied

### 7. **Selection & Save Screen**
Once user selects their favorite:
- Show selected image in full view
- Confirm selection button
- **Save to Gallery** - Downloads image to device photos
- Success message: "Saved to your gallery!"

### 8. **Completion Screen**
- Celebration message: "Your new look is saved!"
- Preview of saved image
- **Action Buttons:**
    - "Start Over" - Returns to Instructions Screen
    - "View in Gallery" - Opens device gallery app
    - "Share" - Opens share dialog (optional feature)

---

## 🛠️ Technical Details

### Technology Stack
- **Framework:** Flutter (Dart)
- **AI Service:** Google Gemini API with Imagen (Nano Banana Pro model)
- **Image Generation Model:** `imagen-3.0-generate-002` or latest available

### Prerequisites

1. **Flutter SDK** (Latest stable version recommended)
2. **Google Cloud Account** with billing enabled
3. **Gemini API Key** with Imagen access
4. **Development Environment:** Android Studio, VS Code, or IntelliJ IDEA

### Required Packages

Add these dependencies to `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # Google Generative AI
  google_generative_ai: ^0.4.0
  
  # Image Picker (Camera + Gallery)
  image_picker: ^1.0.7
  
  # Save images to gallery
  gallery_saver: ^2.3.2
  # OR
  image_gallery_saver: ^2.0.3
  
  # Permissions handling
  permission_handler: ^11.3.0
  
  # HTTP requests (if needed)
  http: ^1.2.0
  
  # State Management (choose one)
  provider: ^6.1.1
  # OR
  riverpod: ^2.4.10
  # OR
  bloc: ^8.1.3
  
  # UI/UX
  flutter_spinkit: ^5.2.0  # Loading animations
  cached_network_image: ^3.3.1  # Image caching
  smooth_page_indicator: ^1.1.0  # Page indicators
```

### API Configuration

#### 1. Obtain Google Gemini API Key

1. Go to [Google AI Studio](https://aistudio.google.com/)
2. Create a new project or select existing one
3. Enable billing (required for Imagen/image generation)
4. Generate an API key
5. Copy the API key (format: `AIza...`)

#### 2. Store API Key Securely

**Option A: Environment Variables (Recommended for Development)**

Create a `.env` file in project root:
```
GEMINI_API_KEY=your_api_key_here
```

Add to `.gitignore`:
```
.env
```

Use `flutter_dotenv` package to load:
```yaml
dependencies:
  flutter_dotenv: ^5.1.0
```

**Option B: Configuration File**

Create `lib/config/api_config.dart`:
```dart
class ApiConfig {
  static const String geminiApiKey = 'YOUR_API_KEY_HERE';
  
  // WARNING: Never commit actual API keys to version control
  // Use environment variables or secure key management in production
}
```

**Option C: Secure Storage (Production)**
```yaml
dependencies:
  flutter_secure_storage: ^9.0.0
```

#### 3. Configure Gemini API Client

Create `lib/services/gemini_service.dart`:

```dart
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  late final GenerativeModel _model;
  late final GenerativeModel _imagenModel;
  
  GeminiService(String apiKey) {
    // For text/vision analysis
    _model = GenerativeModel(
      model: 'gemini-2.0-flash-exp',
      apiKey: apiKey,
    );
    
    // For image generation (Nano Banana Pro / Imagen)
    _imagenModel = GenerativeModel(
      model: 'imagen-3.0-generate-002', // or 'gemini-pro-vision' for Nano Banana Pro
      apiKey: apiKey,
    );
  }
  
  // Add your methods here
}
```

### Platform-Specific Setup

#### Android (`android/app/src/main/AndroidManifest.xml`)

Add permissions:
```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.INTERNET" />

<!-- For Android 13+ -->
<uses-permission android:name="android.permission.READ_MEDIA_IMAGES" />
```

Set minimum SDK version in `android/app/build.gradle`:
```gradle
android {
    defaultConfig {
        minSdkVersion 21
        targetSdkVersion 34
    }
}
```

#### iOS (`ios/Runner/Info.plist`)

Add usage descriptions:
```xml
<key>NSCameraUsageDescription</key>
<string>We need camera access to take photos for hairstyle recommendations</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>We need photo library access to select and save images</string>
<key>NSPhotoLibraryAddUsageDescription</key>
<string>We need permission to save your hairstyle recommendations</string>
```

Set minimum iOS version in `ios/Podfile`:
```ruby
platform :ios, '12.0'
```

---

## 📁 Recommended Project Structure

```
lib/
├── main.dart
├── config/
│   └── api_config.dart          # API keys and configuration
├── models/
│   ├── user_photo.dart          # Photo data model
│   └── hairstyle_preference.dart # Preference data model
├── services/
│   ├── gemini_service.dart      # Gemini API integration
│   ├── image_service.dart       # Image picker & gallery saver
│   └── permission_service.dart  # Handle permissions
├── screens/
│   ├── splash_screen.dart
│   ├── instructions_screen.dart
│   ├── photo_capture_screen.dart
│   ├── preference_screen.dart
│   ├── processing_screen.dart
│   ├── recommendations_screen.dart
│   └── completion_screen.dart
├── widgets/
│   ├── photo_upload_card.dart
│   ├── preference_selector.dart
│   └── recommendation_card.dart
└── utils/
    ├── constants.dart
    └── helpers.dart
```

---

## 🚀 Getting Started

### Step 1: Clone and Setup
```bash
# Navigate to project directory
cd your_project_name

# Get dependencies
flutter pub get

# Run code generation (if using freezed, json_serializable, etc.)
flutter pub run build_runner build
```

### Step 2: Configure API Key
1. Create `.env` file or update `api_config.dart`
2. Add your Gemini API key
3. Ensure `.env` is in `.gitignore`

### Step 3: Run the App
```bash
# Run on connected device/emulator
flutter run

# Or specify platform
flutter run -d android
flutter run -d ios
```

---

## 🎨 UI/UX Guidelines

### Design Principles
- **Minimalist & Clean:** Focus on the user's photos and AI results
- **Intuitive Navigation:** Clear progress indicators and back buttons
- **Delightful Animations:** Smooth transitions between screens
- **Loading States:** Always show feedback during API calls
- **Error Handling:** Graceful error messages with retry options

### Color Scheme (Suggested)
- Primary: Modern blue/teal for trust and technology
- Secondary: Warm accent color for CTAs
- Background: Clean white or light gradient
- Text: High contrast for readability

### Accessibility
- Support both light and dark themes
- Ensure sufficient color contrast
- Provide text alternatives for icons
- Support screen readers
- Test with different font sizes

---

## ⚠️ Important Notes

### API Costs
- Image generation with Imagen is a **PAID** feature
- Typical cost: ~$0.02-0.04 per generated image
- Generating 3 recommendations per user = ~$0.06-0.12 per session
- Monitor usage to control costs
- Consider implementing usage limits or user quotas

### API Rate Limits
- Gemini API has rate limits (requests per minute/day)
- Implement proper error handling for rate limit errors
- Consider adding retry logic with exponential backoff
- Show user-friendly messages if limits are reached

### Privacy & Data
- Photos are uploaded to Google's servers for processing
- Inform users about data usage in privacy policy
- Consider implementing local caching for photos
- Allow users to delete their data
- Comply with GDPR/privacy regulations if applicable

### Performance
- Compress images before uploading to API
- Use proper loading states during generation
- Cache generated images locally
- Implement proper error recovery

### Testing
- Test with various lighting conditions
- Test with different face angles
- Test with different phone models/cameras
- Test offline behavior
- Test permission denial scenarios

---

## 🐛 Troubleshooting

### Common Issues

**Issue: API Key not working**
- Verify billing is enabled on Google Cloud
- Check API key has Gemini API access
- Ensure API key is correctly copied (no extra spaces)

**Issue: Image generation fails**
- Confirm Imagen model access is enabled
- Check API quota/limits aren't exceeded
- Verify image files aren't too large (compress if needed)

**Issue: Permissions denied**
- Request permissions at runtime
- Guide users to settings if permanently denied
- Provide clear instructions for enabling permissions

**Issue: App crashes on image capture**
- Check minimum SDK versions are met
- Verify permissions are properly declared
- Test on physical device (emulator cameras can be unreliable)

---

## 📚 Additional Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Google Gemini API Docs](https://ai.google.dev/docs)
- [Imagen API Reference](https://cloud.google.com/vertex-ai/docs/generative-ai/image/overview)
- [Image Picker Package](https://pub.dev/packages/image_picker)
- [Flutter State Management](https://docs.flutter.dev/data-and-backend/state-mgmt/options)

---

## 🤝 Contributing

For developers working on this project:
1. Follow Flutter style guide
2. Write meaningful commit messages
3. Test thoroughly before committing
4. Document any API changes
5. Keep dependencies updated

---

## 📝 License

[Add your license information here]

---

## 👥 Team

- **Project Lead:** Angga Arifandi
- **Flutter Developer:** Angga Arifandi
- **UI/UX Designer:** Gemini AI

---

**Last Updated:** 26-11-2025
**Version:** 1.0.0