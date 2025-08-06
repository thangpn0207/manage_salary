import 'dart:ui';

import 'package:hydrated_bloc/hydrated_bloc.dart';

class CurrencyCubit extends HydratedCubit<Locale> {
  CurrencyCubit() : super(Locale("en"));

  Future<void> setLocale(Locale locale) async {
    emit(locale);
  }

  Future<void> resetToDefault() async {
    emit(Locale("en"));
  }

  bool isCurrentConcurrent(String languageCode) {
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
