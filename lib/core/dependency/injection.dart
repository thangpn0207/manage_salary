import 'package:get_it/get_it.dart';
import 'package:manage_salary/bloc/activity/activity_bloc.dart';
import 'package:manage_salary/bloc/locale/cubit/locale_cubit.dart';
import 'package:manage_salary/bloc/theme/cubit/theme_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> init(String baseUrl) async {
  // Initialize shared preferences first
  final prefs = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(prefs);

  _configureBlocs();
  _configureRepositories();
  _configureCores(baseUrl);
  _configureUseCases();
}

void _configureCores(String baseUrl) {
  // getIt.registerLazySingleton<Dio>(() => DioManager(baseUrl).createDio());
}

void _configureRepositories() {}

void _configureUseCases() {}

void _configureBlocs() {
  // Register ThemeCubit
  getIt
    ..registerSingleton<ActivityBloc>(ActivityBloc())
    ..registerSingleton<ThemeCubit>(ThemeCubit(getIt<SharedPreferences>()))

    // Register LocaleCubit
    ..registerSingleton<LocaleCubit>(LocaleCubit(getIt<SharedPreferences>()));
}
