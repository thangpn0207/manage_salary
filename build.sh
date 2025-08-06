#!/bin/bash

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter SDK not found. Please install Flutter and add it to your PATH"
    exit 1
fi

# Get arguments
FLAVOR=$1
BUILD_TYPE=$2

# Function to show help message
show_help() {
    echo "Usage: ./build.sh {dev|staging|prod} {apk|appbundle|ios|web}"
    echo ""
    echo "Flavors:"
    echo "  dev, development   Development build"
    echo "  staging           Staging build"
    echo "  prod, production  Production build"
    echo ""
    echo "Build Types:"
    echo "  apk               Build Android APK"
    echo "  appbundle         Build Android App Bundle"
    echo "  ios              Build iOS archive (Mac only)"
    echo "  web              Build Web release"
    echo ""
    echo "Examples:"
    echo "  ./build.sh dev apk        # Build development APK"
    echo "  ./build.sh staging ios    # Build staging iOS archive"
    echo "  ./build.sh prod appbundle # Build production App Bundle"
}

# Process flavor argument
case $FLAVOR in
    "dev"|"development")
        FLAVOR="development"
        ADMOB_APP_ID="ca-app-pub-2103558986527802~5808548229"
        ADS_KEY=""
        ENABLE_ADS="false"
        ;;
    "staging")
        ADMOB_APP_ID="ca-app-pub-2103558986527802~5808548229"
        ADS_KEY=""
        ENABLE_ADS="true"
        ;;
    "prod"|"production")
        FLAVOR="production"
        ADMOB_APP_ID="ca-app-pub-2103558986527802~5808548229"
        ADS_KEY=""
        ENABLE_ADS="true"
        ;;
    "help"|"-h"|"--help")
        show_help
        exit 0
        ;;
    *)
        echo "❌ Invalid flavor: $FLAVOR"
        show_help
        exit 1
        ;;
esac

# Set up dart defines
DART_DEFINES="--dart-define=FLUTTER_ADS_KEY=$ADS_KEY"
DART_DEFINES="$DART_DEFINES --dart-define=ENABLE_ADS=$ENABLE_ADS"
DART_DEFINES="$DART_DEFINES --dart-define=ADMOB_APP_ID=$ADMOB_APP_ID"

# Build based on type
case $BUILD_TYPE in
    "apk")
        echo "🏗️ Building $FLAVOR APK..."
        flutter build apk --flavor $FLAVOR $DART_DEFINES
        
        if [ $? -eq 0 ]; then
            APK_PATH="build/app/outputs/flutter-apk/app-$FLAVOR-release.apk"
            if [ -f "$APK_PATH" ]; then
                echo "✅ APK built successfully!"
                echo "📱 Location: $APK_PATH"
            else
                echo "⚠️ Build succeeded but APK not found at expected location"
            fi
        else
            echo "❌ APK build failed"
            exit 1
        fi
        ;;
        
    "appbundle"|"aab")
        echo "🏗️ Building $FLAVOR App Bundle..."
        flutter build appbundle --flavor $FLAVOR $DART_DEFINES
        
        if [ $? -eq 0 ]; then
            AAB_PATH="build/app/outputs/bundle/$FLAVOR/release/app-$FLAVOR-release.aab"
            if [ -f "$AAB_PATH" ]; then
                echo "✅ App Bundle built successfully!"
                echo "📱 Location: $AAB_PATH"
            else
                echo "⚠️ Build succeeded but App Bundle not found at expected location"
            fi
        else
            echo "❌ App Bundle build failed"
            exit 1
        fi
        ;;
        
    "ios")
        # Check if running on macOS
        if [[ "$OSTYPE" != "darwin"* ]]; then
            echo "❌ iOS builds are only supported on macOS"
            exit 1
        fi
        
        echo "🏗️ Building $FLAVOR iOS archive..."
        flutter build ipa --flavor $FLAVOR $DART_DEFINES
        
        if [ $? -eq 0 ]; then
            echo "✅ iOS archive built successfully!"
            echo "📱 Archive can be found in build/ios/archive/"
        else
            echo "❌ iOS build failed"
            exit 1
        fi
        ;;
        
    "web")
        echo "🏗️ Building $FLAVOR web release..."
        flutter build web --flavor $FLAVOR $DART_DEFINES
        
        if [ $? -eq 0 ]; then
            echo "✅ Web build completed successfully!"
            echo "🌐 Build can be found in build/web/"
        else
            echo "❌ Web build failed"
            exit 1
        fi
        ;;
        
    *)
        echo "❌ Invalid build type: $BUILD_TYPE"
        show_help
        exit 1
        ;;
esac