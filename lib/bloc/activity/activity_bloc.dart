// activity_bloc.dart

import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:manage_salary/bloc/activity/util/activity_util.dart';
import 'package:uuid/uuid.dart';

// Import events, state, model, enums AS WELL AS calculation helpers
import '../../core/util/log_util.dart';
import '../../models/activity_data.dart';
import 'activity_event.dart';
import 'activity_state.dart';
// Assuming helpers are in this file or imported from activity_utils.dart

class ActivityBloc extends HydratedBloc<ActivityEvent, ActivityState> {
  final Uuid _uuid = const Uuid();

  ActivityBloc() : super(ActivityState.initial()) {
    // Rename event handler to match AddEntry event
    on<AddActivity>(_onAddEntry);
    on<RemoveActivity>(_onRemoveActivity);
    on<ClearAllActivities>(_onClearAllActivities);
  }

  // Event handler now performs calculations explicitly
  void _onAddEntry(AddActivity event, Emitter<ActivityState> emit) {
    // 1. Generate a unique ID and create the activity with the ID
    // Assuming ActivityData has a copyWith method or a constructor that takes an id
    final activityWithId = event.newActivity.copyWith(
      id: _uuid.v4(), // Generate and assign a v4 UUID
    );

    // 2. Update list with the new activity *that includes the ID*
    final updatedList = List<ActivityData>.from(state.allActivities)
      ..add(activityWithId); // Add the activity with the generated ID

    // 3. Prune & Sort
    final prunedList = ActivityUtil().pruneActivities(updatedList);
    // Consider sorting *after* pruning if pruning might affect order significantly
    prunedList.sort((a, b) => b.date.compareTo(a.date));

    // 4. Explicitly Calculate Analytics
    final analytics = calculateAnalytics(prunedList); // Use the central helper

    // 5. Emit new state with updated list AND calculated analytics
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
  }

// --- NEW: Handler for removing a single activity ---
  void _onRemoveActivity(RemoveActivity event, Emitter<ActivityState> emit) {
    // 1. Create a new list excluding the item with the matching ID
    final updatedList = List<ActivityData>.from(state.allActivities)
      ..removeWhere((activity) => activity.id == event.activityId);

    // 2. Pruning might not be strictly necessary after removal unless
    //    your pruning logic depends on the list size itself.
    //    Sorting is still good practice if order matters.
    // final prunedList = ActivityUtil().pruneActivities(updatedList); // Optional prune
    updatedList.sort((a, b) => b.date.compareTo(a.date)); // Keep sorted

    // 3. Recalculate analytics based on the modified list
    final analytics = calculateAnalytics(updatedList); // Use the updated list

    // 4. Emit the new state
    emit(state.copyWith(
      allActivities: updatedList,
      // Use the updated list
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
  }

  // --- NEW: Handler for clearing all activities ---
  void _onClearAllActivities(
      ClearAllActivities event, Emitter<ActivityState> emit) {
    // 1. Create an empty list
    const List<ActivityData> emptyList = [];

    // 2. Calculate analytics for the empty list (should result in zeros)
    final analytics = calculateAnalytics(emptyList);

    // 3. Emit the new state with the empty list and zeroed analytics
    //    Alternatively, emit ActivityState.initial() if that's desired behavior.
    emit(state.copyWith(
      allActivities: emptyList,
      totalIncome: analytics.totalIncome,
      // Should be 0
      totalExpenses: analytics.totalExpenses,
      // Should be 0
      netBalance: analytics.netBalance,
      // Should be 0
      expensesByType: analytics.expensesByType,
      // Should be empty map
      incomeByType: analytics.incomeByType,
      // Should be empty map
      todayIncome: analytics.todayIncome,
      // Should be 0
      todayExpenses: analytics.todayExpenses,
      // Should be 0
      thisWeekIncome: analytics.thisWeekIncome,
      // Should be 0
      thisWeekExpenses: analytics.thisWeekExpenses,
      // Should be 0
      thisMonthIncome: analytics.thisMonthIncome,
      // Should be 0
      thisMonthExpenses: analytics.thisMonthExpenses, // Should be 0
      // Reset any other relevant state fields if necessary
    ));

    // OR, if clearing should completely reset the state:
    // emit(ActivityState.initial());
  }

  // --- HydratedBloc Overrides ---

  @override
  ActivityState? fromJson(Map<String, dynamic> json) {
    // ActivityState.fromJson now correctly returns a fully calculated state
    // because we moved the calculation call inside its factory.
    try {
      return ActivityState.fromJson(json);
    } catch (e, stackTrace) {
      LogUtil.e("Error hydrating ActivityBloc state: $e\n$stackTrace");
      return null; // Or ActivityState.initial()
    }
  }

  @override
  Map<String, dynamic>? toJson(ActivityState state) {
    // No change needed, state.toJson only saves the list
    try {
      return state.toJson();
    } catch (e, stackTrace) {
      LogUtil.e("Error serializing ActivityBloc state: $e\n$stackTrace");
      return null;
    }
  }
}
