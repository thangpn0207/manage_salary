enum AuthStatus {
  authenticated,
  unauthenticated,
  unknown,
}

// Renamed ActivityPaying to ActivityType for clarity
enum ActivityType {
  // Expense types
  shopping,
  foodAndDrinks,
  rent,
  utilities,
  groceries,
  entertainment,
  education,
  healthcare,
  travel,
  expenseOther, // Specific 'other' for expenses

  // Income types
  salary,
  freelance,
  investment,
  incomeOther, // Specific 'other' for income

  // General/Neutral (can be used if needed, or map specific income/expense)
  // Maybe remove 'savings' as it's more a transfer/goal than income/expense?
  // Consider if 'savings' needs special handling
}

enum ActivityNature {
  income,
  expense,
  // Potentially 'transfer' if moving money between accounts
}

// Enum for Budgeting Periods
enum BudgetPeriod {
  weekly,
  monthly,
  yearly,
}

// Enum for Recurring Frequencies
enum RecurringFrequency {
  daily,
  weekly,
  biWeekly, // Every two weeks
  monthly,
  yearly,
}
