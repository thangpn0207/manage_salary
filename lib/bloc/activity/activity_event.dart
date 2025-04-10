// activity_event.dart
import 'package:equatable/equatable.dart';

import '../../models/activity_data.dart';

abstract class ActivityEvent extends Equatable {
  const ActivityEvent();

  @override
  List<Object> get props => [];
}

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
