import 'package:equatable/equatable.dart';
import 'package:manage_salary/bloc/activity/util/activity_util.dart';

import '../../core/constants/enums.dart';
import '../../core/util/log_util.dart';
import '../../models/activity_data.dart';
import '../../models/budget.dart';
import '../../models/recurring_activity.dart';

/// Optimized ActivityState with improved structure and performance
class ActivityState extends Equatable {
  // Core data
  final List<ActivityData> allActivities;
  final List<Budget> budgets;
  final List<RecurringActivity> recurringActivities;

  // Cached analytics data
  final double totalIncome;
  final double totalExpenses;
  final double netBalance;
  final Map<ActivityType, double> expensesByType;
  final Map<ActivityType, double> incomeByType;

  // Period-specific analytics
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

  /// Creates an initial empty state
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

  /// Resets the state to initial values
  ActivityState reset() => ActivityState.initial();

  /// Creates a copy of this state with updated values
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

  /// Converts the state to JSON for persistence
  Map<String, dynamic> toJson() {
    return {
      'allActivities': allActivities.map((a) => a.toJson()).toList(),
      'budgets': budgets.map((b) => b.toJson()).toList(),
      'recurringActivities':
          recurringActivities.map((r) => r.toJson()).toList(),
      'totalIncome': totalIncome,
      'totalExpenses': totalExpenses,
      'netBalance': netBalance,
      'expensesByType': _serializeTypeMap(expensesByType),
      'incomeByType': _serializeTypeMap(incomeByType),
      'todayIncome': todayIncome,
      'todayExpenses': todayExpenses,
      'thisWeekIncome': thisWeekIncome,
      'thisWeekExpenses': thisWeekExpenses,
      'thisMonthIncome': thisMonthIncome,
      'thisMonthExpenses': thisMonthExpenses,
    };
  }

