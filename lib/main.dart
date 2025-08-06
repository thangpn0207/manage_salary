import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:manage_salary/core/config/build_config.dart';
import 'package:manage_salary/core/debug/debug_config.dart';
import 'package:manage_salary/core/observers/bloc_observer.dart';
import 'package:manage_salary/core/util/log_util.dart';
import 'package:manage_salary/ui/app.dart';
import 'package:path_provider/path_provider.dart';

import 'core/dependency/injection.dart' as inject;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const enableAds = bool.fromEnvironment('ENABLE_ADS');
  const debug = bool.fromEnvironment('DEBUG');
  const admob = String.fromEnvironment('ADMOB_APP_ID');

  debugPrint('🟢 App starting...');
  debugPrint('👉 ENABLE_ADS: $enableAds');
  debugPrint('👉 DEBUG: $debug');
  debugPrint('👉 ADMOB: $admob');
  // Initialize Google Mobile Ads SDK
  if (BuildConfig.enableAds) {
    await MobileAds.instance.initialize();
    // Enable debug logging for ads in development
    if (BuildConfig.debug) {
      MobileAds.instance.updateRequestConfiguration(
        RequestConfiguration(testDeviceIds: ['TEST_DEVICE_ID']),
      );
    }
  }

  // Initialize logging with build configuration
  LogUtil.init();

  // Initialize debug configuration
  DebugConfig.init(
    showLogs: kDebugMode,
    showNetworkLogs: kDebugMode,
    showBlocLogs: kDebugMode,
    showRouteLogs: kDebugMode,
  );
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorageDirectory.web
        : HydratedStorageDirectory((await getTemporaryDirectory()).path),
  );

  // Initialize dependencies with environment
  await inject.init(BuildConfig.debug ? "dev" : "prod");

  // Set bloc observer
  Bloc.observer = ObserverBloc();
  runApp(const MyApp());
}
