#!/bin/bash

FLAVOR=$1

case $FLAVOR in
  "development")
    ADMOB_APP_ID=${ADMOB_APP_ID:-""}
    ADS_KEY=""
    ENABLE_ADS="false"
    DEBUG="true"
    ;;
  "staging")
    ADMOB_APP_ID=${ADMOB_APP_ID:-""}
    ADS_KEY=""
    ENABLE_ADS="true"
    DEBUG="false"
    ;;
  "production")
    ADMOB_APP_ID=${ADMOB_APP_ID:-""}
    ADS_KEY=""
    ENABLE_ADS="true"
    DEBUG="false"
    ;;
  *)
    echo "Usage: ./run.sh {development|staging|production}"
    exit 1
    ;;
esac

DART_DEFINES="--dart-define=FLUTTER_ADS_KEY=$ADS_KEY"
DART_DEFINES="$DART_DEFINES --dart-define=ENABLE_ADS=$ENABLE_ADS"
DART_DEFINES="$DART_DEFINES --dart-define=DEBUG=$DEBUG"
DART_DEFINES="$DART_DEFINES --dart-define=ADMOB_APP_ID=$ADMOB_APP_ID"

export ADMOB_APP_ID

flutter run --flavor $FLAVOR $DART_DEFINES