  /// Creates a state from JSON data
  factory ActivityState.fromJson(Map<String, dynamic> json) {
    try {
      // Handle reset state
      if (json['isReset'] == true) {
        return ActivityState.initial();
      }

      // Parse core data
      final activities = _parseActivities(json['allActivities']);
      final budgets = _parseBudgets(json['budgets']);
      final recurringActivities =
          _parseRecurringActivities(json['recurringActivities']);

      // If no activities, return initial state with parsed budgets and recurring activities
      if (activities.isEmpty) {
        return ActivityState.initial().copyWith(
          budgets: budgets,
          recurringActivities: recurringActivities,
        );
      }

      // Process activities and calculate analytics
      final processedActivities = _processActivities(activities);
      final analytics = _calculateAnalytics(processedActivities);

      return ActivityState(
        allActivities: processedActivities,
        budgets: budgets,
        recurringActivities: recurringActivities,
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
      return ActivityState.initial();
    }
  }

  // ==================== PRIVATE HELPER METHODS ====================

  /// Serializes ActivityType map to JSON-compatible format
  static Map<String, double> _serializeTypeMap(
      Map<ActivityType, double> typeMap) {
    return typeMap.map((key, value) => MapEntry(key.name, value));
  }

  /// Deserializes JSON map to ActivityType map
  static Map<ActivityType, double> _deserializeTypeMap(dynamic jsonMap) {
    if (jsonMap == null) return {};

    final result = <ActivityType, double>{};
    final map = jsonMap as Map<String, dynamic>;

    for (final entry in map.entries) {
      try {
        final activityType = ActivityType.values.firstWhere(
          (type) => type.name == entry.key,
        );
        result[activityType] = (entry.value as num).toDouble();
      } catch (e) {
        // Skip invalid activity types
        LogUtil.w('Unknown activity type: ${entry.key}');
      }
    }

    return result;
  }

  /// Parses activities from JSON
  static List<ActivityData> _parseActivities(dynamic json) {
    if (json == null) return [];

    try {
      final list = json as List<dynamic>;
      return list
          .map((item) => ActivityData.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      LogUtil.e('Error parsing activities: $e');
      return [];
    }
  }

  /// Parses budgets from JSON
  static List<Budget> _parseBudgets(dynamic json) {
    if (json == null) return [];

    try {
      final list = json as List<dynamic>;
      return list
          .map((item) => Budget.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      LogUtil.e('Error parsing budgets: $e');
      return [];
    }
  }

  /// Parses recurring activities from JSON
  static List<RecurringActivity> _parseRecurringActivities(dynamic json) {
    if (json == null) return [];

    try {
      final list = json as List<dynamic>;
      return list
          .map((item) =>
              RecurringActivity.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      LogUtil.e('Error parsing recurring activities: $e');
      return [];
    }
  }

  /// Processes activities (prune and sort)
  static List<ActivityData> _processActivities(List<ActivityData> activities) {
    final prunedActivities = ActivityUtil().pruneActivities(activities);
    prunedActivities.sort((a, b) => b.date.compareTo(a.date));
    return prunedActivities;
  }

  /// Calculates analytics for activities
  static _AnalyticsResult _calculateAnalytics(List<ActivityData> activities) {
    final util = ActivityUtil();

    // Calculate totals
    final totalIncome = util.calculateTotalIncome(activities);
    final totalExpenses = util.calculateTotalExpenses(activities);
    final netBalance = totalIncome - totalExpenses;

    // Calculate type breakdowns
    final expensesByType = util.calculateExpensesByType(activities);
    final incomeByType = util.calculateIncomeByType(activities);

    // Calculate period totals
    final todayTotals =
        util.calculatePeriodTotals(activities, util.getTodayRange());
    final weekTotals =
        util.calculatePeriodTotals(activities, util.getThisWeekRange());
    final monthTotals =
        util.calculatePeriodTotals(activities, util.getThisMonthRange());

    return _AnalyticsResult(
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

  // ==================== COMPUTED PROPERTIES ====================

  /// Returns true if there are any activities
  bool get hasActivities => allActivities.isNotEmpty;

  /// Returns true if there are any budgets
  bool get hasBudgets => budgets.isNotEmpty;

  /// Returns true if there are any recurring activities
  bool get hasRecurringActivities => recurringActivities.isNotEmpty;

  /// Returns activities for today
  List<ActivityData> get todayActivities {
    final today = DateTime.now();
    return allActivities
        .where((activity) =>
            activity.date.year == today.year &&
            activity.date.month == today.month &&
            activity.date.day == today.day)
        .toList();
  }

  /// Returns this week's activities
  List<ActivityData> get thisWeekActivities {
    final util = ActivityUtil();
    final weekRange = util.getThisWeekRange();
    return allActivities
        .where((activity) =>
            !activity.date.isBefore(weekRange.start) &&
            activity.date.isBefore(weekRange.end))
        .toList();
  }

  /// Returns this month's activities
  List<ActivityData> get thisMonthActivities {
    final util = ActivityUtil();
    final monthRange = util.getThisMonthRange();
    return allActivities
        .where((activity) =>
            !activity.date.isBefore(monthRange.start) &&
            activity.date.isBefore(monthRange.end))
        .toList();
  }

  /// Returns recent activities (last 30 days)
  List<ActivityData> get recentActivities {
    final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
    return allActivities
        .where((activity) => activity.date.isAfter(thirtyDaysAgo))
        .toList();
  }

  /// Returns active budgets (with spending > 0)
  List<Budget> get activeBudgets {
    return budgets.where((budget) => budget.currentSpending > 0).toList();
  }

  /// Returns over-budget budgets
  List<Budget> get overBudgetBudgets {
    return budgets
        .where((budget) => budget.currentSpending > budget.amount)
        .toList();
  }

  /// Returns budgets nearing their limit (>80% spent)
  List<Budget> get nearingLimitBudgets {
    return budgets.where((budget) {
      if (budget.amount <= 0) return false;
      final progress = budget.currentSpending / budget.amount;
      return progress > 0.8 && progress <= 1.0;
    }).toList();
  }
}

/// Internal class to hold analytics calculation results
class _AnalyticsResult {
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

  const _AnalyticsResult({
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
}
