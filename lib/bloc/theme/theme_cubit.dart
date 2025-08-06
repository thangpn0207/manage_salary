import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class ThemeCubit extends HydratedCubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.system);

  void setTheme(ThemeMode mode) async {
    emit(mode);
  }

  bool get isDarkMode => state == ThemeMode.dark;

  bool get isLightMode => state == ThemeMode.light;

  bool get isSystemMode => state == ThemeMode.system;

  @override
  ThemeMode? fromJson(Map<String, dynamic> json) {
    final themeMode = json['themeMode'] != null
        ? ThemeMode.values.firstWhere(
            (e) => e.toString() == json['themeMode'],
            orElse: () => ThemeMode.system,
          )
        : ThemeMode.system;

    return themeMode;
  }

  @override
  Map<String, dynamic>? toJson(ThemeMode state) {
    return {'themeMode': state.toString()};
  }
}
