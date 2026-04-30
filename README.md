# 🎓 Intelligent Admissions Assistant

A Flutter mobile application designed to guide students through the **UAF Burewala Campus** university admissions process intelligently. The app provides program exploration, eligibility calculation, AI-powered guidance, application tracking, and seamless Firebase-backed user management.

---

## ✨ Features

| Feature | Description |
|---------|-------------|
| 🔐 **Authentication** | Firebase Auth — sign up, login, password reset with persistent session |
| 👤 **User Profile** | Extended profile with CNIC, intermediate discipline, photo |
| 🏠 **Home Dashboard** | Welcome banner, quick actions, program cards, deadlines & notifications |
| 🔎 **Program Explorer** | Browse & filter UAF degree programs by faculty/discipline |
| 📋 **Degree Detail** | Full program info — duration, fee, eligibility, aggregate formula |
| 📐 **Eligibility Calculator** | Dual-mode: check eligibility & calculate aggregate score |
| 📊 **Application Tracker** | Track admission application status step-by-step |
| 🤖 **AI Chat Assistant** | AI-powered chat to answer admissions questions |
| ⚙️ **Settings** | Profile management, notifications, terms & privacy |

---

## 📱 Screens

| Screen | File |
|--------|------|
| Login | `login_screen.dart` |
| Sign Up (with CNIC + Discipline) | `signup_screen.dart` |
| Forgot Password | `forgot_password_screen.dart` |
| Home Dashboard | `home_screen.dart` |
| Program Explorer | `program_explore_screen.dart` |
| Degree Detail | `degree_detail_screen.dart` |
| Eligibility & Aggregate Calculator | `eligibility_screen.dart` |
| Application Tracker | `application_tracker_screen.dart` |
| AI Chat Assistant | `ai_chat_screen.dart` |
| Settings | `settings_screen.dart` |
| Terms & Privacy | `terms_privacy_screen.dart` |

