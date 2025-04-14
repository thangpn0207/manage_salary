import 'package:flutter/material.dart';
import 'package:manage_salary/core/constants/enums.dart';
import 'package:manage_salary/core/locale/generated/l10n.dart';

// Helper function to get localized string for ActivityNature
String localizedActivityNature(BuildContext context, ActivityNature nature) {
  switch (nature) {
    case ActivityNature.income:
      return S.of(context).activityNatureIncome;
    case ActivityNature.expense:
      return S.of(context).activityNatureExpense;
  }
}
// Helper function to get localized string for BudgetPeriod
String localizedBudgetPeriod(BuildContext context, BudgetPeriod period) {
  switch (period) {
    case BudgetPeriod.weekly:
      return S.of(context).budgetPeriodWeekly;
    case BudgetPeriod.monthly:
      return S.of(context).budgetPeriodMonthly;
    case BudgetPeriod.yearly:
      return S.of(context).budgetPeriodYearly;
  }
}


// Helper function to get localized string for ActivityPaying
String localizedActivityPaying(BuildContext context, ActivityType type) {
  final s = S.of(context);

  switch (type) {
// === Expense Types ===
    case ActivityType.shopping:
      return s.activityTypeShopping;
    case ActivityType.foodAndDrinks:
      return s.activityTypeFoodAndDrinks;
    case ActivityType.rent:
      return s.activityTypeRent;
    case ActivityType.utilities:
      return s.activityTypeUtilities;
    case ActivityType.groceries:
      return s.activityTypeGroceries;
    case ActivityType.entertainment:
      return s.activityTypeEntertainment;
    case ActivityType.education:
      return s.activityTypeEducation;
    case ActivityType.healthcare:
      return s.activityTypeHealthcare;
    case ActivityType.travel:
      return s.activityTypeTravel;
    case ActivityType.expenseOther:
      // Use the specific key for "Other Expense" if available
      return s.activityTypeExpenseOther;

// === Income Types ===
    case ActivityType.salary:
      return s.activityTypeSalary;
    case ActivityType.freelance:
      // Assuming key exists: activityTypeFreelance
      return s.activityTypeFreelance;
    case ActivityType.investment:
      // Assuming key exists: activityTypeInvestment
      return s.activityTypeInvestment;
    case ActivityType.incomeOther:
      // Assuming key exists: activityTypeIncomeOther
      return s.activityTypeIncomeOther;

// Assuming a generic 'Other' key exists
  }
}
