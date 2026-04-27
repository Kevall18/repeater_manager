# Repeater Manager

A Flutter multi-platform application for managing repeaters. This project demonstrates modern Flutter development practices with support for Android, iOS, Web, and Windows platforms from a single codebase.

**Status:** Active Development | **License:** MIT

## Supported Platforms

| Platform | Status | Notes |
|----------|--------|-------|
| Android  | ✓ Ready | Supports API 21+ |
| iOS      | ✓ Ready | Supports iOS 11.0+ |
| Web      | ✓ Ready | Chrome, Firefox, Safari |
| Windows  | ✓ Ready | Windows 10+ |

## Getting Started

### Prerequisites

- **Flutter SDK** 3.0.0 or later ([Download](https://flutter.dev/docs/get-started/install))
- **Git** 2.0+ ([Download](https://git-scm.com/downloads))
- **Chrome** (for web development)
- Platform-specific requirements:
  - **Android:** Android SDK 21+ (API Level 21+)
  - **iOS:** macOS 10.15+, Xcode 12.0+
  - **Windows:** Visual Studio 2019+ with C++ workload

### Quick Start

1. **Clone the repository:**
   ```bash
   git clone https://github.com/Kevall18/repeater_manager.git
   cd repeater_manager
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the app:**
   ```bash
   # For Web (Chrome)
   flutter run -d chrome
   
   # For Android emulator
   flutter run -d android
   
   # For iOS simulator (macOS only)
   flutter run -d ios
   
   # For Windows
   flutter run -d windows
   ```

### Platform-Specific Setup

#### Android
```bash
# Ensure Android SDK is installed
flutter doctor -v

# Run with verbose output to debug any issues
flutter run -d android -v
```

#### iOS (macOS only)
```bash
cd ios
pod install
cd ..
flutter run -d ios
```

#### Web
```bash
# Run with Chrome debug
flutter run -d chrome

# Build for release
flutter build web --release
```

#### Windows
```bash
# Ensure Visual C++ redistributable is installed
flutter run -d windows
```

## Features

- ✓ Counter app with Flutter Material Design
- ✓ Cross-platform support (Android, iOS, Web, Windows)
- ✓ Responsive UI with Material Design 3
- ✓ Hot reload for rapid development
- ✓ Comprehensive test coverage
- ✓ CI/CD ready

## Project Structure

```
repeater_manager/
├── lib/                          # Dart source code
│   └── main.dart               # Application entry point
├── android/                      # Android platform configuration
│   ├── app/                     # Android app module
│   └── gradle.properties        # Android build configuration
├── ios/                          # iOS platform configuration
│   ├── Runner/                  # iOS app project
│   └── Podfile                  # CocoaPods dependencies
├── web/                          # Web platform configuration
│   ├── index.html               # HTML entry point
│   └── manifest.json            # PWA manifest
├── windows/                      # Windows platform configuration
│   ├── runner/                  # Win32 runner
│   └── CMakeLists.txt           # Build configuration
├── test/                         # Unit and widget tests
├── pubspec.yaml                  # Project dependencies
└── README.md                      # This file
```

## Development

### Code Style

This project follows [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style).

Run formatter:
```bash
dart format lib/ test/ --line-length 80
```

### Linting

```bash
flutter analyze
```

### Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage
```

## Troubleshooting

### Build Issues

**Error: "Could not find the latest version of the Android SDK"**
```bash
flutter config --android-sdk=/path/to/android/sdk
```

**Error: "Gradle build failed"**
```bash
cd android
./gradlew clean
cd ..
flutter pub get
flutter run -d android
```

**Error: "iOS Pod install failed"**
```bash
cd ios
rm -rf Pods Pod.lock
pod install --repo-update
cd ..
```

### Runtime Issues

**App crashes on startup:**
1. Check `flutter doctor` for missing dependencies
2. Run `flutter clean` and rebuild
3. Verify all platform SDKs are installed

**Hot reload not working:**
- Try hot restart: Press `R` in the terminal
- Or stop and restart the app

## Contributing

Contributions are welcome! Please follow this workflow:

1. Create a feature branch:
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. Make your changes and test thoroughly:
   ```bash
   flutter test
   flutter analyze
   ```

3. Commit with clear messages:
   ```bash
   git commit -m "feat: add new feature"
   ```

4. Push to your branch:
   ```bash
   git push -u origin feature/your-feature-name
   ```

5. Open a Pull Request on GitHub
6. Address review comments
7. Once approved, your code will be merged to main

**Note:** The `main` branch is protected and requires pull requests for all changes.

## Performance Optimization

- Use `flutter build` with `--release` flag for production
- Monitor performance with DevTools:
  ```bash
  flutter pub global activate devtools
  devtools
  ```
- Profile with Android Studio or VS Code Flutter extensions

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
