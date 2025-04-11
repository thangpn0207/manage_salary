// activity_bloc.dart
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:manage_salary/bloc/activity/util/activity_util.dart';
import 'package:uuid/uuid.dart';

// Import events, state, models, enums
import '../../core/constants/enums.dart';
import '../../models/activity_data.dart';
import '../../models/budget.dart';             // Import model
import '../../models/recurring_activity.dart'; // Import model
import 'activity_event.dart';
import 'activity_state.dart';
// Calculation helper is now part of ActivityState

class ActivityBloc extends HydratedBloc<ActivityEvent, ActivityState> {
  final Uuid _uuid = const Uuid();

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

    // Trigger generation on initial load (optional, adjust as needed)
    // Consider if this should happen elsewhere or based on time passing
    add(GenerateRecurringInstances(untilDate: DateTime.now()));
  }

  // --- Standard Activity Handlers ---

  void _onAddActivity(AddActivity event, Emitter<ActivityState> emit) {
    final activityWithId = event.newActivity.copyWith(
      id: _uuid.v4(),
    );
    final updatedList = List<ActivityData>.from(state.allActivities)
      ..add(activityWithId);
    final prunedList = ActivityUtil().pruneActivities(updatedList);
    prunedList.sort((a, b) => b.date.compareTo(a.date));

    final analytics = calculateAnalytics(prunedList); // Recalculate

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

  void _onRemoveActivity(RemoveActivity event, Emitter<ActivityState> emit) {
    final updatedList = List<ActivityData>.from(state.allActivities)
      ..removeWhere((activity) => activity.id == event.activityId);
    updatedList.sort((a, b) => b.date.compareTo(a.date));

    final analytics = calculateAnalytics(updatedList); // Recalculate

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
      // Also remove generated instances linked to a removed recurring parent?
      // Could iterate and remove activities where recurringActivityId matches
    ));
  }

  void _onClearAllActivities(
      ClearAllActivities event, Emitter<ActivityState> emit) {
    // Consider if clearing activities should also clear budgets/recurring
    emit(ActivityState.initial()); // Reset to initial state is simplest
  }

  // --- Budget Handlers ---

  void _onAddBudget(AddBudget event, Emitter<ActivityState> emit) {
    final budgetWithId = event.budget.copyWith(id: _uuid.v4());
    final updatedBudgets = List<Budget>.from(state.budgets)..add(budgetWithId);
    emit(state.copyWith(budgets: updatedBudgets));
    // TODO: Add UI for managing budgets
  }

  void _onUpdateBudget(UpdateBudget event, Emitter<ActivityState> emit) {
    final updatedBudgets = state.budgets.map((budget) {
      return budget.id == event.updatedBudget.id ? event.updatedBudget : budget;
    }).toList();
    emit(state.copyWith(budgets: updatedBudgets));
  }

  void _onRemoveBudget(RemoveBudget event, Emitter<ActivityState> emit) {
    final updatedBudgets = List<Budget>.from(state.budgets)
      ..removeWhere((budget) => budget.id == event.budgetId);
    emit(state.copyWith(budgets: updatedBudgets));
  }

  // --- Recurring Activity Handlers ---

  void _onAddRecurringActivity(
      AddRecurringActivity event, Emitter<ActivityState> emit) {
    final recurringWithId = event.recurringActivity.copyWith(id: _uuid.v4());
    final updatedRecurring = List<RecurringActivity>.from(state.recurringActivities)
      ..add(recurringWithId);
    emit(state.copyWith(recurringActivities: updatedRecurring));
    // Optionally trigger instance generation immediately
    add(GenerateRecurringInstances(untilDate: DateTime.now()));
     // TODO: Add UI for managing recurring activities
  }

  void _onUpdateRecurringActivity(
      UpdateRecurringActivity event, Emitter<ActivityState> emit) {
    final updatedRecurring = state.recurringActivities.map((rec) {
      return rec.id == event.updatedRecurringActivity.id
          ? event.updatedRecurringActivity
          : rec;
    }).toList();
    emit(state.copyWith(recurringActivities: updatedRecurring));
    // Optional: Trigger regeneration if dates/frequency changed significantly
    add(GenerateRecurringInstances(untilDate: DateTime.now()));
  }

  void _onRemoveRecurringActivity(
      RemoveRecurringActivity event, Emitter<ActivityState> emit) {
    final updatedRecurring = List<RecurringActivity>.from(state.recurringActivities)
      ..removeWhere((rec) => rec.id == event.recurringActivityId);

    // Also remove generated activities linked to this recurring one
    final updatedActivities = List<ActivityData>.from(state.allActivities)
        ..removeWhere((act) => act.recurringActivityId == event.recurringActivityId);
    updatedActivities.sort((a,b) => b.date.compareTo(a.date)); // Re-sort

    // Recalculate analytics after removing linked activities
    final analytics = calculateAnalytics(updatedActivities);

    emit(state.copyWith(
      recurringActivities: updatedRecurring,
      allActivities: updatedActivities, // Emit updated activities list
      // Emit recalculated analytics
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

  void _onGenerateRecurringInstances(
      GenerateRecurringInstances event, Emitter<ActivityState> emit) {

    // Simple generation logic - needs refinement for different frequencies
    // This is a basic example for MONTHLY recurrence. Needs expansion.
    List<ActivityData> newlyGenerated = [];
    DateTime now = DateTime.now(); // Or use event.untilDate

    for (final recurring in state.recurringActivities) {
      DateTime nextDueDate = recurring.startDate;

       // Make sure start date is not in the future for generation loop
      if (nextDueDate.isAfter(now)) continue;

      while (nextDueDate.isBefore(now) || nextDueDate.isAtSameMomentAs(now)) {
         // Check if end date is reached
        if (recurring.endDate != null && nextDueDate.isAfter(recurring.endDate!)) {
          break; // Stop generating for this item if end date passed
        }

        // Check if an instance for this recurring item on this date already exists
        bool alreadyExists = state.allActivities.any((activity) =>
            activity.recurringActivityId == recurring.id &&
            activity.date.year == nextDueDate.year &&
            activity.date.month == nextDueDate.month &&
            activity.date.day == nextDueDate.day // Check day specifically
        );

        if (!alreadyExists) {
           // Create instance ONLY if it doesn't exist and is within end date
          newlyGenerated.add(ActivityData(
            // Generate new ID for the instance
            id: _uuid.v4(),
            nature: recurring.type.name.toLowerCase().contains('income') || recurring.type == ActivityType.salary || recurring.type == ActivityType.freelance || recurring.type == ActivityType.investment
                ? ActivityNature.income
                : ActivityNature.expense, // Determine nature from type
            title: recurring.title,
            amount: recurring.amount,
            date: nextDueDate,
            type: recurring.type,
            recurringActivityId: recurring.id, // Link back
          ));
        }

         // Calculate the *next* potential due date based on frequency
        try {
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
              // Attempting smarter month increment (handles month length)
              var newMonth = nextDueDate.month + 1;
              var newYear = nextDueDate.year;
              if (newMonth > 12) {
                newMonth = 1;
                newYear++;
              }
              // Check if the original day exists in the new month
              var daysInNewMonth = DateTime(newYear, newMonth + 1, 0).day;
              var newDay = nextDueDate.day > daysInNewMonth ? daysInNewMonth : nextDueDate.day;
              nextDueDate = DateTime(newYear, newMonth, newDay);
              break;
            case RecurringFrequency.yearly:
              // Handle leap years for Feb 29
              var newDay = nextDueDate.day;
              if (nextDueDate.month == 2 && nextDueDate.day == 29) {
                  // If next year is not a leap year, use Feb 28
                  if (!DateTime(nextDueDate.year + 1, 1, 1).isUtc) { // Quick leap year check approximation
                     if (((nextDueDate.year + 1) % 4 == 0) && (((nextDueDate.year + 1) % 100 != 0) || ((nextDueDate.year + 1) % 400 == 0))) {
                       // It is a leap year
                     } else {
                       newDay = 28;
                     }
                  }
              }
              nextDueDate = DateTime(nextDueDate.year + 1, nextDueDate.month, newDay);
              break;
          }
        } catch (e) {
           print("Error calculating next due date: $e");
           break; // Exit loop for this item if date calculation fails
        }

         // Safety break for potential infinite loops if logic is flawed
         if (nextDueDate.year > now.year + 10) break; // Limit generation horizon further
         if (newlyGenerated.length > 1000) break; // Limit batch size
      }
    }

    if (newlyGenerated.isNotEmpty) {
      final updatedList = List<ActivityData>.from(state.allActivities)..addAll(newlyGenerated);
      // No need to prune generated activities unless specific rules apply
      updatedList.sort((a, b) => b.date.compareTo(a.date)); // Re-sort

      final analytics = calculateAnalytics(updatedList); // Recalculate

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
    }
    // No change emission if nothing was generated
  }


  // --- HydratedBloc Overrides ---

  @override
  ActivityState? fromJson(Map<String, dynamic> json) {
    try {
       // We need ActivityState.fromJson to handle the new lists
       // We will update that next after adding toJson/fromJson to models
      final state = ActivityState.fromJson(json);
      // Trigger generation after loading state
      add(GenerateRecurringInstances(untilDate: DateTime.now()));
      return state;
    } catch (e, stackTrace) {
      print("Error hydrating ActivityBloc state: $e
$stackTrace");
      // Fallback to initial state on error
      return ActivityState.initial();
    }
  }

  @override
  Map<String, dynamic>? toJson(ActivityState state) {
    // We need state.toJson to include the new lists
    // We will update that next after adding toJson/fromJson to models
     try {
      return state.toJson();
    } catch (e, stackTrace) {
      print("Error serializing ActivityBloc state: $e
$stackTrace");
      return null;
    }
  }
}
