# Manage Salary

A Flutter application designed to help users track and manage their income and expenses. Users can add income/expense
activities, view their total balance, see categorized expenses in a chart, and manage their activity list.

## Prerequisites

* Flutter SDK 3.19.0 or higher
* Dart SDK 3.3.0 or higher
* An IDE like VS Code or Android Studio with the Flutter plugin
* A configured emulator/simulator or a physical device
* Git for version control
* For iOS builds: Xcode 15.0+ (Mac only)
* For Android builds: Android Studio with Android SDK

## Features

* 💰 Income and expense tracking
* 📊 Visual charts and reports
* 🌙 Dark/Light theme support
* 🌍 Multi-language support
* 📱 Cross-platform (iOS, Android)
* 💾 Local data persistence
* 📊 Category-wise expense analysis
* 📅 Date-wise transaction filtering

## Getting Started

1. **Clone the repository:**
   ```bash
   git clone <https://github.com/thangpn0207/manage_salary.git>
   cd manage_salary
   ```

2. **Install dependencies:**
   Open a terminal in the project root directory and run:
   ```bash
   flutter pub get
   ```

3. **Run Build Runner (Code Generation):**
   If the project uses code generation (e.g., for localization, dependency injection), run the following command. The
   `--delete-conflicting-outputs` flag helps resolve issues if previously generated files conflict with new ones.
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

## Environment Setup

The app supports three environments:
- Development (`dev`): For development and testing
- Staging (`staging`): For pre-release testing
- Production (`prod`): For release builds

Each environment has its own configuration for:
- API endpoints
- Ad integration
- Analytics
- Feature flags

## Using Scripts

### Run Script (run.sh)
The project includes a `run.sh` script to simplify running the application in different environments:

```bash
# Basic usage
./run.sh {dev|staging|prod} [device-id]

# Examples
./run.sh dev                  # Run development build on default device
./run.sh staging pixel6      # Run staging build on Pixel 6 emulator
./run.sh prod                # Run production build
./run.sh help               # Show help message and list available devices
```

Environment configurations:
- **Development**: Debug mode enabled, ads disabled
- **Staging**: Debug mode disabled, ads enabled
- **Production**: Debug mode disabled, ads enabled

### Build Script (build.sh)
Use the `build.sh` script to create builds for different environments and build types:

```bash
# Usage
./build.sh {dev|staging|prod} {apk|appbundle|ios|web}

# Examples
./build.sh dev apk        # Build development APK
./build.sh staging ios    # Build staging iOS archive
./build.sh prod appbundle # Build production App Bundle
./build.sh prod web      # Build production web release
```

Build outputs will be located in:
- **APK**: `build/app/outputs/flutter-apk/app-[flavor]-release.apk`
- **App Bundle**: `build/app/outputs/bundle/[flavor]/release/app-[flavor]-release.aab`
- **iOS**: `build/ios/archive/`
- **Web**: `build/web/`

Note: iOS builds are only supported on macOS.

Make sure to make the scripts executable:
```bash
chmod +x run.sh build.sh
```

## Development Guidelines

### Code Style
- Follow the official [Flutter style guide](https://dart.dev/guides/language/effective-dart/style)
- Use `flutter format .` before committing
- Run `flutter analyze` to check for issues

### Git Workflow
1. Create a new branch from `develop`
2. Make your changes
3. Run tests and ensure they pass
4. Create a pull request to `develop`
5. After review, merge to `develop`

### Testing
Run the following commands to test your changes:
```bash
flutter test
flutter drive --target=test_driver/app.dart
```

## VS Code Configuration

The project includes VS Code launch configurations for different environments:

1. **Development Environment:**
   - Name: "Dev"
   - Features: Debug mode enabled, ads disabled
   - Launch with: F5 or Debug > Dev

2. **Staging Environment:**
   - Name: "Staging"
   - Features: Debug mode disabled, ads enabled
   - Launch with: F5 or Debug > Staging

3. **Production Environment:**
   - Name: "Production"
   - Features: Debug mode disabled, ads enabled
   - Launch with: F5 or Debug > Production

Profile modes are also available for each environment for performance testing.

## Building the Project

Flutter combines building and running into a single command for development. However, if you want to create a release
build:

* **Android:**
  ```bash
  flutter build apk --release  # For APK
  # or
  flutter build appbundle --release # For App Bundle
  ```
  The output files will be located in the `build/app/outputs/` directory.

* **iOS:**
  Open the `ios` folder in Xcode and follow the standard Xcode build and archive process.
  Alternatively, use the command line:
  ```bash
  flutter build ipa --release
  ```
  The output `.ipa` file will be located in the `build/ios/archive/` directory.

* **Web:**
  ```bash
  flutter build web
  ```
  The output files will be located in the `build/web/` directory.

## Running the Project

1. **Ensure a device is connected** or an emulator/simulator is running.
   You can list available devices with:
   ```bash
   flutter devices
   ```

2. **Run the application:**
    * From the terminal:
      ```bash
      flutter run
      ```
    * To run on a specific device (e.g., Chrome for web):
      ```bash
      flutter run -d chrome
      ```
    * Alternatively, use the "Run and Debug" feature in your IDE.

## Project Structure

```
lib/
├── bloc/          # Business Logic Components (BLoC pattern)
│   ├── activity/    # BLoC for managing activities
│   ├── locale/      # Cubit for managing app locale
│   └── theme/       # Cubit for managing app theme
├── core/          # Core utilities, constants, extensions, etc.
│   ├── constants/   # App-wide constants (colors, dimensions, etc.)
│   ├── dependency/  # Dependency injection setup
│   ├── extensions/  # Dart extension methods
│   ├── locale/      # Localization setup and generated files
│   ├── observers/   # Observers (Bloc, Navigator)
│   ├── routes/      # Routing configuration (GoRouter)
│   ├── theme/       # App theme definition
│   └── util/        # Utility functions
├── models/        # Data models
├── ui/            # User Interface widgets and screens
│   ├── components/  # Reusable UI components
│   ├── home/        # Home screen UI and widgets
│   ├── main/        # Main screen container (with BottomNavBar)
│   └── settings/    # Settings screen UI
└── main.dart      # App entry point
```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## Issues

Please report any bugs or feature requests by opening an issue on the project's repository.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Contact

Project Link: [https://github.com/thangpn0207/manage_salary](https://github.com/thangpn0207/manage_salary)

## Acknowledgments

* Flutter team for the amazing framework
* Contributors and users of the app
* Open source community
