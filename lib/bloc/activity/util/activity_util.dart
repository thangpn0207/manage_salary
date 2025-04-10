import '../../../core/constants/enums.dart';
import '../../../models/activity_data.dart';

// --- Calculation & Pruning Utility Functions ---
class ActivityUtil {
  List<ActivityData> pruneActivities(List<ActivityData> activities) {
    // Keep activities within the last 3 months (approx 90 days)
    final cutoffDate = DateTime.now().subtract(const Duration(days: 90));
    final filtered = activities
        .where((activity) => activity.date.isAfter(cutoffDate))
        .toList();
    return filtered;
  }

  double calculateTotalIncome(List<ActivityData> activities) {
    return activities
        .where((a) => a.nature == ActivityNature.income)
        .fold(0.0, (sum, a) => sum + a.amount);
  }

  double calculateTotalExpenses(List<ActivityData> activities) {
    return activities
        .where((a) => a.nature == ActivityNature.expense)
        .fold(0.0, (sum, a) => sum + a.amount);
  }

  Map<ActivityPaying, double> calculateExpensesByType(
      List<ActivityData> activities) {
    final Map<ActivityPaying, double> spending = {};
    activities
        .where((a) => a.nature == ActivityNature.expense)
        .forEach((activity) {
      spending.update(
        activity.activityType ?? ActivityPaying.other,
        (value) => value + activity.amount,
        ifAbsent: () => activity.amount,
      );
    });
    return spending;
  }

  Map<ActivityPaying, double> calculateIncomeByType(
      List<ActivityData> activities) {
    final Map<ActivityPaying, double> incomeMap = {};
    activities
        .where((a) => a.nature == ActivityNature.income)
        .forEach((activity) {
      incomeMap.update(
        activity.activityType ?? ActivityPaying.other,
        (value) => value + activity.amount,
        ifAbsent: () => activity.amount,
      );
    });
    return incomeMap;
  }

  ({DateTime start, DateTime end}) getTodayRange() {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day);
    final end = DateTime(now.year, now.month, now.day + 1);
    return (start: start, end: end);
  }

  ({DateTime start, DateTime end}) getThisWeekRange(
      {int startOfWeek = DateTime.monday}) {
    final now = DateTime.now();
    final daysToSubtract = (now.weekday - startOfWeek + 7) % 7;
    final start = DateTime(now.year, now.month, now.day - daysToSubtract);
    final end = start.add(const Duration(days: 7));
    return (start: start, end: end);
  }

  ({DateTime start, DateTime end}) getThisMonthRange() {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, 1);
    final end = (now.month < 12)
        ? DateTime(now.year, now.month + 1, 1)
        : DateTime(now.year + 1, 1, 1);
    return (start: start, end: end);
  }

  ({double income, double expense}) calculatePeriodTotals(
    List<ActivityData> activities,
    ({DateTime start, DateTime end}) range,
  ) {
    double income = 0.0;
    double expense = 0.0;
    for (final activity in activities) {
      if (!activity.date.isBefore(range.start) &&
          activity.date.isBefore(range.end)) {
        if (activity.nature == ActivityNature.income) {
          income += activity.amount;
        } else {
          expense += activity.amount;
        }
      }
    }
    return (income: income, expense: expense);
  }
}
