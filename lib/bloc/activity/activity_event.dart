// activity_event.dart
import 'package:equatable/equatable.dart';

import '../../models/activity_data.dart';
import '../../models/budget.dart';             // Import new model
import '../../models/recurring_activity.dart'; // Import new model

abstract class ActivityEvent extends Equatable {
  const ActivityEvent();

  @override
  List<Object> get props => [];
}

// --- Standard Activity Events ---

// Event dispatched when a new activity is added
class AddActivity extends ActivityEvent {
  final ActivityData newActivity;

  const AddActivity(this.newActivity);

  @override
  List<Object> get props => [newActivity];
}

// Event to remove a single activity by its ID
class RemoveActivity extends ActivityEvent {
  final String activityId;

  const RemoveActivity(this.activityId);

  @override
  List<Object> get props => [activityId];
}

// Event to clear all activities
class ClearAllActivities extends ActivityEvent {
  const ClearAllActivities();
// No props needed
}

// --- Budget Events ---

// Event to add a new budget
class AddBudget extends ActivityEvent {
  final Budget budget;

  const AddBudget(this.budget);

  @override
  List<Object> get props => [budget];
}

// Event to update an existing budget
class UpdateBudget extends ActivityEvent {
  final Budget updatedBudget;

  const UpdateBudget(this.updatedBudget);

  @override
  List<Object> get props => [updatedBudget];
}

// Event to remove a budget by its ID
class RemoveBudget extends ActivityEvent {
  final String budgetId;

  const RemoveBudget(this.budgetId);

  @override
  List<Object> get props => [budgetId];
}

// --- Recurring Activity Events ---

// Event to add a new recurring activity
class AddRecurringActivity extends ActivityEvent {
  final RecurringActivity recurringActivity;

  const AddRecurringActivity(this.recurringActivity);

  @override
  List<Object> get props => [recurringActivity];
}

// Event to update an existing recurring activity
class UpdateRecurringActivity extends ActivityEvent {
  final RecurringActivity updatedRecurringActivity;

  const UpdateRecurringActivity(this.updatedRecurringActivity);

  @override
  List<Object> get props => [updatedRecurringActivity];
}

// Event to remove a recurring activity by its ID
class RemoveRecurringActivity extends ActivityEvent {
  final String recurringActivityId;

  const RemoveRecurringActivity(this.recurringActivityId);

  @override
  List<Object> get props => [recurringActivityId];
}

// Optional: Event to trigger generation of activities from recurring sources
// This might be dispatched on app start or periodically
class GenerateRecurringInstances extends ActivityEvent {
  final DateTime untilDate; // Generate instances up to this date

  const GenerateRecurringInstances({required this.untilDate});

  @override
  List<Object> get props => [untilDate];
}
