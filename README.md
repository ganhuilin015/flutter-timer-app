# Timer

A Flutter-based timer application with support for Android and Web.

---

## Prerequisites

Before running the project, ensure you have the following installed:

* Flutter SDK
* Android Studio (recommended)
* Android SDK
* Chrome (for web development)
* A physical Android device or Android Emulator

Verify your Flutter installation:

```bash
flutter doctor
```

---

## Clone the Repository

```bash
git clone https://github.com/ganhuilin015/flutter-timer-app.git
cd timer
```

---

## Install Dependencies

Fetch all project dependencies:

```bash
flutter pub get
```

If you have modified dependencies in `pubspec.yaml`, run:

```bash
flutter pub get
```

To check for outdated packages:

```bash
flutter pub outdated
```

To upgrade packages:

```bash
flutter pub upgrade
```

---

# Running the Application

## Run on Web (Chrome)

```bash
flutter run -d chrome
```

If multiple devices are available, list them first:

```bash
flutter devices
```

---

## Run on an Android Device

Connect an Android device with USB Debugging enabled or start an Android Emulator.

Check available devices:

```bash
flutter devices
```

Run the application:

```bash
flutter run
```

or specify a device:

```bash
flutter run -d <device-id>
```

---

## Hot Reload

While the application is running:

* Press **r** for Hot Reload
* Press **R** for Hot Restart

---

# Building for Release
## Build and install it like the actual release

```bash
flutter run --release
```

## Build Android APK

Generate a release APK:

```bash
flutter build apk --release
```

Output location:

```
build/app/outputs/flutter-apk/app-release.apk
```

---

## Build Android App Bundle (Google Play Store)
First update the version in pubspec.yaml.

Generate an Android App Bundle (.aab):

```bash
flutter build appbundle --release
```

The generated bundle will be located at:

```
build/app/outputs/bundle/release/app-release.aab
```

This `.aab` file is the one that should be uploaded to the Google Play Console.

---

# Useful Flutter Commands

Clean the project:

```bash
flutter clean
```

Reinstall dependencies after cleaning:

```bash
flutter pub get
```

Analyze the project:

```bash
flutter analyze
```

Run unit tests:

```bash
flutter test
```

Format the codebase:

```bash
dart format .
```

Regenerate the .g.dart:

```bash
dart run build_runner build --delete-conflicting-outputs
```

---

# Deployment

### Android

1. Generate the release bundle:

```bash
flutter build appbundle --release
```

2. Navigate to:

```
build/app/outputs/bundle/release/
```

3. Upload `app-release.aab` to the Google Play Console.

---

# Troubleshooting

If you encounter build issues:

```bash
flutter clean
flutter pub get
flutter doctor
```

Then rebuild the application.

---

# Technologies

* Flutter
* Dart
* Android SDK
* Material Design
