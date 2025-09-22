// activity_bloc.dart
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:manage_salary/bloc/activity/util/activity_util.dart';
import 'package:manage_salary/core/extensions/date_time_extension.dart';
import 'package:uuid/uuid.dart';

import '../../core/constants/enums.dart';
import '../../core/util/log_util.dart';
import '../../models/activity_data.dart';
import '../../models/budget.dart';
import '../../models/recurring_activity.dart';
import 'activity_event.dart';
import 'activity_state.dart';

/// Optimized ActivityBloc with improved performance and cleaner architecture
class ActivityBloc extends HydratedBloc<ActivityEvent, ActivityState> {
  static const _cacheExpirationHours = 1;
  static const _maxRecurringInstances = 2000;
  static const _maxYearsAhead = 10;

  final Uuid _uuid = const Uuid();
  final ActivityUtil _activityUtil = ActivityUtil();

  // Optimized caching system
  final _analyticsCache = <String, dynamic>{};
  final _budgetSpendingCache = <String, double>{};
  final _recurringGenerationCache = <String, DateTime>{};
  DateTime? _lastCacheReset;

  ActivityBloc() : super(ActivityState.initial()) {
    _registerEventHandlers();
    _initializeRecurringActivities();
  }

  /// Register all event handlers in a centralized manner
  void _registerEventHandlers() {
    // Activity events
    on<AddActivity>(_handleAddActivity);
    on<RemoveActivity>(_handleRemoveActivity);
    on<ClearAllActivities>(_handleClearAllActivities);

    // Budget events
    on<AddBudget>(_handleAddBudget);
    on<UpdateBudget>(_handleUpdateBudget);
    on<RemoveBudget>(_handleRemoveBudget);

    // Recurring activity events
    on<AddRecurringActivity>(_handleAddRecurringActivity);
    on<UpdateRecurringActivity>(_handleUpdateRecurringActivity);
    on<RemoveRecurringActivity>(_handleRemoveRecurringActivity);
    on<GenerateRecurringInstances>(_handleGenerateRecurringInstances);
  }

  void _initializeRecurringActivities() {
    add(GenerateRecurringInstances(untilDate: DateTime.now()));
  }

  // ==================== CACHE MANAGEMENT ====================

  void _invalidateCache() {
    _analyticsCache.clear();
    _budgetSpendingCache.clear();
    _lastCacheReset = DateTime.now();
  }

  void _invalidateCacheIfExpired() {
    final now = DateTime.now();
    if (_lastCacheReset == null ||
        now.difference(_lastCacheReset!).inHours >= _cacheExpirationHours) {
      _invalidateCache();
    }
  }

  String _generateCacheKey(String operation, [DateTime? start, DateTime? end]) {
    return '$operation-${start?.millisecondsSinceEpoch ?? "all"}-${end?.millisecondsSinceEpoch ?? "all"}';
  }

  // ==================== ACTIVITY HANDLERS ====================

  Future<void> _handleAddActivity(
      AddActivity event, Emitter<ActivityState> emit) async {
    try {
      final activityWithId = event.newActivity.copyWith(id: _uuid.v4());
      final updatedActivities = _addAndSortActivities([activityWithId]);

      await _emitUpdatedState(emit, updatedActivities);
    } catch (e, stackTrace) {
      _logError('Error adding activity', e, stackTrace);
    }
  }

  Future<void> _handleRemoveActivity(
      RemoveActivity event, Emitter<ActivityState> emit) async {
    try {
      final updatedActivities = state.allActivities
          .where((activity) => activity.id != event.activityId)
          .toList();

      await _emitUpdatedState(emit, updatedActivities);
    } catch (e, stackTrace) {
      _logError('Error removing activity', e, stackTrace);
    }
  }

  Future<void> _handleClearAllActivities(
      ClearAllActivities event, Emitter<ActivityState> emit) async {
    try {
      _invalidateCache();
      _recurringGenerationCache.clear();
      emit(ActivityState.initial());
    } catch (e, stackTrace) {
      _logError('Error clearing activities', e, stackTrace);
    }
  }

