import 'package:get_it/get_it.dart';
import 'package:manage_salary/bloc/concurrent/concurrent_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../bloc/activity/activity_bloc.dart';
import '../../bloc/locale/locale_cubit.dart';
import '../../bloc/salary/salary_bloc.dart';
import '../../bloc/theme/theme_cubit.dart';
import '../../bloc/travel_note/travel_note_bloc.dart';
import '../../data/local/salary_database.dart';
import '../../data/local/travel_note_database.dart';
import '../../data/repositories/salary_repository.dart';
import '../../data/repositories/travel_note_repository.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  // Initialize shared preferences first
  final prefs = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(prefs);
  _configureCores();
  _configureRepositories();
  _configureBlocs();
  _configureUseCases();
}

void _configureCores() {
  // getIt.registerLazySingleton<Dio>(() => DioManager().createDio());
  getIt.registerLazySingleton<TravelNoteDatabase>(() => TravelNoteDatabase());
  getIt.registerLazySingleton<SalaryDatabase>(() => SalaryDatabase());
}

void _configureRepositories() {
  // Register repository
  getIt.registerSingleton<TravelNoteRepository>(
    TravelNoteRepository(getIt<TravelNoteDatabase>()),
  );
  getIt.registerSingleton<SalaryRepository>(
    SalaryRepository(getIt<SalaryDatabase>()),
  );
}

void _configureUseCases() {}

void _configureBlocs() {
  // Register ThemeCubit
  final activityBloc = ActivityBloc();
  getIt
    ..registerSingleton<ActivityBloc>(activityBloc)
    ..registerSingleton<ThemeCubit>(ThemeCubit())
    ..registerSingleton<CurrencyCubit>(CurrencyCubit())

    // Register LocaleCubit
    ..registerSingleton<LocaleCubit>(LocaleCubit())

    // Register TravelNoteBloc
    ..registerSingleton<TravelNoteBloc>(
      TravelNoteBloc(getIt<TravelNoteRepository>()),
    )

    // Register SalaryBloc
    ..registerSingleton<SalaryBloc>(
      SalaryBloc(
        repository: getIt<SalaryRepository>(),
        activityBloc: activityBloc,
      ),
    );
}
