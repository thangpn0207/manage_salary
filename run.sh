#!/bin/bash

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter SDK not found. Please install Flutter and add it to your PATH"
    exit 1
fi

# Check arguments
FLAVOR=$1
DEVICE=$2

# Function to list available devices
list_devices() {
    echo "📱 Available devices:"
    flutter devices
}

case $FLAVOR in
    "dev"|"development")
        FLAVOR="development"
        ADMOB_APP_ID="ca-app-pub-2103558986527802~5808548229"
        ADS_KEY=""
        ENABLE_ADS="false"
        DEBUG="true"
        ;;
    "staging")
        ADMOB_APP_ID="ca-app-pub-2103558986527802~5808548229"
        ADS_KEY=""
        ENABLE_ADS="true"
        DEBUG="false"
        ;;
    "prod"|"production")
        FLAVOR="production"
        ADMOB_APP_ID="ca-app-pub-2103558986527802~5808548229"
        ADS_KEY=""
        ENABLE_ADS="true"
        DEBUG="false"
        ;;
    "help"|"-h"|"--help")
        echo "Usage: ./run.sh {dev|staging|prod} [device-id]"
        echo "Examples:"
        echo "  ./run.sh dev                  # Run development build on default device"
        echo "  ./run.sh staging pixel6      # Run staging build on Pixel 6 emulator"
        echo "  ./run.sh prod                # Run production build"
        echo ""
        list_devices
        exit 0
        ;;
    *)
        echo "❌ Invalid flavor: $FLAVOR"
        echo "Usage: ./run.sh {dev|staging|prod} [device-id]"
        echo "Run './run.sh help' for more information"
        exit 1
        ;;
esac

# Construct dart defines
DART_DEFINES="--dart-define=FLUTTER_ADS_KEY=$ADS_KEY"
DART_DEFINES="$DART_DEFINES --dart-define=ENABLE_ADS=$ENABLE_ADS"
DART_DEFINES="$DART_DEFINES --dart-define=DEBUG=$DEBUG"
DART_DEFINES="$DART_DEFINES --dart-define=ADMOB_APP_ID=$ADMOB_APP_ID"

export ADMOB_APP_ID

# If device is specified, add it to the command
if [ -n "$DEVICE" ]; then
    echo "🚀 Running $FLAVOR build on device: $DEVICE"
    flutter run --flavor $FLAVOR $DART_DEFINES -d $DEVICE
else
    echo "🚀 Running $FLAVOR build"
    flutter run --flavor $FLAVOR $DART_DEFINES
fi