  // ==================== BUDGET HANDLERS ====================

  Future<void> _handleAddBudget(
      AddBudget event, Emitter<ActivityState> emit) async {
    try {
      final budgetWithId = event.budget.copyWith(id: _uuid.v4());
      final updatedBudgets = [...state.budgets, budgetWithId];

      final processedBudgets = await _processAndUpdateBudgets(updatedBudgets);
      emit(state.copyWith(budgets: processedBudgets));
    } catch (e, stackTrace) {
      _logError('Error adding budget', e, stackTrace);
    }
  }

  Future<void> _handleUpdateBudget(
      UpdateBudget event, Emitter<ActivityState> emit) async {
    try {
      final updatedBudgets = state.budgets
          .map((budget) => budget.id == event.updatedBudget.id
              ? event.updatedBudget
              : budget)
          .toList();

      final processedBudgets = await _processAndUpdateBudgets(updatedBudgets);
      emit(state.copyWith(budgets: processedBudgets));
    } catch (e, stackTrace) {
      _logError('Error updating budget', e, stackTrace);
    }
  }

  Future<void> _handleRemoveBudget(
      RemoveBudget event, Emitter<ActivityState> emit) async {
    try {
      final updatedBudgets =
          state.budgets.where((budget) => budget.id != event.budgetId).toList();

      emit(state.copyWith(budgets: updatedBudgets));
    } catch (e, stackTrace) {
      _logError('Error removing budget', e, stackTrace);
    }
  }

  // ==================== RECURRING ACTIVITY HANDLERS ====================

  Future<void> _handleAddRecurringActivity(
      AddRecurringActivity event, Emitter<ActivityState> emit) async {
    try {
      final recurringWithId = event.recurringActivity.copyWith(id: _uuid.v4());
      final updatedRecurring = [...state.recurringActivities, recurringWithId];

      emit(state.copyWith(recurringActivities: updatedRecurring));
      add(GenerateRecurringInstances(untilDate: DateTime.now()));
    } catch (e, stackTrace) {
      _logError('Error adding recurring activity', e, stackTrace);
    }
  }

  Future<void> _handleUpdateRecurringActivity(
      UpdateRecurringActivity event, Emitter<ActivityState> emit) async {
    try {
      final updatedRecurring = state.recurringActivities
          .map((rec) => rec.id == event.updatedRecurringActivity.id
              ? event.updatedRecurringActivity
              : rec)
          .toList();

      emit(state.copyWith(recurringActivities: updatedRecurring));
      add(GenerateRecurringInstances(untilDate: DateTime.now()));
    } catch (e, stackTrace) {
      _logError('Error updating recurring activity', e, stackTrace);
    }
  }

  Future<void> _handleRemoveRecurringActivity(
      RemoveRecurringActivity event, Emitter<ActivityState> emit) async {
    try {
      final updatedRecurring = state.recurringActivities
          .where((rec) => rec.id != event.recurringActivityId)
          .toList();

      final updatedActivities = state.allActivities
          .where((act) => act.recurringActivityId != event.recurringActivityId)
          .toList();

      _recurringGenerationCache.remove(event.recurringActivityId);
      _invalidateCache();

      final analytics = await _calculateAnalytics(updatedActivities);
      final processedBudgets = await _processAndUpdateBudgets(state.budgets);

      emit(state.copyWith(
        recurringActivities: updatedRecurring,
        allActivities: updatedActivities,
        budgets: processedBudgets,
        totalIncome: analytics['totalIncome'] as double,
        totalExpenses: analytics['totalExpenses'] as double,
        netBalance: analytics['netBalance'] as double,
        expensesByType:
            analytics['expensesByType'] as Map<ActivityType, double>,
        incomeByType: analytics['incomeByType'] as Map<ActivityType, double>,
        todayIncome: analytics['todayIncome'] as double,
        todayExpenses: analytics['todayExpenses'] as double,
        thisWeekIncome: analytics['thisWeekIncome'] as double,
        thisWeekExpenses: analytics['thisWeekExpenses'] as double,
        thisMonthIncome: analytics['thisMonthIncome'] as double,
        thisMonthExpenses: analytics['thisMonthExpenses'] as double,
      ));
    } catch (e, stackTrace) {
      _logError('Error removing recurring activity', e, stackTrace);
    }
  }

