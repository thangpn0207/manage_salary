import 'package:equatable/equatable.dart';

import '../core/constants/enums.dart';

/// Represents a budget set for a specific category over a period.
// ignore: must_be_immutable
class Budget extends Equatable {
  final String id;
  final BudgetCategory category;
  final double amount;
  final BudgetPeriod period;

  // Computed properties to track spending
  double currentSpending = 0.0; // Track current spending
  DateTime? lastUpdated; // Track when spending was last updated

  Budget({
    String? id,
    required this.category,
    required this.amount,
    required this.period,
    this.currentSpending = 0.0,
    this.lastUpdated,
  })  : assert(amount >= 0, 'Amount must be non-negative'),
        id = id ?? DateTime.now().millisecondsSinceEpoch.toString();

  // Get remaining budget
  double get remainingAmount => amount - currentSpending;

  // Get percentage spent
  double get spentPercentage => (currentSpending / amount).clamp(0.0, 1.0);

  // Check if over budget
  bool get isOverBudget => currentSpending > amount;

  // Check if nearing budget limit (>80% spent)
  bool get isNearingLimit => spentPercentage > 0.8 && !isOverBudget;

  @override
  List<Object?> get props => [id, category, amount, period, currentSpending, lastUpdated];

  Budget copyWith({
    String? id,
    BudgetCategory? category,
    double? amount,
    BudgetPeriod? period,
    double? currentSpending,
    DateTime? lastUpdated,
  }) {
    return Budget(
      id: id ?? this.id,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      period: period ?? this.period,
      currentSpending: currentSpending ?? this.currentSpending,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  // Update spending amount
  Budget updateSpending(double newSpending) {
    return copyWith(
      currentSpending: newSpending,
      lastUpdated: DateTime.now(),
    );
  }

  // Reset spending (e.g., at the start of a new period)
  Budget resetSpending() {
    return copyWith(
      currentSpending: 0.0,
      lastUpdated: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category.name,
      'amount': amount,
      'period': period.name,
      'currentSpending': currentSpending,
      'lastUpdated': lastUpdated?.toIso8601String(),
    };
  }

  factory Budget.fromJson(Map<String, dynamic> json) {
    return Budget(
      id: json['id'] as String?,
      category: BudgetCategory.values.byName(json['category'] as String),
      amount: (json['amount'] as num).toDouble(),
      period: BudgetPeriod.values.byName(json['period'] as String),
      currentSpending: (json['currentSpending'] as num?)?.toDouble() ?? 0.0,
      lastUpdated: json['lastUpdated'] != null 
          ? DateTime.parse(json['lastUpdated'] as String)
          : null,
    );
  }
}
