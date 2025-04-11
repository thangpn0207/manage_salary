// data_model.dart
import 'package:equatable/equatable.dart';

import '../core/constants/enums.dart';

class ActivityData extends Equatable {
  final String id; // Unique identifier for the entry
  final ActivityNature nature; // REQUIRED: Is this Income or Expense?
  final String
      title; // REQUIRED: Description (e.g., "Salary", "Groceries", "Coffee")
  final double amount; // REQUIRED: The absolute value (always positive)
  final DateTime date; // REQUIRED: When the activity occurred
  final ActivityType
      type; // REQUIRED: Category, renamed from activityType, using new enum
  final String?
      recurringActivityId; // Optional: Link to the recurring activity if generated from one

  ActivityData({
    String? id, // Optional: Will be generated if not provided
    required this.nature,
    required this.title,
    required this.amount,
    required this.date,
    required this.type, // Now required
    this.recurringActivityId,
  })  : assert(amount >= 0, 'Amount must be non-negative'),
        // Enforce positive amount storage
        id = id ??
            DateTime.now().millisecondsSinceEpoch.toString() +
                title.hashCode.toString(); // Simple unique ID generation

  @override
  // Include all fields that define the identity and value of an entry
  List<Object?> get props =>
      [id, nature, title, amount, date, type, recurringActivityId];

  // --- JSON Serialization for HydratedBloc ---

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nature': nature.name,
      // Store enum name as string
      'title': title,
      'amount': amount,
      'date': date.toIso8601String(),
      // Store date in standard format
      'type': type.name,
      // Store category name (now required)
      'recurringActivityId': recurringActivityId,
    };
  }

  factory ActivityData.fromJson(Map<String, dynamic> json) {
    try {
      // Determine nature, default to expense if missing
      final natureName =
          json['nature'] as String? ?? ActivityNature.expense.name;
      final nature = ActivityNature.values.firstWhere(
        (e) => e.name == natureName,
        orElse: () => ActivityNature.expense, // Safe default
      );

      // Determine category (type), use a safe default if missing/invalid
      // Choose a sensible default based on nature if possible, or a general 'other'
      final defaultType = nature == ActivityNature.income
          ? ActivityType.incomeOther
          : ActivityType.expenseOther;
      final typeName = json['type'] as String?;
      final type = typeName == null
          ? defaultType
          : ActivityType.values.firstWhere(
              (e) => e.name == typeName,
              orElse: () => defaultType, // Default category if name doesn't match
            );

      // Parse amount, ensure it's positive
      final amount = (json['amount'] as num? ?? 0.0).toDouble().abs();

      // Parse date safely
      final date =
          DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now();

      return ActivityData(
        // Use stored ID or generate one if missing
        id: json['id'] as String? ??
            DateTime.now().millisecondsSinceEpoch.toString() +
                (json['title'] ?? '').hashCode.toString(),
        nature: nature,
        title: json['title'] as String? ?? 'Unknown Entry',
        // Safe title default
        amount: amount,
        date: date,
        type: type,
        recurringActivityId: json['recurringActivityId'] as String?,
      );
    } catch (e, stackTrace) {
      print("Error deserializing ActivityData: $e
$stackTrace
Data: $json");
      // Return a default/error placeholder object
      return ActivityData(
        id: "${DateTime.now().millisecondsSinceEpoch}error",
        nature: ActivityNature.expense,
        title: "Error Loading Entry",
        amount: 0.0,
        date: DateTime.now(),
        type: ActivityType.expenseOther, // Use a default type
      );
    }
  }

  // --- copyWith method ---

  ActivityData copyWith({
    String? id,
    ActivityNature? nature,
    String? title,
    double? amount,
    DateTime? date,
    ActivityType? type,
    String? recurringActivityId,
    bool clearRecurringId = false, // Flag to explicitly clear recurring ID
  }) {
    return ActivityData(
      id: id ?? this.id,
      nature: nature ?? this.nature,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      type: type ?? this.type,
      recurringActivityId: clearRecurringId
          ? null
          : (recurringActivityId ?? this.recurringActivityId),
    );
  }
}
