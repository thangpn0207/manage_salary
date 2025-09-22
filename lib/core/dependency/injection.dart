import 'package:get_it/get_it.dart';
import 'package:manage_salary/bloc/concurrent/concurrent_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../bloc/activity/activity_bloc.dart';
import '../../bloc/locale/locale_cubit.dart';
import '../../bloc/theme/theme_cubit.dart';
import '../../bloc/travel_note/travel_note_bloc.dart';
import '../../data/local/travel_note_database.dart';
import '../../data/repositories/travel_note_repository.dart';

final getIt = GetIt.instance;

Future<void> init(String baseUrl) async {
  // Initialize shared preferences first
  final prefs = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(prefs);
  _configureCores(baseUrl);
  _configureRepositories();
  _configureBlocs();
  _configureUseCases();
}

void _configureCores(String baseUrl) {
  // getIt.registerLazySingleton<Dio>(() => DioManager(baseUrl).createDio());
  getIt.registerLazySingleton<TravelNoteDatabase>(() => TravelNoteDatabase());
}

void _configureRepositories() {
  // Register repository
  getIt.registerSingleton<TravelNoteRepository>(
    TravelNoteRepository(getIt<TravelNoteDatabase>()),
  );
}

void _configureUseCases() {}

void _configureBlocs() {
  // Register ThemeCubit
  getIt
    ..registerSingleton<ActivityBloc>(ActivityBloc())
    ..registerSingleton<ThemeCubit>(ThemeCubit())
    ..registerSingleton<CurrencyCubit>(CurrencyCubit())

    // Register LocaleCubit
    ..registerSingleton<LocaleCubit>(LocaleCubit())

    // Register TravelNoteBloc
    ..registerSingleton<TravelNoteBloc>(
      TravelNoteBloc(getIt<TravelNoteRepository>()),
    );
}
