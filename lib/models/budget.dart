
import 'package:equatable/equatable.dart';
import 'package:manage_salary/core/constants/enums.dart';
import 'package:uuid/uuid.dart'; // For default ID generation

/// Represents a budget set for a specific category over a period.
class Budget extends Equatable {
  final String id;
  final ActivityType category; // Link to expense category
  final double amount;
  final BudgetPeriod period;
  final DateTime startDate;

  const Budget({
    required this.id,
    required this.category,
    required this.amount,
    required this.period,
    required this.startDate,
  });

  @override
  List<Object?> get props => [id, category, amount, period, startDate];

  Budget copyWith({
    String? id,
    ActivityType? category,
    double? amount,
    BudgetPeriod? period,
    DateTime? startDate,
  }) {
    return Budget(
      id: id ?? this.id,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      period: period ?? this.period,
      startDate: startDate ?? this.startDate,
    );
  }

  // --- JSON Serialization ---

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category.name, // Store enum name
      'amount': amount,
      'period': period.name,     // Store enum name
      'startDate': startDate.toIso8601String(), // Store date as ISO string
    };
  }

  factory Budget.fromJson(Map<String, dynamic> json) {
    try {
      return Budget(
        id: json['id'] as String? ?? const Uuid().v4(), // Generate ID if missing
        category: ActivityType.values.byName(json['category'] as String? ?? ActivityType.expenseOther.name),
        amount: (json['amount'] as num? ?? 0.0).toDouble(),
        period: BudgetPeriod.values.byName(json['period'] as String? ?? BudgetPeriod.monthly.name),
        startDate: DateTime.tryParse(json['startDate'] as String? ?? '') ?? DateTime.now(),
      );
    } catch (e, stackTrace) {
      print("Error deserializing Budget: $e
$stackTrace
Data: $json");
      // Provide a fallback budget
      return Budget(
        id: const Uuid().v4(),
        category: ActivityType.expenseOther,
        amount: 0.0,
        period: BudgetPeriod.monthly,
        startDate: DateTime.now(),
      );
    }
  }
}
