
import 'package:equatable/equatable.dart';

import 'package:manage_salary/core/constants/enums.dart'; // Assuming ActivityType is here

/// Represents a budget set for a specific category over a period.
class Budget extends Equatable {
  final String id;
  final ActivityType category; // Link to expense category
  final double amount;
  final BudgetPeriod period; // e.g., Monthly, Weekly
  final DateTime startDate; // Usually the start of the period (e.g., 1st of month)
  // Optional: endDate can be calculated or stored
  // Optional: Add year/month fields for easier querying if needed

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
}

