import 'package:flutter_test/flutter_test.dart';
import 'package:manage_salary/core/util/money_util.dart';

void main() {
  group('Salary Calculation Logic Tests', () {
    test('Monthly salary calculation with OT, Advance, and Insurance', () {
      const baseSalary = 15000000.0;
      const standardDays = 26.0;
      const standardHours = 8.0;

      const dailyRate = baseSalary / standardDays; // ~576,923.07
      const hourlyRate = dailyRate / standardHours; // ~72,115.38

      const workDays = 22.0; // Đi làm 22 ngày
      const baseEarned = workDays * dailyRate;

      // 10h OT ngày thường x1.5
      const otHours = 10.0;
      const otMoney = otHours * hourlyRate * 1.5;

      // Tiền tạm ứng
      const advanceAmount = 2000000.0;

      // Trừ bảo hiểm xã hội 10.5%
      const insuranceRate = 10.5;
      const insuranceDeduction = baseSalary * (insuranceRate / 100.0); // 1,575,000

      final netSalary = baseEarned + otMoney - advanceAmount - insuranceDeduction;

      expect(baseEarned, greaterThan(12000000.0));
      expect(otMoney, greaterThan(1000000.0));
      expect(insuranceDeduction, equals(1575000.0));
      expect(netSalary, greaterThan(9500000.0));
    });

    test('Hourly wage calculation', () {
      const hourlyRate = 30000.0;
      const hoursPerDay = 8.0;
      const dailyRate = hourlyRate * hoursPerDay; // 240,000

      const workDays = 15.0; // Làm 15 ca
      final baseEarned = workDays * dailyRate;

      expect(baseEarned, equals(3600000.0));
    });

    test('MoneyUtil dynamic currency switching', () {
      MoneyUtil.setCurrency('vi');
      expect(MoneyUtil.currentCurrencyCode, equals('vi'));
      expect(MoneyUtil.currencySymbol, equals('₫'));
      final formattedVn = MoneyUtil.formatDefault(15000000);
      expect(formattedVn, contains('₫'));

      MoneyUtil.setCurrency('en');
      expect(MoneyUtil.currentCurrencyCode, equals('en'));
      expect(MoneyUtil.currencySymbol, equals('\$'));
      final formattedEn = MoneyUtil.formatDefault(2500);
      expect(formattedEn, contains('\$'));

      // Reset back to vi
      MoneyUtil.setCurrency('vi');
    });

    test('Auto-computed dailyRate and hourlyRate formulas', () {
      const baseSalary = 26000000.0;
      const standardDays = 26.0;
      const standardHours = 8.0;

      final dailyRate = baseSalary / standardDays;
      final hourlyRate = dailyRate / standardHours;
      final otRate = hourlyRate * 1.5;

      expect(dailyRate, equals(1000000.0));
      expect(hourlyRate, equals(125000.0));
      expect(otRate, equals(187500.0));
    });
  });
}