  Future<void> _handleGenerateRecurringInstances(
      GenerateRecurringInstances event, Emitter<ActivityState> emit) async {
    try {
      final newInstances = await _generateRecurringInstances(event.untilDate);

      if (newInstances.isNotEmpty) {
        final updatedActivities = _addAndSortActivities(newInstances);
        await _emitUpdatedState(emit, updatedActivities);
      }
    } catch (e, stackTrace) {
      _logError('Error generating recurring instances', e, stackTrace);
    }
  }

  // ==================== CORE BUSINESS LOGIC ====================

  List<ActivityData> _addAndSortActivities(List<ActivityData> newActivities) {
    final allActivities = [...state.allActivities, ...newActivities];
    final prunedActivities = _activityUtil.pruneActivities(allActivities);
    prunedActivities.sort((a, b) => b.date.compareTo(a.date));
    return prunedActivities;
  }

  Future<void> _emitUpdatedState(
      Emitter<ActivityState> emit, List<ActivityData> activities) async {
    _invalidateCache();

    final analytics = await _calculateAnalytics(activities);
    final processedBudgets = await _processAndUpdateBudgets(state.budgets);

    emit(state.copyWith(
      allActivities: activities,
      budgets: processedBudgets,
      totalIncome: analytics['totalIncome'] as double,
      totalExpenses: analytics['totalExpenses'] as double,
      netBalance: analytics['netBalance'] as double,
      expensesByType: analytics['expensesByType'] as Map<ActivityType, double>,
      incomeByType: analytics['incomeByType'] as Map<ActivityType, double>,
      todayIncome: analytics['todayIncome'] as double,
      todayExpenses: analytics['todayExpenses'] as double,
      thisWeekIncome: analytics['thisWeekIncome'] as double,
      thisWeekExpenses: analytics['thisWeekExpenses'] as double,
      thisMonthIncome: analytics['thisMonthIncome'] as double,
      thisMonthExpenses: analytics['thisMonthExpenses'] as double,
    ));
  }

  Future<Map<String, dynamic>> _calculateAnalytics(
      List<ActivityData> activities) async {
    _invalidateCacheIfExpired();

    const cacheKey = 'analytics';
    if (_analyticsCache.containsKey(cacheKey)) {
      return _analyticsCache[cacheKey] as Map<String, dynamic>;
    }

    // Calculate all analytics in one pass for better performance
    final analytics = await _computeAnalytics(activities);
    _analyticsCache[cacheKey] = analytics;

    return analytics;
  }

  Future<Map<String, dynamic>> _computeAnalytics(
      List<ActivityData> activities) async {
    final totalIncome = _activityUtil.calculateTotalIncome(activities);
    final totalExpenses = _activityUtil.calculateTotalExpenses(activities);
    final netBalance = totalIncome - totalExpenses;

    final expensesByType = _activityUtil.calculateExpensesByType(activities);
    final incomeByType = _activityUtil.calculateIncomeByType(activities);

    // Calculate period totals efficiently
    final todayRange = _activityUtil.getTodayRange();
    final weekRange = _activityUtil.getThisWeekRange();
    final monthRange = _activityUtil.getThisMonthRange();

    final todayTotals =
        _activityUtil.calculatePeriodTotals(activities, todayRange);
    final weekTotals =
        _activityUtil.calculatePeriodTotals(activities, weekRange);
    final monthTotals =
        _activityUtil.calculatePeriodTotals(activities, monthRange);

    return {
      'totalIncome': totalIncome,
      'totalExpenses': totalExpenses,
      'netBalance': netBalance,
      'expensesByType': expensesByType,
      'incomeByType': incomeByType,
      'todayIncome': todayTotals.income,
      'todayExpenses': todayTotals.expense,
      'thisWeekIncome': weekTotals.income,
      'thisWeekExpenses': weekTotals.expense,
      'thisMonthIncome': monthTotals.income,
      'thisMonthExpenses': monthTotals.expense,
    };
  }

