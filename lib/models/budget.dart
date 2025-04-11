import 'package:equatable/equatable.dart'; // Import equatable
import 'package:manage_salary/ui/settings/budget/widgets/add_edit_budget_dialog.dart';

/// Represents a budget set for a specific category over a period.
class Budget extends Equatable {
  final String id;
  final BudgetCategory category; // Link to expense category
  final double amount;
  final BudgetPeriod period;

  Budget({
    String? id,
    required this.category,
    required this.amount,
    required this.period,
  })  : assert(amount >= 0, 'Amount must be non-negative'),
        // Enforce positive amount storage
        id = id ??
            DateTime.now()
                .millisecondsSinceEpoch
                .toString(); // Simple unique ID generation;

  @override
  List<Object?> get props => [id, category, amount, period];

  Budget copyWith({
    String? id,
    BudgetCategory? category,
    double? amount,
    BudgetPeriod? period,
  }) {
    return Budget(
      id: id ?? this.id,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      period: period ?? this.period,
    );
  }

  // --- JSON Serialization ---
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category.name, // Store enum name
      'amount': amount,
      'period': period.name, // Store enum name
    };
  }

  factory Budget.fromJson(Map<String, dynamic> json) {
    return Budget(
      id: json['id'] as String?, // Generate ID if missing
      category: BudgetCategory.values.byName(json['category'] as String),
      amount: (json['amount'] as num).toDouble(),
      period: BudgetPeriod.values.byName(json['period'] as String),
    );
  }
}