---

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) **3.19+** (Dart ≥ 3.3.0)
- [Android Studio](https://developer.android.com/studio) **Hedgehog (2023.1.1)** or later
- Flutter & Dart plugins installed in Android Studio
- Android SDK (API 21+)
- A Firebase project with **Authentication** and **Cloud Firestore** enabled

### Setup Steps

#### 1. Open in Android Studio
```
File → Open → Select the `intelligent_admissions_v2` folder
```

#### 2. Install Flutter & Dart Plugins
```
Android Studio → Settings → Plugins → Search "Flutter" → Install
```

#### 3. Configure Firebase
- Create a project at [Firebase Console](https://console.firebase.google.com/)
- Enable **Email/Password** sign-in under Authentication
- Create a **Cloud Firestore** database
- Run `flutterfire configure` and replace `lib/firebase_options.dart` with the generated file

#### 4. Get Dependencies
```bash
flutter pub get
```
Or click **"Pub get"** in the banner that appears in `pubspec.yaml`.

#### 5. Configure an Emulator
```
Tools → Device Manager → Create Device → Pixel 6 → Android 13 (API 33)
```

#### 6. Run the App
```bash
flutter run
```
Or select your device in Android Studio and click **▶ Run** (Shift+F10).

---

## 📁 Project Structure

```
intelligent_admissions_v2/
├── android/                            # Android platform files
├── ios/                                # iOS platform files
│
├── lib/
│   ├── main.dart                       # App entry point + Firebase init + auth routing
│   ├── firebase_options.dart           # FlutterFire generated config
│   │
│   ├── data/
│   │   └── uaf_programs_data.dart      # All UAF program data, fees, eligibility rules
│   │
│   ├── models/
│   │   ├── degree_program_model.dart   # DegreeProgram data model
│   │   ├── notification_model.dart     # In-app notification model
│   │   ├── program_model.dart          # Lightweight program model
│   │   └── deadline_model.dart         # Admission deadline model
│   │
│   ├── screens/
│   │   ├── login_screen.dart           # Firebase email/password login
│   │   ├── signup_screen.dart          # Registration (name, email, CNIC, discipline)
│   │   ├── forgot_password_screen.dart # Password reset via email
│   │   ├── home_screen.dart            # Dashboard with programs & deadlines
│   │   ├── program_explore_screen.dart # Filterable program browser
│   │   ├── degree_detail_screen.dart   # Program detail view
│   │   ├── eligibility_screen.dart     # Eligibility checker & aggregate calculator
│   │   ├── application_tracker_screen.dart # Admission status tracker
│   │   ├── ai_chat_screen.dart         # AI-powered admissions chatbot
│   │   ├── settings_screen.dart        # Profile & app settings
│   │   └── terms_privacy_screen.dart   # Terms of service & privacy policy
│   │
│   ├── services/
│   │   ├── auth_service.dart           # Firebase Auth wrapper (sign up, login, reset)
│   │   └── user_profile_service.dart   # Firestore user profile CRUD
│   │
│   ├── utils/
│   │   └── app_colors.dart             # Centralized color palette
│   │
│   └── widgets/
│       ├── app_button.dart             # Reusable primary button
│       ├── app_text_field.dart         # Reusable styled input field
│       └── logo_widget.dart            # Animated UAF logo with sun rays
│
├── test/
│   └── widget_test.dart
│
├── pubspec.yaml                        # Dependencies & assets
├── firebase.json                       # Firebase hosting config
├── analysis_options.yaml               # Linting rules
└── .gitignore
```

---

## 📦 Dependencies

```yaml
firebase_core: ^3.0.0          # Firebase core initialization
firebase_auth: ^5.0.0          # Email/password authentication
cloud_firestore: ^5.0.0        # User profile & data storage
google_fonts: ^6.2.1           # Poppins typography
image_picker: ^1.0.0           # Profile photo selection
cupertino_icons: ^1.0.8        # iOS-style icons
```

---

## 🗄️ Firestore Data Model

### `users/{uid}` — User Profile Document

| Field | Type | Description |
|-------|------|-------------|
| `name` | String | User's full name |
| `email` | String | Registered email address |
| `cnic` | String | CNIC in format `XXXXX-XXXXXXX-X` |
| `intermediateDiscipline` | String | e.g. Pre-Medical, Pre-Engineering, ICS |
| `profilePhotoUrl` | String | URL of uploaded profile photo |
| `createdAt` | Timestamp | Account creation timestamp |

---

## 🎨 Design System

| Token | Value |
|-------|-------|
| Primary | `#9333EA` (Purple) |
| Gold Accent | `#F59E0B` |
| Background | `#F5F5F5` |
| Text Dark | `#1F2937` |
| Text Grey | `#9CA3AF` |
| Font | **Poppins** (via Google Fonts) |

---

## 🔧 Troubleshooting

| Problem | Solution |
|---------|----------|
| **"Flutter SDK not found"** | `File → Settings → Languages & Frameworks → Flutter → Set SDK path` |
| **Gradle sync failed** | `File → Sync Project with Gradle Files` |
| **Emulator not showing** | `Tools → Device Manager → Start emulator` |
| **Firebase not initialized** | Ensure `google-services.json` is in `android/app/` and `firebase_options.dart` is present |
| **Account created but no Firestore data** | Fixed — profile now saved using explicit UID from `UserCredential` |
| **CNIC not saving** | Enter full 13 digits in format `XXXXX-XXXXXXX-X` |

---

## 📋 Version History

| Version | Changes |
|---------|---------|
| `1.0.0` | Initial release — Login, Signup, Home |
| `1.1.0` | Added Program Explorer, Degree Detail, Eligibility Calculator |
| `1.2.0` | Added AI Chat, Application Tracker, Settings, Terms & Privacy |
| `1.3.0` | Extended signup with CNIC & Intermediate Discipline fields; fixed Firestore profile save race condition |

---

## 👨‍💻 Developed For

**University of Agriculture Faisalabad (UAF) — Burewala Campus**

> Helping prospective students navigate admissions with confidence.