  Future<List<ActivityData>> _generateRecurringInstances(
      DateTime untilDate) async {
    final newInstances = <ActivityData>[];
    final existingInstanceKeys = _buildExistingInstanceKeys();

    for (final recurring in state.recurringActivities) {
      if (!_shouldRegenerateRecurring(recurring, untilDate)) continue;

      final instances = await _generateInstancesForRecurring(
          recurring, untilDate, existingInstanceKeys);
      newInstances.addAll(instances);

      _recurringGenerationCache[recurring.id] = untilDate;
    }

    return newInstances;
  }

  Set<String> _buildExistingInstanceKeys() {
    return state.allActivities
        .where((act) => act.recurringActivityId != null)
        .map((act) => '${act.recurringActivityId}-${_formatDateKey(act.date)}')
        .toSet();
  }

  String _formatDateKey(DateTime date) {
    return '${date.year}-${date.month}-${date.day}';
  }

  bool _shouldRegenerateRecurring(
      RecurringActivity recurring, DateTime untilDate) {
    final lastGenerated = _recurringGenerationCache[recurring.id];
    if (lastGenerated == null) return true;

    return switch (recurring.frequency) {
      RecurringFrequency.daily =>
        untilDate.difference(lastGenerated).inDays >= 1,
      RecurringFrequency.weekly =>
        untilDate.difference(lastGenerated).inDays >= 7,
      RecurringFrequency.biWeekly =>
        untilDate.difference(lastGenerated).inDays >= 14,
      RecurringFrequency.monthly => untilDate.month != lastGenerated.month ||
          untilDate.year != lastGenerated.year,
      RecurringFrequency.yearly => untilDate.year != lastGenerated.year,
    };
  }

  Future<List<ActivityData>> _generateInstancesForRecurring(
    RecurringActivity recurring,
    DateTime untilDate,
    Set<String> existingKeys,
  ) async {
    final instances = <ActivityData>[];
    var nextDate = _findStartDate(recurring, existingKeys);

    if (nextDate.isAfter(untilDate)) return instances;

    while (!nextDate.isAfter(untilDate) &&
        instances.length < _maxRecurringInstances) {
      if (recurring.endDate != null && nextDate.isAfter(recurring.endDate!)) {
        break;
      }

      final instanceKey = '${recurring.id}-${_formatDateKey(nextDate)}';
      if (!existingKeys.contains(instanceKey)) {
        instances.add(_createRecurringInstance(recurring, nextDate));
        existingKeys.add(instanceKey);
      }

      nextDate = _calculateNextDueDate(nextDate, recurring.frequency);

      if (nextDate.year > untilDate.year + _maxYearsAhead) break;
    }

    return instances;
  }

  DateTime _findStartDate(
      RecurringActivity recurring, Set<String> existingKeys) {
    // Find the latest existing instance to continue from there
    var latestExisting = DateTime(1900);
    for (final activity in state.allActivities) {
      if (activity.recurringActivityId == recurring.id &&
          activity.date.isAfter(latestExisting)) {
        latestExisting = activity.date;
      }
    }

    return latestExisting.year > 1900
        ? _calculateNextDueDate(latestExisting, recurring.frequency)
        : recurring.startDate;
  }

