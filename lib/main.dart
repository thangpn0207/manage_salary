import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:manage_salary/core/debug/debug_config.dart';
import 'package:manage_salary/core/observers/bloc_observer.dart';
import 'package:manage_salary/core/util/log_util.dart';
import 'package:manage_salary/ui/app.dart';
import 'package:path_provider/path_provider.dart';

import 'core/dependency/injection.dart' as inject;

import 'package:manage_salary/core/services/ad_manager.dart';
import 'package:manage_salary/core/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize AdManager
  await AdManager.instance.init();

  // Initialize Notification Service
  await NotificationService.instance.init();

  // Initialize logging with build configuration
  LogUtil.init();

  // Initialize debug configuration
  DebugConfig.init(
    showLogs: kDebugMode,
    showNetworkLogs: kDebugMode,
    showBlocLogs: kDebugMode,
    showRouteLogs: kDebugMode,
  );
  // Set bloc observer
  Bloc.observer = ObserverBloc();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorageDirectory.web
        : HydratedStorageDirectory((await getTemporaryDirectory()).path),
  );

  // Initialize dependencies
  await inject.init();

  runApp(const MyApp());
}
