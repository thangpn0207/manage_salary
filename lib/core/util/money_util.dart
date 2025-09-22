import 'package:intl/intl.dart';

const String kCommonMoneyFormat = "#,##0";

class MoneyUtil {
  static String format(String pattern, num number) {
    final oCcy = NumberFormat(pattern, "vi_VN");
    return oCcy.format(number);
  }

  static String formatDefault(num number, {String currency = "vi_VN"}) {
    final oCcy = NumberFormat.simpleCurrency(locale: currency);
    return oCcy.format(number);
  }
}
