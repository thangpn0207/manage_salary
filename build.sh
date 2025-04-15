#!/bin/bash

# Get the build flavor from command line argument
FLAVOR=$1
BUILD_NUMBER=$2

if [ -z "$FLAVOR" ]; then
    echo "Please provide a build flavor (development/staging/production)"
    exit 1
fi

if [ -z "$BUILD_NUMBER" ]; then
    BUILD_NUMBER=$(date +%s)
fi

# Set environment-specific variables
case $FLAVOR in
    "development")
        ENABLE_ADS=false
        ;;
    "staging")
        ENABLE_ADS=false
        ;;
    "production")
        ENABLE_ADS=true
        ;;
    *)
        echo "Invalid flavor. Use development, staging, or production"
        exit 1
        ;;
esac

# Build the app with the specified configuration
flutter build apk --flavor $FLAVOR \
    --build-number=$BUILD_NUMBER \
    --dart-define=ENABLE_ADS=$ENABLE_ADS

# Make the APK executable
chmod +x build/app/outputs/flutter-apk/app-$FLAVOR-release.apk

echo "Build completed for $FLAVOR environment"