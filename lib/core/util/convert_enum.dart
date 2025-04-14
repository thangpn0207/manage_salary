  import 'package:manage_salary/core/constants/enums.dart';

ActivityType convertBudgetCategoryToActivityType(BudgetCategory budgetCategory) {

    switch (budgetCategory) {
      case BudgetCategory.shopping:
        return ActivityType.shopping;
      case BudgetCategory.foodAndDrinks:
        return ActivityType.foodAndDrinks;
      case BudgetCategory.rent:
        return ActivityType.rent;
      case BudgetCategory.utilities:
        return ActivityType.utilities;
      case BudgetCategory.groceries:
        return ActivityType.groceries;
      case BudgetCategory.entertainment:
        return ActivityType.entertainment;
      case BudgetCategory.education:
        return ActivityType.education;
      case BudgetCategory.healthcare:
        return ActivityType.healthcare;
      case BudgetCategory.travel:
        return ActivityType.travel;
      case BudgetCategory.expenseOther:
        return ActivityType.expenseOther;
    }
  }