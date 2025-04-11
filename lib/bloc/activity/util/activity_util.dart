import 'package:manage_salary/core/util/date_util.dart'; // For date comparison

import '../../../core/constants/enums.dart';
import '../../../models/activity_data.dart';
import '../../../models/recurring_activity.dart';

// --- Calculation, Generation & Pruning Utility Functions ---
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

  // Updated to use ActivityType
  Map<ActivityType, double> calculateExpensesByType(
      List<ActivityData> activities) {
    final Map<ActivityType, double> spending = {};
    activities
        .where((a) => a.nature == ActivityNature.expense)
        .forEach((activity) {
      spending.update(
        activity.type, // Use the type field
        (value) => value + activity.amount,
        ifAbsent: () => activity.amount,
      );
    });
    return spending;
  }

  // Updated to use ActivityType
  Map<ActivityType, double> calculateIncomeByType(List<ActivityData> activities) {
    final Map<ActivityType, double> incomeMap = {};
    activities
        .where((a) => a.nature == ActivityNature.income)
        .forEach((activity) {
      incomeMap.update(
        activity.type, // Use the type field
        (value) => value + activity.amount,
        ifAbsent: () => activity.amount,
      );
    });
    return incomeMap;
  }

  // --- Date Range Helpers ---

  ({DateTime start, DateTime end}) getTodayRange() {
    final now = DateTime.now();
    final start = DateUtil.startOfDay(now);
    final end = start.add(const Duration(days: 1));
    return (start: start, end: end);
  }

  ({DateTime start, DateTime end}) getThisWeekRange(
      {int startOfWeek = DateTime.monday}) {
    final now = DateTime.now();
    final start = DateUtil.startOfWeek(now, startOfWeek: startOfWeek);
    final end = start.add(const Duration(days: 7));
    return (start: start, end: end);
  }

  ({DateTime start, DateTime end}) getThisMonthRange() {
    final now = DateTime.now();
    final start = DateUtil.startOfMonth(now);
    final end = DateUtil.startOfNextMonth(now);
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

  // --- Recurring Activity Generation (Moved to BLoC) ---
  // The generation logic is now primarily within the ActivityBloc's
  // _onGenerateRecurringInstances handler for better state access.
  // Keeping date calculation helpers might still be useful.

  DateTime? calculateNextDueDate(RecurringFrequency frequency, DateTime currentDate) {
     try {
      switch (frequency) {
        case RecurringFrequency.daily:
          return currentDate.add(const Duration(days: 1));
        case RecurringFrequency.weekly:
          return currentDate.add(const Duration(days: 7));
        case RecurringFrequency.biWeekly:
          return currentDate.add(const Duration(days: 14));
        case RecurringFrequency.monthly:
            var newMonth = currentDate.month + 1;
            var newYear = currentDate.year;
            if (newMonth > 12) {
              newMonth = 1;
              newYear++;
            }
            var daysInNewMonth = DateTime(newYear, newMonth + 1, 0).day;
            var newDay = currentDate.day > daysInNewMonth ? daysInNewMonth : currentDate.day;
            return DateTime(newYear, newMonth, newDay);
        case RecurringFrequency.yearly:
            var newDay = currentDate.day;
            if (currentDate.month == 2 && currentDate.day == 29) {
                if (!DateTime(currentDate.year + 1, 1, 1).isUtc) { // Approx leap year check
                   if (!(((currentDate.year + 1) % 4 == 0) && (((currentDate.year + 1) % 100 != 0) || ((currentDate.year + 1) % 400 == 0)))) {
                     newDay = 28;
                   }
                }
            }
            return DateTime(currentDate.year + 1, currentDate.month, newDay);
      }
    } catch (e) {
      print("Error calculating next due date in Util: $e");
      return null;
    }
  }
}
