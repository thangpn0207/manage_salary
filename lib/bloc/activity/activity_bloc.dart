// activity_bloc.dart
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:manage_salary/bloc/activity/util/activity_util.dart';
import 'package:manage_salary/core/extensions/date_time_extension.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/foundation.dart';

import '../../core/constants/enums.dart';
import '../../core/util/log_util.dart';
import '../../models/activity_data.dart';
import '../../models/budget.dart';
import '../../models/recurring_activity.dart';
import 'activity_event.dart';
import 'activity_state.dart';

class ActivityBloc extends HydratedBloc<ActivityEvent, ActivityState> {
  final Uuid _uuid = const Uuid();
  final ActivityUtil _activityUtil = ActivityUtil();
  
  // Cache for frequent calculations
  final Map<String, double> cachedCalculations = {};
  DateTime? _lastCacheReset;

  ActivityBloc() : super(ActivityState.initial()) {
    // Standard Activity handlers
    on<AddActivity>(_onAddActivity);
    on<RemoveActivity>(_onRemoveActivity);
    on<ClearAllActivities>(_onClearAllActivities);

    // Budget handlers
    on<AddBudget>(_onAddBudget);
    on<UpdateBudget>(_onUpdateBudget);
    on<RemoveBudget>(_onRemoveBudget);

    // Recurring Activity handlers
    on<AddRecurringActivity>(_onAddRecurringActivity);
    on<UpdateRecurringActivity>(_onUpdateRecurringActivity);
    on<RemoveRecurringActivity>(_onRemoveRecurringActivity);
    on<GenerateRecurringInstances>(_onGenerateRecurringInstances);

    // Initialize with recurring activities
    add(GenerateRecurringInstances(untilDate: DateTime.now()));
  }

  // Cache management
  void _resetCacheIfNeeded() {
    final now = DateTime.now();
    if (_lastCacheReset == null || 
        now.difference(_lastCacheReset!).inHours >= 1) {
      cachedCalculations.clear();
      _lastCacheReset = now;
    }
  }

  String _getCacheKey(String operation, DateTime? start, DateTime? end) {
    return '$operation-${start?.toIso8601String() ?? "all"}-${end?.toIso8601String() ?? "all"}';
  }