  ActivityData _createRecurringInstance(
      RecurringActivity recurring, DateTime date) {
    return ActivityData(
      id: _uuid.v4(),
      nature: _determineActivityNature(recurring.type),
      title: recurring.title,
      amount: recurring.amount,
      date: date,
      type: recurring.type,
      recurringActivityId: recurring.id,
    );
  }

  DateTime _calculateNextDueDate(
      DateTime current, RecurringFrequency frequency) {
    return switch (frequency) {
      RecurringFrequency.daily => current.add(const Duration(days: 1)),
      RecurringFrequency.weekly => current.add(const Duration(days: 7)),
      RecurringFrequency.biWeekly => current.add(const Duration(days: 14)),
      RecurringFrequency.monthly => _addMonths(current, 1),
      RecurringFrequency.yearly => _addYears(current, 1),
    };
  }

  DateTime _addMonths(DateTime date, int months) {
    var newMonth = date.month + months;
    var newYear = date.year;

    while (newMonth > 12) {
      newMonth -= 12;
      newYear++;
    }

    final daysInNewMonth = DateTime(newYear, newMonth + 1, 0).day;
    final newDay = date.day > daysInNewMonth ? daysInNewMonth : date.day;

    return DateTime(newYear, newMonth, newDay);
  }

  DateTime _addYears(DateTime date, int years) {
    final newYear = date.year + years;
    final daysInTargetMonth = DateTime(newYear, date.month + 1, 0).day;
    final newDay = date.day > daysInTargetMonth ? daysInTargetMonth : date.day;

    return DateTime(newYear, date.month, newDay);
  }

  ActivityNature _determineActivityNature(ActivityType type) {
    const incomeTypes = {
      ActivityType.salary,
      ActivityType.freelance,
      ActivityType.investment,
    };

    return incomeTypes.contains(type) ||
            type.name.toLowerCase().contains('income')
        ? ActivityNature.income
        : ActivityNature.expense;
  }

  // ==================== BUDGET PROCESSING ====================

  Future<List<Budget>> _processAndUpdateBudgets(List<Budget> budgets) async {
    final now = DateTime.now();
    final processedBudgets = <Budget>[];

    // Group budgets by period and category for efficient processing
    final budgetGroups = <String, List<Budget>>{};
    for (final budget in budgets) {
      final key = '${budget.period.index}-${budget.category.index}';
      budgetGroups.putIfAbsent(key, () => []).add(budget);
    }

    for (final budgetGroup in budgetGroups.values) {
      for (final budget in budgetGroup) {
        final resetBudget =
            _shouldResetBudget(budget, now) ? budget.resetSpending() : budget;

        final spending = await _calculateBudgetSpending(resetBudget);
        processedBudgets.add(resetBudget.updateSpending(spending));
      }
    }

    return processedBudgets;
  }

  bool _shouldResetBudget(Budget budget, DateTime now) {
    if (budget.lastUpdated == null) return false;

    return switch (budget.period) {
      BudgetPeriod.weekly => budget.lastUpdated!.weekOfYear != now.weekOfYear,
      BudgetPeriod.monthly => budget.lastUpdated!.month != now.month ||
          budget.lastUpdated!.year != now.year,
      BudgetPeriod.yearly => budget.lastUpdated!.year != now.year,
    };
  }

  Future<double> _calculateBudgetSpending(Budget budget) async {
    final cacheKey = '${budget.period.index}-${budget.category.index}';

    if (_budgetSpendingCache.containsKey(cacheKey)) {
      return _budgetSpendingCache[cacheKey]!;
    }

    final activityType = _convertBudgetCategoryToActivityType(budget.category);
    final periodRange = _getPeriodDateRange(budget.period);

    final spending = state.allActivities
        .where((a) =>
            a.nature == ActivityNature.expense &&
            a.type == activityType &&
            !a.date.isBefore(periodRange.start) &&
            a.date.isBefore(periodRange.end))
        .fold(0.0, (sum, activity) => sum + activity.amount);

    _budgetSpendingCache[cacheKey] = spending;
    return spending;
  }

