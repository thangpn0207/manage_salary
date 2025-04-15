import 'package:equatable/equatable.dart';
import 'package:manage_salary/core/constants/enums.dart';
import 'package:manage_salary/core/util/log_util.dart';
import 'package:uuid/uuid.dart'; // For default ID generation

/// Represents an activity that recurs at a set frequency.
class RecurringActivity extends Equatable {
  final String id;
  final String title;
  final double amount;
  final ActivityType type; // Income or Expense category
  final RecurringFrequency frequency;
  final DateTime startDate; // The date the first instance occurs
  final DateTime? endDate; // Optional: when the recurrence stops

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
    bool clearEndDate = false, // Flag to explicitly clear end date
  }) {
    return RecurringActivity(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      frequency: frequency ?? this.frequency,
      startDate: startDate ?? this.startDate,
      endDate: clearEndDate ? null : (endDate ?? this.endDate),
    );
  }

  // --- JSON Serialization ---

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'type': type.name,
      // Store enum name
      'frequency': frequency.name,
      // Store enum name
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      // Store optional date as ISO string or null
    };
  }

  factory RecurringActivity.fromJson(Map<String, dynamic> json) {
    try {
      final endDateString = json['endDate'] as String?;
      return RecurringActivity(
        id: json['id'] as String? ?? const Uuid().v4(),
        // Generate ID if missing
        title: json['title'] as String? ?? 'Recurring Entry',
        amount: (json['amount'] as num? ?? 0.0).toDouble(),
        type: ActivityType.values
            .byName(json['type'] as String? ?? ActivityType.expenseOther.name),
        frequency: RecurringFrequency.values.byName(
            json['frequency'] as String? ?? RecurringFrequency.monthly.name),
        startDate: DateTime.tryParse(json['startDate'] as String? ?? '') ??
            DateTime.now(),
        endDate:
            endDateString == null ? null : DateTime.tryParse(endDateString),
      );
    } catch (e, stackTrace) {
      LogUtil.e(
          "Error deserializing RecurringActivity: $e $stackTrace Data: $json");
      // Provide a fallback recurring activity
      return RecurringActivity(
        id: const Uuid().v4(),
        title: 'Error Loading Recurring',
        amount: 0.0,
        type: ActivityType.expenseOther,
        frequency: RecurringFrequency.monthly,
        startDate: DateTime.now(),
        endDate: null,
      );
    }
  }
}
