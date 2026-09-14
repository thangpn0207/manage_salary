import 'package:intl/intl.dart';

const String kCommonMoneyFormat = "#,##0";

class MoneyUtil {
  static String currentCurrencyCode = 'vi';

  static void setCurrency(String code) {
    currentCurrencyCode = code;
  }

  static String format(String pattern, num number) {
    final locale = currentCurrencyCode == 'en' ? 'en_US' : 'vi_VN';
    final oCcy = NumberFormat(pattern, locale);
    return oCcy.format(number);
  }

  static String formatDefault(num number, {String? currency}) {
    final activeCurrency = currency ?? currentCurrencyCode;
    final oCcy = NumberFormat.simpleCurrency(locale: activeCurrency);
    return oCcy.format(number);
  }

  static String formatMoney(num number, {String? currency}) {
    return formatDefault(number, currency: currency);
  }

  static String get currencySymbol {
    return NumberFormat.simpleCurrency(locale: currentCurrencyCode).currencySymbol;
  }
}
