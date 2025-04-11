// activity_state.dart

import 'package:equatable/equatable.dart';
import 'package:manage_salary/bloc/activity/util/activity_util.dart';

import '../../core/constants/enums.dart';
import '../../core/util/log_util.dart';
import '../../models/activity_data.dart';
// No need to import calculation helpers here anymore

class ActivityState extends Equatable {
  final List<ActivityData> allActivities; // Source of truth

  // Analytics Data - now populated externally via Bloc
  final double totalIncome;
  final double totalExpenses;
  final double netBalance;
  final Map<ActivityPaying, double> expensesByType;
  final Map<ActivityPaying, double> incomeByType;
  final double todayIncome;
  final double todayExpenses;
  final double thisWeekIncome;
  final double thisWeekExpenses;
  final double thisMonthIncome;
  final double thisMonthExpenses;

  const ActivityState({
    required this.allActivities,
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
    // Still useful for the starting point
    return const ActivityState(
      allActivities: [],
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

  // copyWith now ACCEPTS calculated values
  ActivityState copyWith({
    List<ActivityData>? allActivities,
    double? totalIncome,
    double? totalExpenses,
    double? netBalance,
    Map<ActivityPaying, double>? expensesByType,
    Map<ActivityPaying, double>? incomeByType,
    double? todayIncome,
    double? todayExpenses,
    double? thisWeekIncome,
    double? thisWeekExpenses,
    double? thisMonthIncome,
    double? thisMonthExpenses,
  }) {
    return ActivityState(
      allActivities: allActivities ?? this.allActivities,
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
  List<Object> get props => [
        // Keep props for state comparison
        allActivities,
        totalIncome, totalExpenses, netBalance,
        expensesByType, incomeByType,
        todayIncome, todayExpenses,
        thisWeekIncome, thisWeekExpenses,
        thisMonthIncome, thisMonthExpenses,
      ];

  // --- HydratedBloc Serialization ---
  Map<String, dynamic> toJson() {
    // Still only need to store the source list
    return {
      'allActivities':
          allActivities.map((activity) => activity.toJson()).toList(),
    };
  }

  // fromJson - Loads the list, then relies on external calculation
  // Note: This means the Bloc's fromJson needs to trigger calculations
  factory ActivityState.fromJson(Map<String, dynamic> json) {
    try {
      final List<dynamic> activityListJson =
          json['allActivities'] as List<dynamic>? ?? [];
      // Load the core list ONLY
      final List<ActivityData> activities = activityListJson
          .map((activityJson) =>
              ActivityData.fromJson(activityJson as Map<String, dynamic>))
          .toList();

      // Pruning and sorting can happen here or in the Bloc's fromJson
      final pruned =
          ActivityUtil().pruneActivities(activities); // Use external helper
      pruned.sort((a, b) => b.date.compareTo(a.date));

      // Return a state with JUST the loaded list.
      // The Bloc's fromJson override will need to calculate analytics.
      // Or, we calculate here and return a fully populated state:
      final calculatedState =
          calculateAnalytics(pruned); // Call central calc function

      return ActivityState(
        // Construct fully calculated state
        allActivities: pruned,
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
      LogUtil.e(
          "Error deserializing ActivityState: $e\n$stackTrace\nData: $json");
      return ActivityState.initial(); // Fallback
    }
  }
}

// Central calculation function (can live in bloc file or utils)
// Takes the list and returns ALL calculated analytics values
({
  double totalIncome,
  double totalExpenses,
  double netBalance,
  Map<ActivityPaying, double> expensesByType,
  Map<ActivityPaying, double> incomeByType,
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
