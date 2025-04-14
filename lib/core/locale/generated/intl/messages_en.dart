// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(title) => "${title} deleted";

  static String m1(category) => "${category} budget removed";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "activityDeleted": m0,
    "activityNatureExpense": MessageLookupByLibrary.simpleMessage("Expense"),
    "activityNatureIncome": MessageLookupByLibrary.simpleMessage("Income"),
    "activityNatureLabel": MessageLookupByLibrary.simpleMessage(
      "Activity Nature",
    ),
    "activityTypeEducation": MessageLookupByLibrary.simpleMessage("Education"),
    "activityTypeEntertainment": MessageLookupByLibrary.simpleMessage(
      "Entertainment",
    ),
    "activityTypeExpenseOther": MessageLookupByLibrary.simpleMessage(
      "Other Expense",
    ),
    "activityTypeFoodAndDrinks": MessageLookupByLibrary.simpleMessage(
      "Food & Drinks",
    ),
    "activityTypeFreelance": MessageLookupByLibrary.simpleMessage("Freelance"),
    "activityTypeGroceries": MessageLookupByLibrary.simpleMessage("Groceries"),
    "activityTypeHealthcare": MessageLookupByLibrary.simpleMessage(
      "Healthcare",
    ),
    "activityTypeIncomeOther": MessageLookupByLibrary.simpleMessage(
      "Other Income",
    ),
    "activityTypeInvestment": MessageLookupByLibrary.simpleMessage(
      "Investment",
    ),
    "activityTypeLabel": MessageLookupByLibrary.simpleMessage("Activity Type"),
    "activityTypeOther": MessageLookupByLibrary.simpleMessage("Other"),
    "activityTypeRent": MessageLookupByLibrary.simpleMessage("Rent"),
    "activityTypeSalary": MessageLookupByLibrary.simpleMessage("Salary"),
    "activityTypeSavings": MessageLookupByLibrary.simpleMessage("Savings"),
    "activityTypeShopping": MessageLookupByLibrary.simpleMessage("Shopping"),
    "activityTypeTravel": MessageLookupByLibrary.simpleMessage("Travel"),
    "activityTypeUtilities": MessageLookupByLibrary.simpleMessage("Utilities"),
    "add": MessageLookupByLibrary.simpleMessage("Add"),
    "addActivity": MessageLookupByLibrary.simpleMessage("Add Activity"),
    "addActivityButton": MessageLookupByLibrary.simpleMessage("Add Activity"),
    "addBudget": MessageLookupByLibrary.simpleMessage("Add Budget"),
    "addNewActivitySheetTitle": MessageLookupByLibrary.simpleMessage(
      "Add New Activity",
    ),
    "amountLabel": MessageLookupByLibrary.simpleMessage("Amount"),
    "amountMustBePositive": MessageLookupByLibrary.simpleMessage(
      "Amount must be greater than 0",
    ),
    "budget": MessageLookupByLibrary.simpleMessage("Budget"),
    "budgetAmount": MessageLookupByLibrary.simpleMessage("Budget Amount"),
    "budgetDetails": MessageLookupByLibrary.simpleMessage("Budget Details"),
    "budgetPeriodMonthly": MessageLookupByLibrary.simpleMessage("Monthly"),
    "budgetPeriodWeekly": MessageLookupByLibrary.simpleMessage("Weekly"),
    "budgetPeriodYearly": MessageLookupByLibrary.simpleMessage("Yearly"),
    "budgetRemoved": m1,
    "budgetSummary": MessageLookupByLibrary.simpleMessage("Budget Summary"),
    "cacheClearError": MessageLookupByLibrary.simpleMessage(
      "Error clearing cache.",
    ),
    "cacheClearedSuccess": MessageLookupByLibrary.simpleMessage(
      "Cache Cleared Successfully.",
    ),
    "cancelButton": MessageLookupByLibrary.simpleMessage("Cancel"),
    "category": MessageLookupByLibrary.simpleMessage("Category"),
    "changeButton": MessageLookupByLibrary.simpleMessage("Change"),
    "clearButton": MessageLookupByLibrary.simpleMessage("Clear"),
    "clearCache": MessageLookupByLibrary.simpleMessage("Clear Cache"),
    "confirmClearCacheContent": MessageLookupByLibrary.simpleMessage(
      "Are you sure? This will remove all stored activity data and might reset preferences.",
    ),
    "confirmClearCacheTitle": MessageLookupByLibrary.simpleMessage(
      "Confirm Clear Cache",
    ),
    "confirmDeletion": MessageLookupByLibrary.simpleMessage("Confirm Deletion"),
    "currentSpending": MessageLookupByLibrary.simpleMessage("Current Spending"),
    "darkMode": MessageLookupByLibrary.simpleMessage("Dark mode"),
    "dashboard": MessageLookupByLibrary.simpleMessage("DashBoard"),
    "dateLabelPrefix": MessageLookupByLibrary.simpleMessage("Date: "),
    "editBudget": MessageLookupByLibrary.simpleMessage("Edit Budget"),
    "enterValidNumber": MessageLookupByLibrary.simpleMessage(
      "Please enter a valid number",
    ),
    "expenses": MessageLookupByLibrary.simpleMessage("Expenses"),
    "fieldRequired": MessageLookupByLibrary.simpleMessage(
      "This field is required",
    ),
    "formValidationError": MessageLookupByLibrary.simpleMessage(
      "Please complete all fields correctly.",
    ),
    "income": MessageLookupByLibrary.simpleMessage("Income"),
    "language": MessageLookupByLibrary.simpleMessage("Language"),
    "manageBudgets": MessageLookupByLibrary.simpleMessage("Manage Budgets"),
    "noBudgetsSet": MessageLookupByLibrary.simpleMessage("No budgets set"),
    "noChartData": MessageLookupByLibrary.simpleMessage(
      "No expense data for this period to display chart.",
    ),
    "noExpenseActivities": MessageLookupByLibrary.simpleMessage(
      "No expense activities recorded yet.",
    ),
    "noIncomeActivities": MessageLookupByLibrary.simpleMessage(
      "No income activities recorded yet.",
    ),
    "ofBudgetUsed": MessageLookupByLibrary.simpleMessage("of budget used"),
    "otherCategory": MessageLookupByLibrary.simpleMessage("Other"),
    "period": MessageLookupByLibrary.simpleMessage("Period"),
    "remaining": MessageLookupByLibrary.simpleMessage("Remaining"),
    "remove": MessageLookupByLibrary.simpleMessage("Remove"),
    "saveChanges": MessageLookupByLibrary.simpleMessage("Save Changes"),
    "settings": MessageLookupByLibrary.simpleMessage("Settings"),
    "spent": MessageLookupByLibrary.simpleMessage("Spent"),
    "tapToAddBudget": MessageLookupByLibrary.simpleMessage(
      "Tap the + button above to add your first budget",
    ),
    "titleDescriptionLabel": MessageLookupByLibrary.simpleMessage(
      "Title / Description",
    ),
    "totalBalance": MessageLookupByLibrary.simpleMessage("Total Balance"),
  };
}
