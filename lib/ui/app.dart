import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:manage_salary/bloc/activity/activity_bloc.dart';
import 'package:manage_salary/bloc/locale/cubit/locale_cubit.dart';
import 'package:manage_salary/bloc/theme/cubit/theme_cubit.dart';
import 'package:manage_salary/core/dependency/injection.dart';
import 'package:manage_salary/core/locale/generated/l10n.dart';
import 'package:manage_salary/core/routes/app_router.dart';
import 'package:manage_salary/core/theme/app_theme.dart';
import 'package:manage_salary/core/util/deep_link_handler.dart';
import 'package:manage_salary/core/util/log_util.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  // Store cubit instances directly
  final List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initDeepLinks();
    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  void _initDeepLinks() {
    DeepLinkHandler().setupDeepLinks();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    late List<ConnectivityResult> result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
      LogUtil.e("Connected $result");
    } on PlatformException catch (e) {
      LogUtil.e('Couldn\'t check connectivity status', error: e);
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    LogUtil.i('Connectivity changed: $_connectionStatus');
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // When the screen is reopened, check the keyboard state
      final currentFocus = FocusManager.instance.primaryFocus;
      if (currentFocus != null && currentFocus.hasFocus) {
        // If the keyboard is displayed, unfocus it
        SystemChannels.textInput.invokeMethod('TextInput.hide');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
      ),
    );

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<ThemeCubit>()),
        BlocProvider(create: (context) => getIt<LocaleCubit>()),
        BlocProvider(create: (context) => getIt<ActivityBloc>()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return BlocBuilder<LocaleCubit, Locale>(
            builder: (context, locale) {
              return ScreenUtilInit(
                designSize: const Size(360, 690),
                minTextAdapt: true,
                splitScreenMode: true,
                builder: (context, child) {
                  return MaterialApp.router(
                    routerConfig: AppRouter.router,
                    debugShowCheckedModeBanner: false,
                    title: 'Lotus CEX',
                    theme: AppTheme.lightTheme,
                    darkTheme: AppTheme.darkTheme,
                    themeMode: themeMode,
                    locale: locale,
                    supportedLocales: S.delegate.supportedLocales,
                    localizationsDelegates: const [
                      S.delegate,
                      GlobalMaterialLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                      GlobalCupertinoLocalizations.delegate,
                    ],
                    builder: (context, child) {
                      return child ?? const SizedBox.shrink();
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