  ActivityType _convertBudgetCategoryToActivityType(BudgetCategory category) {
    return switch (category) {
      BudgetCategory.shopping => ActivityType.shopping,
      BudgetCategory.foodAndDrinks => ActivityType.foodAndDrinks,
      BudgetCategory.rent => ActivityType.rent,
      BudgetCategory.utilities => ActivityType.utilities,
      BudgetCategory.groceries => ActivityType.groceries,
      BudgetCategory.entertainment => ActivityType.entertainment,
      BudgetCategory.education => ActivityType.education,
      BudgetCategory.healthcare => ActivityType.healthcare,
      BudgetCategory.travel => ActivityType.travel,
      BudgetCategory.expenseOther => ActivityType.expenseOther,
    };
  }

  ({DateTime start, DateTime end}) _getPeriodDateRange(BudgetPeriod period) {
    final now = DateTime.now();

    return switch (period) {
      BudgetPeriod.weekly => _getWeeklyRange(now),
      BudgetPeriod.monthly => _getMonthlyRange(now),
      BudgetPeriod.yearly => _getYearlyRange(now),
    };
  }

  ({DateTime start, DateTime end}) _getWeeklyRange(DateTime now) {
    final start = now.subtract(Duration(days: now.weekday - 1));
    final end = start.add(const Duration(days: 7));
    return (
      start: DateTime(start.year, start.month, start.day),
      end: DateTime(end.year, end.month, end.day),
    );
  }

  ({DateTime start, DateTime end}) _getMonthlyRange(DateTime now) {
    return (
      start: DateTime(now.year, now.month, 1),
      end: DateTime(now.year, now.month + 1, 1),
    );
  }

  ({DateTime start, DateTime end}) _getYearlyRange(DateTime now) {
    return (
      start: DateTime(now.year, 1, 1),
      end: DateTime(now.year + 1, 1, 1),
    );
  }

  // ==================== ANALYTICS METHODS ====================

