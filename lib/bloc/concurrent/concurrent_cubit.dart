import 'dart:ui';

import 'package:hydrated_bloc/hydrated_bloc.dart';
import '../../core/util/money_util.dart';

class CurrencyCubit extends HydratedCubit<Locale> {
  CurrencyCubit() : super(const Locale("vi")) {
    MoneyUtil.setCurrency(state.languageCode);
  }

  Future<void> setLocale(Locale locale) async {
    MoneyUtil.setCurrency(locale.languageCode);
    emit(locale);
  }

  Future<void> resetToDefault() async {
    MoneyUtil.setCurrency("vi");
    emit(const Locale("vi"));
  }

  bool isCurrentConcurrent(String languageCode) {
    return state.languageCode == languageCode;
  }

  @override
  Locale? fromJson(Map<String, dynamic> json) {
    final String? languageCode = json['languageCode'];
    final loc = Locale(languageCode ?? "vi");
    MoneyUtil.setCurrency(loc.languageCode);
    return loc;
  }

  @override
  Map<String, dynamic>? toJson(Locale state) {
    return {"languageCode": state.languageCode};
  }
}
