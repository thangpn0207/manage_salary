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
  final ActivityPaying?
      activityType; // Optional: Category, primarily for expenses, but can be used for income too.

  ActivityData({
    String? id, // Optional: Will be generated if not provided
    required this.nature,
    required this.title,
    required this.amount,
    required this.date,
    this.activityType, // Nullable category
  })  : assert(amount >= 0, 'Amount must be non-negative'),
        // Enforce positive amount storage
        id = id ??
            DateTime.now().millisecondsSinceEpoch.toString() +
                title.hashCode.toString(); // Simple unique ID generation

  @override
  // Include all fields that define the identity and value of an entry
  List<Object?> get props => [id, nature, title, amount, date, activityType];

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
      'activityType': activityType?.name,
      // Store category name if present, null otherwise
    };
  }

  factory ActivityData.fromJson(Map<String, dynamic> json) {
    try {
      // Determine nature, default to expense if missing (for backward compatibility or safety)
      final natureName =
          json['nature'] as String? ?? ActivityNature.expense.name;
      final nature = ActivityNature.values.firstWhere(
        (e) => e.name == natureName,
        orElse: () => ActivityNature.expense, // Safe default
      );

      // Determine category (activityType), handle null
      final categoryName = json['activityType'] as String?;
      final activityType = categoryName == null
          ? null // Explicitly null if no category name stored
          : ActivityPaying.values.firstWhere(
              (e) => e.name == categoryName,
              orElse: () => ActivityPaying
                  .other, // Default category if name doesn't match
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
        activityType: activityType,
      );
    } catch (e, stackTrace) {
      print("Error deserializing ActivityData: $e\n$stackTrace\nData: $json");
      // Return a default/error placeholder object
      return ActivityData(
        id: "${DateTime.now().millisecondsSinceEpoch}error",
        nature: ActivityNature.expense,
        title: "Error Loading Entry",
        amount: 0.0,
        date: DateTime.now(),
        activityType: ActivityPaying.other,
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
    // Use Object? trick or ValueGetter for nullable fields if strict null safety needed
    // For simplicity here, null means "no change" for category
    ActivityPaying? activityType, // Pass null explicitly to clear category
    bool clearActivityType = false, // Add flag to explicitly clear if needed
  }) {
    return ActivityData(
      id: id ?? this.id,
      nature: nature ?? this.nature,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      activityType:
          clearActivityType ? null : (activityType ?? this.activityType),
    );
  }
}
