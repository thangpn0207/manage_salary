import 'package:flutter_test/flutter_test.dart';
import 'package:manage_salary/core/util/money_util.dart';

void main() {
  test('MoneyUtil format test', () {
    expect(MoneyUtil.format('#,##0', 100000), contains('100.000'));
    expect(MoneyUtil.formatDefault(100000, currency: 'vi_VN'), isNotEmpty);
  });
}