  // Enhanced analytics calculation with caching
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
  }) _calculateAnalyticsWithCache(List<ActivityData> activities) {
    _resetCacheIfNeeded();

    // Get date ranges
    final todayRange = _activityUtil.getTodayRange();
    final weekRange = _activityUtil.getThisWeekRange();
    final monthRange = _activityUtil.getThisMonthRange();

    // Calculate with caching
    final String totalKey = _getCacheKey('total', null, null);
    if (!cachedCalculations.containsKey(totalKey)) {
      cachedCalculations['${totalKey}_income'] = _activityUtil.calculateTotalIncome(activities);
      cachedCalculations['${totalKey}_expenses'] = _activityUtil.calculateTotalExpenses(activities);
    }

    final totalIncome = cachedCalculations['${totalKey}_income']!;
    final totalExpenses = cachedCalculations['${totalKey}_expenses']!;
    final netBalance = totalIncome - totalExpenses;

    // Calculate period totals with caching
    final todayTotals = _calculatePeriodTotalsWithCache(activities, todayRange, 'today');
    final weekTotals = _calculatePeriodTotalsWithCache(activities, weekRange, 'week');
    final monthTotals = _calculatePeriodTotalsWithCache(activities, monthRange, 'month');

    // Calculate type breakdowns
    final expensesByType = _activityUtil.calculateExpensesByType(activities);
    final incomeByType = _activityUtil.calculateIncomeByType(activities);

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

  ({double income, double expense}) _calculatePeriodTotalsWithCache(
    List<ActivityData> activities,
    ({DateTime start, DateTime end}) range,
    String period,
  ) {
    final cacheKey = _getCacheKey(period, range.start, range.end);
    if (!cachedCalculations.containsKey('${cacheKey}_income')) {
      final totals = _activityUtil.calculatePeriodTotals(activities, range);
      cachedCalculations['${cacheKey}_income'] = totals.income;
      cachedCalculations['${cacheKey}_expense'] = totals.expense;
    }
    return (
      income: cachedCalculations['${cacheKey}_income']!,
      expense: cachedCalculations['${cacheKey}_expense']!,
    );
  }

  // Budget Analytics Methods
  Map<BudgetCategory, ({
    double allocated,
    double spent,
    double remaining,
    double progress,
    bool isOverBudget,
  })> getBudgetAnalytics() {
    Map<BudgetCategory, ({
      double allocated,
      double spent,
      double remaining,
      double progress,
      bool isOverBudget,
    })> analytics = {};

    for (final category in BudgetCategory.values) {
      final budgetsForCategory = state.budgets
          .where((b) => b.category == category)
          .toList();

      if (budgetsForCategory.isEmpty) continue;

      double totalAllocated = 0.0;
      double totalSpent = 0.0;

      for (final budget in budgetsForCategory) {
        totalAllocated += budget.amount;
        totalSpent += budget.currentSpending;
      }

      final remaining = totalAllocated - totalSpent;
      final progress = totalAllocated > 0 ? (totalSpent / totalAllocated).clamp(0.0, 1.0) : 0.0;

      analytics[category] = (
        allocated: totalAllocated,
        spent: totalSpent,
        remaining: remaining,
        progress: progress,
        isOverBudget: totalSpent > totalAllocated,
      );
    }

    return analytics;
  }

  List<({
    DateTime date,
    Map<BudgetCategory, double> spending,
  })> getDailySpendingTrend({
    required DateTime startDate,
    required DateTime endDate,
  }) {
    List<({DateTime date, Map<BudgetCategory, double> spending})> trend = [];
    
    var currentDate = startDate;
    while (!currentDate.isAfter(endDate)) {
      Map<BudgetCategory, double> daySpending = {};
      
      for (final category in BudgetCategory.values) {
        final activityType = _convertBudgetCategoryToActivityType(category);
        final spending = state.allActivities
            .where((a) => 
                a.nature == ActivityNature.expense &&
                a.type == activityType &&
                a.date.year == currentDate.year &&
                a.date.month == currentDate.month &&
                a.date.day == currentDate.day)
            .fold(0.0, (sum, activity) => sum + activity.amount);
            
        if (spending > 0) {
          daySpending[category] = spending;
        }
      }
      
      if (daySpending.isNotEmpty) {
        trend.add((
          date: currentDate,
          spending: daySpending,
        ));
      }
      
      currentDate = currentDate.add(const Duration(days: 1));
    }
    
    return trend;
  }

  ({
    int totalBudgets,
    int activeBudgets,
    int nearingLimitBudgets,
    int overBudgetBudgets,
    double totalAllocated,
    double totalSpent,
    double totalRemaining,
    double overallProgress,
  }) getBudgetSummary() {
    int totalBudgets = state.budgets.length;
    int activeBudgets = 0;
    int nearingLimitBudgets = 0;
    int overBudgetBudgets = 0;
    double totalAllocated = 0.0;
    double totalSpent = 0.0;

    for (final budget in state.budgets) {
      totalAllocated += budget.amount;
      totalSpent += budget.currentSpending;

      if (budget.currentSpending > 0) {
        activeBudgets++;
      }

      final progress = budget.amount > 0 ? (budget.currentSpending / budget.amount) : 0.0;
      if (progress > 1.0) {
        overBudgetBudgets++;
      } else if (progress > 0.8) {
        nearingLimitBudgets++;
      }
    }

    final totalRemaining = totalAllocated - totalSpent;
    final overallProgress = totalAllocated > 0 ? (totalSpent / totalAllocated).clamp(0.0, 1.0) : 0.0;

    return (
      totalBudgets: totalBudgets,
      activeBudgets: activeBudgets,
      nearingLimitBudgets: nearingLimitBudgets,
      overBudgetBudgets: overBudgetBudgets,
      totalAllocated: totalAllocated,
      totalSpent: totalSpent,
      totalRemaining: totalRemaining,
      overallProgress: overallProgress,
    );
  }

  Map<BudgetCategory, List<({
    BudgetPeriod period,
    double amount,
    double spent,
    double remaining,
    DateTime? lastUpdated,
  })>> getBudgetsByCategory() {
    Map<BudgetCategory, List<({
      BudgetPeriod period,
      double amount,
      double spent,
      double remaining,
      DateTime? lastUpdated,
    })>> result = {};

    for (final budget in state.budgets) {
      result.putIfAbsent(budget.category, () => []);
      result[budget.category]!.add((
        period: budget.period,
        amount: budget.amount,
        spent: budget.currentSpending,
        remaining: budget.remainingAmount,
        lastUpdated: budget.lastUpdated,
      ));
    }

    return result;
  }

  // Enhanced Activity Handlers with Error Handling
  void _onAddActivity(AddActivity event, Emitter<ActivityState> emit) {
    try {
      final activityWithId = event.newActivity.copyWith(
        id: _uuid.v4(),
      );
      final updatedList = List<ActivityData>.from(state.allActivities)
        ..add(activityWithId);
      final prunedList = _activityUtil.pruneActivities(updatedList);
      prunedList.sort((a, b) => b.date.compareTo(a.date));

      final analytics = _calculateAnalyticsWithCache(prunedList);

      emit(state.copyWith(
        allActivities: prunedList,
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
      ));
      
      // Update budgets after adding activity
      _checkAndResetBudgets(emit);
    } catch (e, stackTrace) {
      LogUtil.e('Error adding activity: $e\n$stackTrace');
      // Consider emitting an error state or handling the error appropriately
    }
  }

  void _onRemoveActivity(RemoveActivity event, Emitter<ActivityState> emit) {
    try {
      final updatedList = List<ActivityData>.from(state.allActivities)
        ..removeWhere((activity) => activity.id == event.activityId);
      updatedList.sort((a, b) => b.date.compareTo(a.date));

      final analytics = _calculateAnalyticsWithCache(updatedList);

      emit(state.copyWith(
        allActivities: updatedList,
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
      ));
      
      // Update budgets after removing activity
      _checkAndResetBudgets(emit);
    } catch (e, stackTrace) {
      LogUtil.e('Error removing activity: $e\n$stackTrace');
    }
  }

  void _onClearAllActivities(ClearAllActivities event, Emitter<ActivityState> emit) {
    try {
      emit(ActivityState.initial());
      cachedCalculations.clear();
      _lastCacheReset = DateTime.now();
    } catch (e, stackTrace) {
      LogUtil.e('Error clearing activities: $e\n$stackTrace');
    }
  }

  // Enhanced Budget Handlers
  void _onAddBudget(AddBudget event, Emitter<ActivityState> emit) {
    try {
      final budgetWithId = event.budget.copyWith(id: _uuid.v4());
      final updatedBudgets = List<Budget>.from(state.budgets)..add(budgetWithId);
      emit(state.copyWith(budgets: updatedBudgets));
      _checkAndResetBudgets(emit);
    } catch (e, stackTrace) {
      LogUtil.e('Error adding budget: $e\n$stackTrace');
    }
  }

  void _onUpdateBudget(UpdateBudget event, Emitter<ActivityState> emit) {
    try {
      final updatedBudgets = state.budgets.map((budget) {
        return budget.id == event.updatedBudget.id ? event.updatedBudget : budget;
      }).toList();
      emit(state.copyWith(budgets: updatedBudgets));
      _checkAndResetBudgets(emit);
    } catch (e, stackTrace) {
      LogUtil.e('Error updating budget: $e\n$stackTrace');
    }
  }

  void _onRemoveBudget(RemoveBudget event, Emitter<ActivityState> emit) {
    try {
      final updatedBudgets = List<Budget>.from(state.budgets)
        ..removeWhere((budget) => budget.id == event.budgetId);
      emit(state.copyWith(budgets: updatedBudgets));
    } catch (e, stackTrace) {
      LogUtil.e('Error removing budget: $e\n$stackTrace');
    }
  }

  // Budget tracking helper
  void _checkAndResetBudgets(Emitter<ActivityState> emit) {
    try {
      final now = DateTime.now();
      List<Budget> updatedBudgets = state.budgets.map((budget) {
        if (budget.lastUpdated == null) {
          return budget.updateSpending(0);
        }

        bool shouldReset = false;
        switch (budget.period) {
          case BudgetPeriod.weekly:
            final lastWeek = budget.lastUpdated!.weekOfYear;
            final currentWeek = now.weekOfYear;
            shouldReset = lastWeek != currentWeek;
            break;
          case BudgetPeriod.monthly:
            shouldReset = budget.lastUpdated!.month != now.month || 
                       budget.lastUpdated!.year != now.year;
            break;
          case BudgetPeriod.yearly:
            shouldReset = budget.lastUpdated!.year != now.year;
            break;
        }

        return shouldReset ? budget.resetSpending() : budget;
      }).toList();

      // Update spending for each budget based on activities
      for (var budget in updatedBudgets) {
        final activityType = _convertBudgetCategoryToActivityType(budget.category);
        final periodRange = _getPeriodDateRange(budget.period);
        
        final spending = state.allActivities
            .where((a) => 
                a.nature == ActivityNature.expense &&
                a.type == activityType &&
                !a.date.isBefore(periodRange.start) &&
                a.date.isBefore(periodRange.end))
            .fold(0.0, (sum, activity) => sum + activity.amount);
        
        final index = updatedBudgets.indexOf(budget);
        updatedBudgets[index] = budget.updateSpending(spending);
      }

      if (!listEquals(state.budgets, updatedBudgets)) {
        emit(state.copyWith(budgets: updatedBudgets));
      }
    } catch (e, stackTrace) {
      LogUtil.e('Error checking/resetting budgets: $e\n$stackTrace');
    }
  }

  // Helper methods for budget tracking
  ActivityType _convertBudgetCategoryToActivityType(BudgetCategory category) {
    switch (category) {
      case BudgetCategory.shopping:
        return ActivityType.shopping;
      case BudgetCategory.foodAndDrinks:
        return ActivityType.foodAndDrinks;
      case BudgetCategory.rent:
        return ActivityType.rent;
      case BudgetCategory.utilities:
        return ActivityType.utilities;
      case BudgetCategory.groceries:
        return ActivityType.groceries;
      case BudgetCategory.entertainment:
        return ActivityType.entertainment;
      case BudgetCategory.education:
        return ActivityType.education;
      case BudgetCategory.healthcare:
        return ActivityType.healthcare;
      case BudgetCategory.travel:
        return ActivityType.travel;
      case BudgetCategory.expenseOther:
        return ActivityType.expenseOther;
    }
  }

  ({DateTime start, DateTime end}) _getPeriodDateRange(BudgetPeriod period) {
    final now = DateTime.now();
    switch (period) {
      case BudgetPeriod.weekly:
        final start = now.subtract(Duration(days: now.weekday - 1));
        final end = start.add(const Duration(days: 7));
        return (
          start: DateTime(start.year, start.month, start.day),
          end: DateTime(end.year, end.month, end.day),
        );
      
      case BudgetPeriod.monthly:
        return (
          start: DateTime(now.year, now.month, 1),
          end: DateTime(now.year, now.month + 1, 1),
        );
      
      case BudgetPeriod.yearly:
        return (
          start: DateTime(now.year, 1, 1),
          end: DateTime(now.year + 1, 1, 1),
        );
    }
  }

  // Recurring Activity Handlers
  void _onAddRecurringActivity(AddRecurringActivity event, Emitter<ActivityState> emit) {
    try {
      final recurringWithId = event.recurringActivity.copyWith(id: _uuid.v4());
      final updatedRecurring = List<RecurringActivity>.from(state.recurringActivities)
        ..add(recurringWithId);
      emit(state.copyWith(recurringActivities: updatedRecurring));
      add(GenerateRecurringInstances(untilDate: DateTime.now()));
    } catch (e, stackTrace) {
      LogUtil.e('Error adding recurring activity: $e\n$stackTrace');
    }
  }

  void _onUpdateRecurringActivity(UpdateRecurringActivity event, Emitter<ActivityState> emit) {
    try {
      final updatedRecurring = state.recurringActivities.map((rec) {
        return rec.id == event.updatedRecurringActivity.id
            ? event.updatedRecurringActivity
            : rec;
      }).toList();
      emit(state.copyWith(recurringActivities: updatedRecurring));
      add(GenerateRecurringInstances(untilDate: DateTime.now()));
    } catch (e, stackTrace) {
      LogUtil.e('Error updating recurring activity: $e\n$stackTrace');
    }
  }

  void _onRemoveRecurringActivity(RemoveRecurringActivity event, Emitter<ActivityState> emit) {
    try {
      final updatedRecurring = List<RecurringActivity>.from(state.recurringActivities)
        ..removeWhere((rec) => rec.id == event.recurringActivityId);
      
      // Also remove generated activities linked to this recurring one
      final updatedActivities = List<ActivityData>.from(state.allActivities)
        ..removeWhere((act) => act.recurringActivityId == event.recurringActivityId);
      updatedActivities.sort((a, b) => b.date.compareTo(a.date));

      final analytics = _calculateAnalyticsWithCache(updatedActivities);
      emit(state.copyWith(
        recurringActivities: updatedRecurring,
        allActivities: updatedActivities,
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
      ));
    } catch (e, stackTrace) {
      LogUtil.e('Error removing recurring activity: $e\n$stackTrace');
    }
  }

  void _onGenerateRecurringInstances(GenerateRecurringInstances event, Emitter<ActivityState> emit) {
    try {
      List<ActivityData> newlyGenerated = [];
      final now = event.untilDate;

      for (final recurring in state.recurringActivities) {
        DateTime nextDueDate = recurring.startDate;

        // Skip if start date is in the future
        if (nextDueDate.isAfter(now)) continue;

        while (nextDueDate.isBefore(now) || nextDueDate.isAtSameMomentAs(now)) {
          // Stop if end date is reached
          if (recurring.endDate != null && nextDueDate.isAfter(recurring.endDate!)) {
            break;
          }

          // Check for existing instance
          bool alreadyExists = state.allActivities.any((activity) =>
              activity.recurringActivityId == recurring.id &&
              activity.date.year == nextDueDate.year &&
              activity.date.month == nextDueDate.month &&
              activity.date.day == nextDueDate.day);

          if (!alreadyExists) {
            newlyGenerated.add(ActivityData(
              id: _uuid.v4(),
              nature: recurring.type.name.toLowerCase().contains('income') ||
                      recurring.type == ActivityType.salary ||
                      recurring.type == ActivityType.freelance ||
                      recurring.type == ActivityType.investment
                  ? ActivityNature.income
                  : ActivityNature.expense,
              title: recurring.title,
              amount: recurring.amount,
              date: nextDueDate,
              type: recurring.type,
              recurringActivityId: recurring.id,
            ));
          }

          // Calculate next due date
          switch (recurring.frequency) {
            case RecurringFrequency.daily:
              nextDueDate = nextDueDate.add(const Duration(days: 1));
              break;
            case RecurringFrequency.weekly:
              nextDueDate = nextDueDate.add(const Duration(days: 7));
              break;
            case RecurringFrequency.biWeekly:
              nextDueDate = nextDueDate.add(const Duration(days: 14));
              break;
            case RecurringFrequency.monthly:
              var newMonth = nextDueDate.month + 1;
              var newYear = nextDueDate.year;
              if (newMonth > 12) {
                newMonth = 1;
                newYear++;
              }
              var daysInNewMonth = DateTime(newYear, newMonth + 1, 0).day;
              var newDay = nextDueDate.day > daysInNewMonth
                  ? daysInNewMonth
                  : nextDueDate.day;
              nextDueDate = DateTime(newYear, newMonth, newDay);
              break;
            case RecurringFrequency.yearly:
              nextDueDate = DateTime(nextDueDate.year + 1, nextDueDate.month, nextDueDate.day);
              break;
          }

          // Safety breaks
          if (nextDueDate.year > now.year + 10) break;
          if (newlyGenerated.length > 1000) break;
        }
      }

      if (newlyGenerated.isNotEmpty) {
        final updatedList = List<ActivityData>.from(state.allActivities)
          ..addAll(newlyGenerated);
        updatedList.sort((a, b) => b.date.compareTo(a.date));

        final analytics = _calculateAnalyticsWithCache(updatedList);
        emit(state.copyWith(
          allActivities: updatedList,
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
        ));
        
        // Update budgets after generating recurring activities
        _checkAndResetBudgets(emit);
      }
    } catch (e, stackTrace) {
      LogUtil.e('Error generating recurring instances: $e\n$stackTrace');
    }
  }

  // HydratedBloc overrides with enhanced error handling
  @override
  ActivityState? fromJson(Map<String, dynamic> json) {
    try {
      final state = ActivityState.fromJson(json);
      add(GenerateRecurringInstances(untilDate: DateTime.now()));
      return state;
    } catch (e, stackTrace) {
      LogUtil.e('Error hydrating ActivityBloc state: $e\n$stackTrace');
      return ActivityState.initial();
    }
  }

  @override
  Map<String, dynamic>? toJson(ActivityState state) {
    try {
      return state.toJson();
    } catch (e, stackTrace) {
      LogUtil.e('Error serializing ActivityBloc state: $e\n$stackTrace');
      return null;
    }
  }
}
