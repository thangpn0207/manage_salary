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
        activity.type,
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
        activity.type,
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

  // --- Recurring Activity Generation ---

  List<ActivityData> generateInstances(
    RecurringActivity recurring,
    List<ActivityData> existingActivities,
    DateTime upToDate,
  ) {
    final List<ActivityData> newInstances = [];
    DateTime nextDate = recurring.startDate;

    // Find the last generated instance for this recurring activity
    final lastGenerated = existingActivities
        .where((a) => a.recurringActivityId == recurring.id)
        .fold<DateTime?>(null, (latest, a) {
      if (latest == null || a.date.isAfter(latest)) {
        return a.date;
      }
      return latest;
    });

    // Start generating from the day AFTER the last generated instance, or from the start date
    if (lastGenerated != null) {
      nextDate = _calculateNextDate(recurring.frequency, lastGenerated);
    }

    while (nextDate.isBefore(upToDate) &&
        (recurring.endDate == null || nextDate.isBefore(recurring.endDate!))) {
      // Only add if an instance with the same date doesn't already exist
      // (Handles cases where generation might run multiple times)
      if (!existingActivities.any((a) =>
          a.recurringActivityId == recurring.id &&
          DateUtil.isSameDay(a.date, nextDate))) {
        newInstances.add(ActivityData(
          nature: recurring.type == ActivityType.salary ||
                  recurring.type == ActivityType.freelance ||
                  recurring.type == ActivityType.investment ||
                  recurring.type == ActivityType.incomeOther
              ? ActivityNature.income
              : ActivityNature.expense,
          title: recurring.title,
          amount: recurring.amount,
          date: nextDate,
          type: recurring.type,
          recurringActivityId: recurring.id,
        ));
      }
      nextDate = _calculateNextDate(recurring.frequency, nextDate);
    }

    return newInstances;
  }

  DateTime _calculateNextDate(RecurringFrequency frequency, DateTime currentDate) {
    switch (frequency) {
      case RecurringFrequency.daily:
        return currentDate.add(const Duration(days: 1));
      case RecurringFrequency.weekly:
        return currentDate.add(const Duration(days: 7));
      case RecurringFrequency.biWeekly:
        return currentDate.add(const Duration(days: 14));
      case RecurringFrequency.monthly:
        // Basic monthly - add 1 month (can have issues with end-of-month)
        // Consider using a more robust date package for complex scenarios
        return DateTime(currentDate.year, currentDate.month + 1, currentDate.day);
      case RecurringFrequency.yearly:
        return DateTime(currentDate.year + 1, currentDate.month, currentDate.day);
    }
  }
}
