
import 'package:equatable/equatable.dart';
import 'package:manage_salary/core/constants/enums.dart'; // Assuming ActivityType is here

import 'activity_data.dart'; // To possibly link to base activity structure

/// Represents an activity that recurs at a set frequency.
class RecurringActivity extends Equatable {
  final String id;
  final String title;
  final double amount;
  final ActivityType type; // Income or Expense category
  final RecurringFrequency frequency; // e.g., Daily, Weekly, Monthly
  final DateTime startDate; // The date the first instance occurs
  final DateTime? endDate; // Optional: when the recurrence stops
  // Optional: dayOfMonth, dayOfWeek fields if needed for specific frequencies

  const RecurringActivity({
    required this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.frequency,
    required this.startDate,
    this.endDate,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        amount,
        type,
        frequency,
        startDate,
        endDate,
      ];

  RecurringActivity copyWith({
    String? id,
    String? title,
    double? amount,
    ActivityType? type,
    RecurringFrequency? frequency,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return RecurringActivity(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      frequency: frequency ?? this.frequency,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}
