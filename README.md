# Manage Salary

A Flutter application designed to help users track and manage their income and expenses. Users can add income/expense
activities, view their total balance, see categorized expenses in a chart, and manage their activity list.

## Prerequisites

* Flutter SDK installed (version 3.x or higher recommended)
* An IDE like VS Code or Android Studio with the Flutter plugin
* A configured emulator/simulator or a physical device

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

## Issues

Please report any bugs or feature requests by opening an issue on the project's repository.
