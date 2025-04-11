
import 'package:equatable/equatable.dart';
import 'package:manage_salary/bloc/activity/util/activity_util.dart'; // Will be used

import '../../core/constants/enums.dart';
import '../../models/activity_data.dart';
import '../../models/budget.dart'; // Import new model
import '../../models/recurring_activity.dart'; // Import new model

class ActivityState extends Equatable {
  final List<ActivityData> allActivities;
  final List<Budget> budgets; // Add list for budgets
  final List<RecurringActivity>
      recurringActivities; // Add list for recurring activities

  // Existing analytics data
  final double totalIncome;
  final double totalExpenses;
  final double netBalance;
  final Map<ActivityType, double> expensesByType; // Update enum type
  final Map<ActivityType, double> incomeByType; // Update enum type
  final double todayIncome;
  final double todayExpenses;
  final double thisWeekIncome;
  final double thisWeekExpenses;
  final double thisMonthIncome;
  final double thisMonthExpenses;

  // TODO: Add derived budget status data (e.g., spending vs budget per category)

  const ActivityState({
    required this.allActivities,
    required this.budgets, // Add to constructor
    required this.recurringActivities, // Add to constructor
    // Required calculated fields
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
      budgets: [], // Initialize as empty list
      recurringActivities: [], // Initialize as empty list
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
    List<Budget>? budgets, // Add budgets to copyWith
    List<RecurringActivity>?
        recurringActivities, // Add recurring activities to copyWith
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
    // TODO: Add budget status fields to copyWith if needed
  }) {
    return ActivityState(
      allActivities: allActivities ?? this.allActivities,
      budgets: budgets ?? this.budgets, // Handle budgets
      recurringActivities:
          recurringActivities ?? this.recurringActivities, // Handle recurring
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
        budgets, // Add to props
        recurringActivities, // Add to props
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
        // TODO: Add budget status props
      ];

  // --- HydratedBloc Serialization ---
  Map<String, dynamic> toJson() {
    return {
      'allActivities':
          allActivities.map((activity) => activity.toJson()).toList(),
      // TODO: Add serialization for budgets and recurringActivities
      // 'budgets': budgets.map((budget) => budget.toJson()).toList(),
      // 'recurringActivities': recurringActivities.map((rec) => rec.toJson()).toList(),
    };
  }

  factory ActivityState.fromJson(Map<String, dynamic> json) {
    try {
      final List<dynamic> activityListJson =
          json['allActivities'] as List<dynamic>? ?? [];
      final List<ActivityData> activities = activityListJson
          .map((activityJson) =>
              ActivityData.fromJson(activityJson as Map<String, dynamic>))
          .toList();

      // TODO: Add deserialization for budgets and recurringActivities
      // final List<dynamic> budgetListJson = json['budgets'] as List<dynamic>? ?? [];
      // final List<Budget> budgets = budgetListJson.map((bJson) => Budget.fromJson(bJson)).toList();

      // final List<dynamic> recurringListJson = json['recurringActivities'] as List<dynamic>? ?? [];
      // final List<RecurringActivity> recurringActivities = recurringListJson.map((rJson) => RecurringActivity.fromJson(rJson)).toList();


      // Pruning and sorting can happen here or in the Bloc's fromJson
      final pruned = ActivityUtil().pruneActivities(activities);
      pruned.sort((a, b) => b.date.compareTo(a.date));

      final calculatedState = calculateAnalytics(pruned); // Use updated types

      return ActivityState(
        allActivities: pruned,
        budgets: [], // Use deserialized list later
        recurringActivities: [], // Use deserialized list later
        totalIncome: calculatedState.totalIncome,
        totalExpenses: calculatedState.totalExpenses,
        netBalance: calculatedState.netBalance,
        expensesByType: calculatedState.expensesByType,
        incomeByType: calculatedState.incomeByType,
        todayIncome: calculatedState.todayIncome,
        todayExpenses: calculatedState.todayExpenses,
        thisWeekIncome: calculatedState.thisWeekIncome,
        thisWeekExpenses: calculatedState.thisWeekExpenses,
        thisMonthIncome: calculatedState.thisMonthIncome,
        thisMonthExpenses: calculatedState.thisMonthExpenses,
      );
    } catch (e, stackTrace) {
      print("Error deserializing ActivityState: $e
$stackTrace
Data: $json");
      return ActivityState.initial(); // Fallback
    }
  }
}

// Central calculation function (update parameter types)
({
  double totalIncome,
  double totalExpenses,
  double netBalance,
  Map<ActivityType, double> expensesByType, // Update enum type
  Map<ActivityType, double> incomeByType, // Update enum type
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
  final expensesByType = ActivityUtil().calculateExpensesByType(activities); // Ensure this uses ActivityType
  final incomeByType = ActivityUtil().calculateIncomeByType(activities); // Ensure this uses ActivityType

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

