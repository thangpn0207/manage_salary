import 'package:equatable/equatable.dart';
import 'package:manage_salary/bloc/activity/util/activity_util.dart';

import '../../core/constants/enums.dart';
import '../../core/util/log_util.dart';
import '../../models/activity_data.dart';
import '../../models/budget.dart';
import '../../models/recurring_activity.dart';

class ActivityState extends Equatable {
  final List<ActivityData> allActivities;
  final List<Budget> budgets;
  final List<RecurringActivity> recurringActivities;

  // Analytics data
  final double totalIncome;
  final double totalExpenses;
  final double netBalance;
  final Map<ActivityType, double> expensesByType;
  final Map<ActivityType, double> incomeByType;
  final double todayIncome;
  final double todayExpenses;
  final double thisWeekIncome;
  final double thisWeekExpenses;
  final double thisMonthIncome;
  final double thisMonthExpenses;

  const ActivityState({
    required this.allActivities,
    required this.budgets,
    required this.recurringActivities,
    required this.totalIncome,
    required this.totalExpenses,
    required this.netBalance,
    required this.expensesByType,
    required this.incomeByType,
    required this.todayIncome,
    required this.todayExpenses,
    required this.thisWeekIncome,
    required this.thisWeekExpenses,
    required this.thisMonthIncome,
    required this.thisMonthExpenses,
  });

  factory ActivityState.initial() {
    return const ActivityState(
      allActivities: [],
      budgets: [],
      recurringActivities: [],
      totalIncome: 0.0,
      totalExpenses: 0.0,
      netBalance: 0.0,
      expensesByType: {},
      incomeByType: {},
      todayIncome: 0.0,
      todayExpenses: 0.0,
      thisWeekIncome: 0.0,
      thisWeekExpenses: 0.0,
      thisMonthIncome: 0.0,
      thisMonthExpenses: 0.0,
    );
  }

  ActivityState copyWith({
    List<ActivityData>? allActivities,
    List<Budget>? budgets,
    List<RecurringActivity>? recurringActivities,
    double? totalIncome,
    double? totalExpenses,
    double? netBalance,
    Map<ActivityType, double>? expensesByType,
    Map<ActivityType, double>? incomeByType,
    double? todayIncome,
    double? todayExpenses,
    double? thisWeekIncome,
    double? thisWeekExpenses,
    double? thisMonthIncome,
    double? thisMonthExpenses,
  }) {
    return ActivityState(
      allActivities: allActivities ?? this.allActivities,
      budgets: budgets ?? this.budgets,
      recurringActivities: recurringActivities ?? this.recurringActivities,
      totalIncome: totalIncome ?? this.totalIncome,
      totalExpenses: totalExpenses ?? this.totalExpenses,
      netBalance: netBalance ?? this.netBalance,
      expensesByType: expensesByType ?? this.expensesByType,
      incomeByType: incomeByType ?? this.incomeByType,
      todayIncome: todayIncome ?? this.todayIncome,
      todayExpenses: todayExpenses ?? this.todayExpenses,
      thisWeekIncome: thisWeekIncome ?? this.thisWeekIncome,
      thisWeekExpenses: thisWeekExpenses ?? this.thisWeekExpenses,
      thisMonthIncome: thisMonthIncome ?? this.thisMonthIncome,
      thisMonthExpenses: thisMonthExpenses ?? this.thisMonthExpenses,
    );
  }

  @override
  List<Object?> get props => [
        allActivities,
        budgets,
        recurringActivities,
        totalIncome,
        totalExpenses,
        netBalance,
        expensesByType,
        incomeByType,
        todayIncome,
        todayExpenses,
        thisWeekIncome,
        thisWeekExpenses,
        thisMonthIncome,
        thisMonthExpenses,
      ];

  // --- HydratedBloc Serialization ---
  Map<String, dynamic> toJson() {
    try {
      return {
        'allActivities':
            allActivities.map((activity) => activity.toJson()).toList(),
        'budgets': budgets.map((budget) => budget.toJson()).toList(),
        // Serialize budgets
        'recurringActivities':
            recurringActivities.map((rec) => rec.toJson()).toList(),
        // Serialize recurring activities
      };
    } catch (e, stackTrace) {
      LogUtil.e("Error serializing ActivityState: $e $stackTrace");
      return {'allActivities': []}; // Fallback to minimal JSON
    }
  }

