import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../../core/locale/generated/l10n.dart';

class LocaleCubit extends HydratedCubit<Locale> {
  LocaleCubit() : super(Locale("en"));

  Future<void> setLocale(Locale locale) async {
    await S.load(locale);
    emit(locale);
  }

  Future<void> resetToDefault() async {
    emit(Locale("en"));
  }

  bool isCurrentLocale(String languageCode) {
    return state.languageCode == languageCode;
  }

  @override
  Locale? fromJson(Map<String, dynamic> json) {
    final String? languageCode = json['languageCode'];
    return Locale(languageCode ?? "en");
  }

  @override
  Map<String, dynamic>? toJson(Locale state) {
    return {"languageCode": state.languageCode};
  }
}
