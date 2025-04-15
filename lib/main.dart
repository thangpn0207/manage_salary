import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
