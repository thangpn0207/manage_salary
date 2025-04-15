#!/bin/bash

FLAVOR=$1
BUILD_TYPE=$2

case $FLAVOR in
  "development")
    ADS_KEY=""
    ENABLE_ADS="false"
    DEBUG="true"
    ;;
  "staging")
    ADS_KEY=""
    ENABLE_ADS="true"
    DEBUG="false"
    ;;
  "production")
    ADS_KEY=""
    ENABLE_ADS="true"
    DEBUG="false"
    ;;
  *)
    echo "Usage: ./build.sh {development|staging|production} {apk|appbundle|ios}"
    exit 1
    ;;
esac

DART_DEFINES="--dart-define=FLUTTER_ADS_KEY=$ADS_KEY"
DART_DEFINES="$DART_DEFINES --dart-define=ENABLE_ADS=$ENABLE_ADS"
DART_DEFINES="$DART_DEFINES --dart-define=DEBUG=$DEBUG"

case $BUILD_TYPE in
  "apk")
    flutter build apk --release --flavor $FLAVOR $DART_DEFINES
    ;;
  "appbundle")
    flutter build appbundle --release --flavor $FLAVOR $DART_DEFINES
    ;;
  "ios")
    flutter build ios --release --flavor $FLAVOR $DART_DEFINES
    ;;
  *)
    echo "Usage: ./build.sh {development|staging|production} {apk|appbundle|ios}"
    exit 1
    ;;
esac