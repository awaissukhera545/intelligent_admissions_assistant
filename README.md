# 🎓 Intelligent Admissions Assistant

A Flutter mobile application designed to guide students through the university admissions process intelligently.

---

## 📱 Screens

| Screen | Description |
|--------|-------------|
| **Login** | Purple themed splash/login with graduation cap logo |
| **Sign Up** | Account creation with full name, email, password |
| **Forgot Password** | Email-based password reset flow |
| **Home Dashboard** | Welcome banner, quick actions, programs, deadlines |

---

## 🚀 Getting Started in Android Studio

### Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install) **3.19+**
- [Android Studio](https://developer.android.com/studio) **Hedgehog (2023.1.1)** or later
- Flutter & Dart plugins installed in Android Studio
- Android SDK (API 21+)

### Setup Steps

#### 1. Open in Android Studio
```
File → Open → Select the `intelligent_admissions` folder
```

#### 2. Install Flutter & Dart Plugins
```
Android Studio → Settings → Plugins → Search "Flutter" → Install
```

#### 3. Get Dependencies
```bash
flutter pub get
```
Or click **"Pub get"** in the banner that appears in `pubspec.yaml`.

#### 4. Configure an Emulator
```
Tools → Device Manager → Create Device → Pixel 6 → Android 13 (API 33)
```

#### 5. Run the App
- Select your device/emulator from the dropdown
- Click the **▶ Run** button (Shift+F10)
- Or via terminal: `flutter run`

---

## 📁 Project Structure

```
intelligent_admissions/
├── android/                          # Android platform files
│   ├── app/
│   │   ├── build.gradle              # App-level Gradle config
│   │   └── src/main/
│   │       ├── AndroidManifest.xml   # App manifest
│   │       ├── kotlin/               # MainActivity.kt
│   │       └── res/                  # Resources (styles, drawables)
│   ├── build.gradle                  # Project-level Gradle
│   └── gradle/wrapper/               # Gradle wrapper
│
├── ios/                              # iOS platform files
│
├── lib/                              # Dart source code
│   ├── main.dart                     # App entry point
│   ├── models/
│   │   ├── program_model.dart        # Program data model
│   │   └── deadline_model.dart       # Deadline data model
│   ├── screens/
│   │   ├── login_screen.dart         # Login page
│   │   ├── signup_screen.dart        # Registration page
│   │   ├── forgot_password_screen.dart  # Password reset
│   │   └── home_screen.dart          # Dashboard
│   ├── utils/
│   │   ├── app_colors.dart           # Color constants
│   │   └── app_routes.dart           # Route names
│   └── widgets/
│       ├── app_button.dart           # Reusable button
│       ├── app_text_field.dart       # Reusable input field
│       └── logo_widget.dart          # Animated logo with sun rays
│
├── test/
│   └── widget_test.dart              # Widget tests
│
├── pubspec.yaml                      # Dependencies & assets
├── analysis_options.yaml             # Linting rules
└── .gitignore
```

---

## 📦 Dependencies

```yaml
google_fonts: ^6.2.1   # Poppins font
cupertino_icons: ^1.0.8
```

---

## 🎨 Design System

| Token | Value |
|-------|-------|
| Primary | `#9333EA` (Purple) |
| Gold Accent | `#F59E0B` |
| Background | `#F5F5F5` |
| Text Dark | `#1F2937` |
| Text Grey | `#9CA3AF` |
| Font | Poppins (via Google Fonts) |

---

## 🔧 Troubleshooting

**"Flutter SDK not found"** → `File → Settings → Languages & Frameworks → Flutter → Set SDK path`

**Gradle sync failed** → `File → Sync Project with Gradle Files`

**Emulator not showing** → `Tools → Device Manager → Start emulator`
