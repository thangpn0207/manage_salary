import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manage_salary/core/debug/debug_config.dart';
import 'package:manage_salary/core/observers/bloc_observer.dart';
import 'package:manage_salary/core/util/log_util.dart';
import 'package:manage_salary/ui/app.dart';

import 'core/dependency/injection.dart' as inject;

void main()async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize logging
  LogUtil.init();

  // Initialize debug configuration
  DebugConfig.init();
  
   // Initialize dependencies
  await inject.init("dev");
  // Set bloc observer
  Bloc.observer = ObserverBloc();
  runApp(const MyApp());
}