  factory ActivityState.fromJson(Map<String, dynamic> json) {
    try {
      // Deserialize Activities
      final List<dynamic> activityListJson =
          json['allActivities'] as List<dynamic>? ?? [];
      final List<ActivityData> activities = activityListJson
          .map((activityJson) =>
              ActivityData.fromJson(activityJson as Map<String, dynamic>))
          .toList();

      // Deserialize Budgets
      final List<dynamic> budgetListJson =
          json['budgets'] as List<dynamic>? ?? [];
      final List<Budget> budgets = budgetListJson
          .map((bJson) => Budget.fromJson(bJson as Map<String, dynamic>))
          .toList();

      // Deserialize Recurring Activities
      final List<dynamic> recurringListJson =
          json['recurringActivities'] as List<dynamic>? ?? [];
      final List<RecurringActivity> recurringActivities = recurringListJson
          .map((rJson) =>
              RecurringActivity.fromJson(rJson as Map<String, dynamic>))
          .toList();

      // Pruning and sorting activities
      final prunedActivities = ActivityUtil().pruneActivities(activities);
      prunedActivities.sort((a, b) => b.date.compareTo(a.date));

      // Calculate analytics based on the loaded (and pruned) activities
      final analytics = calculateAnalytics(prunedActivities);

      return ActivityState(
        allActivities: prunedActivities,
        budgets: budgets,
        // Use deserialized list
        recurringActivities: recurringActivities,
        // Use deserialized list
        totalIncome: analytics.totalIncome,
        totalExpenses: analytics.totalExpenses,
        netBalance: analytics.netBalance,
        expensesByType: analytics.expensesByType,
        incomeByType: analytics.incomeByType,
        todayIncome: analytics.todayIncome,
        todayExpenses: analytics.todayExpenses,
        thisWeekIncome: analytics.thisWeekIncome,
        thisWeekExpenses: analytics.thisWeekExpenses,
        thisMonthIncome: analytics.thisMonthIncome,
        thisMonthExpenses: analytics.thisMonthExpenses,
      );
    } catch (e, stackTrace) {
      LogUtil.e(
          "Error deserializing ActivityState: $e\n$stackTrace\nData: $json");
      return ActivityState.initial(); // Fallback
    }
  }
}

// Central calculation function (Signature updated to use ActivityType)
({
  double totalIncome,
  double totalExpenses,
  double netBalance,
  Map<ActivityType, double> expensesByType,
  Map<ActivityType, double> incomeByType,
  double todayIncome,
  double todayExpenses,
  double thisWeekIncome,
  double thisWeekExpenses,
  double thisMonthIncome,
  double thisMonthExpenses,
}) calculateAnalytics(List<ActivityData> activities) {
  final totalIncome = ActivityUtil().calculateTotalIncome(activities);
  final totalExpenses = ActivityUtil().calculateTotalExpenses(activities);
  final netBalance = totalIncome - totalExpenses;
  // Ensure these utility methods now use ActivityType correctly internally
  final expensesByType = ActivityUtil().calculateExpensesByType(activities);
  final incomeByType = ActivityUtil().calculateIncomeByType(activities);

  final todayTotals = ActivityUtil()
      .calculatePeriodTotals(activities, ActivityUtil().getTodayRange());
  final weekTotals = ActivityUtil()
      .calculatePeriodTotals(activities, ActivityUtil().getThisWeekRange());
  final monthTotals = ActivityUtil()
      .calculatePeriodTotals(activities, ActivityUtil().getThisMonthRange());

  return (
    totalIncome: totalIncome,
    totalExpenses: totalExpenses,
    netBalance: netBalance,
    expensesByType: expensesByType,
    incomeByType: incomeByType,
    todayIncome: todayTotals.income,
    todayExpenses: todayTotals.expense,
    thisWeekIncome: weekTotals.income,
    thisWeekExpenses: weekTotals.expense,
    thisMonthIncome: monthTotals.income,
    thisMonthExpenses: monthTotals.expense,
  );
}