  Map<
      BudgetCategory,
      ({
        double allocated,
        double spent,
        double remaining,
        double progress,
        bool isOverBudget,
      })> getBudgetAnalytics() {
    final analytics = <BudgetCategory,
        ({
      double allocated,
      double spent,
      double remaining,
      double progress,
      bool isOverBudget,
    })>{};

    final budgetsByCategory = <BudgetCategory, List<Budget>>{};
    for (final budget in state.budgets) {
      budgetsByCategory.putIfAbsent(budget.category, () => []).add(budget);
    }

    for (final entry in budgetsByCategory.entries) {
      final category = entry.key;
      final budgets = entry.value;

      final totalAllocated = budgets.fold(0.0, (sum, b) => sum + b.amount);
      final totalSpent = budgets.fold(0.0, (sum, b) => sum + b.currentSpending);
      final remaining = totalAllocated - totalSpent;
      final progress = totalAllocated > 0
          ? (totalSpent / totalAllocated).clamp(0.0, 1.0)
          : 0.0;

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

  List<({DateTime date, Map<BudgetCategory, double> spending})>
      getDailySpendingTrend({
    required DateTime startDate,
    required DateTime endDate,
  }) {
    final trend = <({DateTime date, Map<BudgetCategory, double> spending})>[];

    // Pre-group activities by date for better performance
    final activitiesByDate = <String, List<ActivityData>>{};
    for (final activity in state.allActivities) {
      if (activity.nature == ActivityNature.expense &&
          !activity.date.isBefore(startDate) &&
          !activity.date.isAfter(endDate)) {
        final dateKey = _formatDateKey(activity.date);
        activitiesByDate.putIfAbsent(dateKey, () => []).add(activity);
      }
    }

    var currentDate = startDate;
    while (!currentDate.isAfter(endDate)) {
      final dateKey = _formatDateKey(currentDate);
      final dayActivities = activitiesByDate[dateKey] ?? [];

      if (dayActivities.isNotEmpty) {
        final daySpending = <BudgetCategory, double>{};

        for (final activity in dayActivities) {
          final category = _convertActivityTypeToBudgetCategory(activity.type);
          if (category != null) {
            daySpending[category] =
                (daySpending[category] ?? 0.0) + activity.amount;
          }
        }

        if (daySpending.isNotEmpty) {
          trend.add((date: currentDate, spending: daySpending));
        }
      }

      currentDate = currentDate.add(const Duration(days: 1));
    }

    return trend;
  }

  BudgetCategory? _convertActivityTypeToBudgetCategory(ActivityType type) {
    return switch (type) {
      ActivityType.shopping => BudgetCategory.shopping,
      ActivityType.foodAndDrinks => BudgetCategory.foodAndDrinks,
      ActivityType.rent => BudgetCategory.rent,
      ActivityType.utilities => BudgetCategory.utilities,
      ActivityType.groceries => BudgetCategory.groceries,
      ActivityType.entertainment => BudgetCategory.entertainment,
      ActivityType.education => BudgetCategory.education,
      ActivityType.healthcare => BudgetCategory.healthcare,
      ActivityType.travel => BudgetCategory.travel,
      ActivityType.expenseOther => BudgetCategory.expenseOther,
      _ => null,
    };
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
    var activeBudgets = 0;
    var nearingLimitBudgets = 0;
    var overBudgetBudgets = 0;
    var totalAllocated = 0.0;
    var totalSpent = 0.0;

    for (final budget in state.budgets) {
      totalAllocated += budget.amount;
      totalSpent += budget.currentSpending;

      if (budget.currentSpending > 0) activeBudgets++;

      final progress =
          budget.amount > 0 ? (budget.currentSpending / budget.amount) : 0.0;

      if (progress > 1.0) {
        overBudgetBudgets++;
      } else if (progress > 0.8) {
        nearingLimitBudgets++;
      }
    }

    final totalRemaining = totalAllocated - totalSpent;
    final overallProgress = totalAllocated > 0
        ? (totalSpent / totalAllocated).clamp(0.0, 1.0)
        : 0.0;

    return (
      totalBudgets: state.budgets.length,
      activeBudgets: activeBudgets,
      nearingLimitBudgets: nearingLimitBudgets,
      overBudgetBudgets: overBudgetBudgets,
      totalAllocated: totalAllocated,
      totalSpent: totalSpent,
      totalRemaining: totalRemaining,
      overallProgress: overallProgress,
    );
  }

  Map<
      BudgetCategory,
      List<
          ({
            BudgetPeriod period,
            double amount,
            double spent,
            double remaining,
            DateTime? lastUpdated,
          })>> getBudgetsByCategory() {
    final result = <BudgetCategory,
        List<
            ({
              BudgetPeriod period,
              double amount,
              double spent,
              double remaining,
              DateTime? lastUpdated,
            })>>{};

    for (final budget in state.budgets) {
      result.putIfAbsent(budget.category, () => []).add((
        period: budget.period,
        amount: budget.amount,
        spent: budget.currentSpending,
        remaining: budget.remainingAmount,
        lastUpdated: budget.lastUpdated,
      ));
    }

    return result;
  }

  // ==================== HYDRATED BLOC OVERRIDES ====================

  @override
  ActivityState? fromJson(Map<String, dynamic> json) {
    try {
      return ActivityState.fromJson(json);
    } catch (e, stackTrace) {
      _logError('Error hydrating ActivityBloc state', e, stackTrace);
      return ActivityState.initial();
    }
  }

  @override
  Map<String, dynamic>? toJson(ActivityState state) {
    try {
      return state.toJson();
    } catch (e, stackTrace) {
      _logError('Error serializing ActivityBloc state', e, stackTrace);
      return null;
    }
  }

  // ==================== UTILITY METHODS ====================

  void _logError(String message, Object error, StackTrace stackTrace) {
    LogUtil.e('$message: $error\n$stackTrace');
  }
}
