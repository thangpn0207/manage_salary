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

  static String m1(name) => "${name} removed";

  static String m2(name) => "${name} added successfully.";

  static String m3(name) =>
      "Are you sure you want to remove ${name} from this trip?";

  static String m4(category) => "${category} budget removed";

  static String m5(name) =>
      "Are you sure you want to remove the ${name} budget?";

  static String m6(number) => "Expenses ${number}";

  static String m7(name) => "Paid by ${name}";

  static String m8(name) => "Are you sure you want to delete ${name}?";

  static String m9(number) => "Trip Members (${number})";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "activityDeleted": m0,
    "activityNatureExpense": MessageLookupByLibrary.simpleMessage("Expense"),
    "activityNatureIncome": MessageLookupByLibrary.simpleMessage("Income"),
    "activityNatureLabel": MessageLookupByLibrary.simpleMessage(
      "Activity Nature",
    ),
    "activityRemoved": m1,
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
    "addActivitySuccess": m2,
    "addBudget": MessageLookupByLibrary.simpleMessage("Add Budget"),
    "addDeposit": MessageLookupByLibrary.simpleMessage("Add deposit"),
    "addExpenses": MessageLookupByLibrary.simpleMessage("Add Expense"),
    "addMember": MessageLookupByLibrary.simpleMessage("Add member"),
    "addMemberFirstEx": MessageLookupByLibrary.simpleMessage(
      "Add members first before creating expenses",
    ),
    "addMemberFirstNote": MessageLookupByLibrary.simpleMessage(
      "Add members first before creating notes",
    ),
    "addNewActivitySheetTitle": MessageLookupByLibrary.simpleMessage(
      "Add New Activity",
    ),
    "addNewExpense": MessageLookupByLibrary.simpleMessage("Add New Expense"),
    "addNewMember": MessageLookupByLibrary.simpleMessage("Add New Member"),
    "addRecurring": MessageLookupByLibrary.simpleMessage("Add Recurring"),
    "addRecurringDescription": MessageLookupByLibrary.simpleMessage(
      "Add recurring activities to automate your regular income and expenses",
    ),
    "added": MessageLookupByLibrary.simpleMessage("added"),
    "amount": MessageLookupByLibrary.simpleMessage("Amount"),
    "amountLabel": MessageLookupByLibrary.simpleMessage("Amount"),
    "amountMustBePositive": MessageLookupByLibrary.simpleMessage(
      "Amount must be greater than 0",
    ),
    "areYouSureDeleteMember": m3,
    "budget": MessageLookupByLibrary.simpleMessage("Budget"),
    "budgetAmount": MessageLookupByLibrary.simpleMessage("Budget Amount"),
    "budgetDetails": MessageLookupByLibrary.simpleMessage("Budget Details"),
    "budgetPeriodMonthly": MessageLookupByLibrary.simpleMessage("Monthly"),
    "budgetPeriodWeekly": MessageLookupByLibrary.simpleMessage("Weekly"),
    "budgetPeriodYearly": MessageLookupByLibrary.simpleMessage("Yearly"),
    "budgetRemoved": m4,
    "budgetSummary": MessageLookupByLibrary.simpleMessage("Budget Summary"),
    "cacheClearError": MessageLookupByLibrary.simpleMessage(
      "Error clearing cache.",
    ),
    "cacheClearedSuccess": MessageLookupByLibrary.simpleMessage(
      "Cache Cleared Successfully.",
    ),
    "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "cancelButton": MessageLookupByLibrary.simpleMessage("Cancel"),
    "category": MessageLookupByLibrary.simpleMessage("Category"),
    "changeButton": MessageLookupByLibrary.simpleMessage("Change"),
    "clearButton": MessageLookupByLibrary.simpleMessage("Clear"),
    "clearCache": MessageLookupByLibrary.simpleMessage("Clear Cache"),
    "confirmBudgetDeletion": m5,
    "confirmClearCacheContent": MessageLookupByLibrary.simpleMessage(
      "Are you sure? This will remove all stored activity data and might reset preferences.",
    ),
    "confirmClearCacheTitle": MessageLookupByLibrary.simpleMessage(
      "Confirm Clear Cache",
    ),
    "confirmDeletion": MessageLookupByLibrary.simpleMessage("Confirm Deletion"),
    "create": MessageLookupByLibrary.simpleMessage("Create"),
    "createFirstTrip": MessageLookupByLibrary.simpleMessage(
      "Create your first trip to get started",
    ),
    "createNewTrip": MessageLookupByLibrary.simpleMessage("Create New Trip"),
    "currency": MessageLookupByLibrary.simpleMessage("Currency"),
    "currentSpending": MessageLookupByLibrary.simpleMessage("Current Spending"),
    "customSplit": MessageLookupByLibrary.simpleMessage("Custom Split"),
    "customSplitAmount": MessageLookupByLibrary.simpleMessage(
      "Custom Split Amount",
    ),
    "customSplitDes": MessageLookupByLibrary.simpleMessage(
      "Set custom amounts for each member",
    ),
    "darkMode": MessageLookupByLibrary.simpleMessage("Dark mode"),
    "dashboard": MessageLookupByLibrary.simpleMessage("DashBoard"),
    "dateLabelPrefix": MessageLookupByLibrary.simpleMessage("Date: "),
    "delete": MessageLookupByLibrary.simpleMessage("Delete"),
    "deleteMember": MessageLookupByLibrary.simpleMessage("Delete Member"),
    "deleteTrip": MessageLookupByLibrary.simpleMessage("Delete Trip"),
    "deposit": MessageLookupByLibrary.simpleMessage("Deposit"),
    "deposits": MessageLookupByLibrary.simpleMessage("Deposits"),
    "description": MessageLookupByLibrary.simpleMessage(
      "Description (Optional)",
    ),
    "edit": MessageLookupByLibrary.simpleMessage("Edit"),
    "editBudget": MessageLookupByLibrary.simpleMessage("Edit Budget"),
    "editExpense": MessageLookupByLibrary.simpleMessage("Edit Expense"),
    "editRecurring": MessageLookupByLibrary.simpleMessage("Edit Recurring"),
    "editTrip": MessageLookupByLibrary.simpleMessage("Edit Trip"),
    "email": MessageLookupByLibrary.simpleMessage("Phone (Optional)"),
    "endDate": MessageLookupByLibrary.simpleMessage("End Date"),
    "enterValidNumber": MessageLookupByLibrary.simpleMessage(
      "Please enter a valid number",
    ),
    "equalSplit": MessageLookupByLibrary.simpleMessage("Equal Split"),
    "equalSplitDes": MessageLookupByLibrary.simpleMessage(
      "Split equally among all members",
    ),
    "expenseTitle": MessageLookupByLibrary.simpleMessage("Expense Title"),
    "expenses": MessageLookupByLibrary.simpleMessage("Expenses"),
    "expensesLength": m6,
    "fieldRequired": MessageLookupByLibrary.simpleMessage(
      "This field is required",
    ),
    "formValidationError": MessageLookupByLibrary.simpleMessage(
      "Please complete all fields correctly.",
    ),
    "frequency": MessageLookupByLibrary.simpleMessage("Frequency"),
    "frequencyBiWeekly": MessageLookupByLibrary.simpleMessage("Bi-Weekly"),
    "frequencyDaily": MessageLookupByLibrary.simpleMessage("Daily"),
    "frequencyMonthly": MessageLookupByLibrary.simpleMessage("Monthly"),
    "frequencyWeekly": MessageLookupByLibrary.simpleMessage("Weekly"),
    "frequencyYearly": MessageLookupByLibrary.simpleMessage("Yearly"),
    "income": MessageLookupByLibrary.simpleMessage("Income"),
    "isUsingGroupBudget": MessageLookupByLibrary.simpleMessage(
      "Using group budget",
    ),
    "language": MessageLookupByLibrary.simpleMessage("Language"),
    "manageBudgets": MessageLookupByLibrary.simpleMessage("Manage Budgets"),
    "manageRecurring": MessageLookupByLibrary.simpleMessage("Manage Recurring"),
    "member": MessageLookupByLibrary.simpleMessage("Member"),
    "memberBalances": MessageLookupByLibrary.simpleMessage("Member Balances"),
    "name": MessageLookupByLibrary.simpleMessage("Name"),
    "noBudgetsSet": MessageLookupByLibrary.simpleMessage("No budgets set"),
    "noChartData": MessageLookupByLibrary.simpleMessage(
      "No expense data for this period to display chart.",
    ),
    "noDatesSet": MessageLookupByLibrary.simpleMessage("No dates set"),
    "noDepositsYet": MessageLookupByLibrary.simpleMessage("No deposits yet"),
    "noEndDate": MessageLookupByLibrary.simpleMessage("No End Date"),
    "noExpenseActivities": MessageLookupByLibrary.simpleMessage(
      "No expense activities recorded yet.",
    ),
    "noExpenses": MessageLookupByLibrary.simpleMessage("No expenses yet"),
    "noIncomeActivities": MessageLookupByLibrary.simpleMessage(
      "No income activities recorded yet.",
    ),
    "noMembersYet": MessageLookupByLibrary.simpleMessage("No members yet"),
    "noNotesYet": MessageLookupByLibrary.simpleMessage("No notes yet"),
    "noRecurringActivities": MessageLookupByLibrary.simpleMessage(
      "No recurring activities",
    ),
    "noTripYet": MessageLookupByLibrary.simpleMessage("No trips yet"),
    "notes": MessageLookupByLibrary.simpleMessage("Notes"),
    "ofBudgetUsed": MessageLookupByLibrary.simpleMessage("of budget used"),
    "otherCategory": MessageLookupByLibrary.simpleMessage("Other"),
    "owes": MessageLookupByLibrary.simpleMessage("Owes"),
    "paid": MessageLookupByLibrary.simpleMessage("Paid"),
    "paidBy": m7,
    "period": MessageLookupByLibrary.simpleMessage("Period"),
    "pleaseEnterAmount": MessageLookupByLibrary.simpleMessage(
      "Please enter an amount",
    ),
    "pleaseEnterExpenseTitle": MessageLookupByLibrary.simpleMessage(
      "Please enter an expense title",
    ),
    "pleaseEnterTripTitle": MessageLookupByLibrary.simpleMessage(
      "Please enter a trip title",
    ),
    "remaining": MessageLookupByLibrary.simpleMessage("Remaining"),
    "remainingGroupDeposit": MessageLookupByLibrary.simpleMessage(
      "Remaining Group Deposit",
    ),
    "remove": MessageLookupByLibrary.simpleMessage("Remove"),
    "saveChanges": MessageLookupByLibrary.simpleMessage("Save Changes"),
    "selectDate": MessageLookupByLibrary.simpleMessage("Select Date"),
    "settings": MessageLookupByLibrary.simpleMessage("Settings"),
    "spent": MessageLookupByLibrary.simpleMessage("Spent"),
    "splitType": MessageLookupByLibrary.simpleMessage("Split Type"),
    "startDate": MessageLookupByLibrary.simpleMessage("Start Date"),
    "suggestedSettlements": MessageLookupByLibrary.simpleMessage(
      "Suggested Settlements",
    ),
    "summary": MessageLookupByLibrary.simpleMessage("Summary"),
    "sureDeleteTrip": m8,
    "tapToAddBudget": MessageLookupByLibrary.simpleMessage(
      "Tap the + button above to add your first budget",
    ),
    "title": MessageLookupByLibrary.simpleMessage("Title"),
    "titleDescriptionLabel": MessageLookupByLibrary.simpleMessage(
      "Title / Description",
    ),
    "totalBalance": MessageLookupByLibrary.simpleMessage("Total Balance"),
    "totalExpenses": MessageLookupByLibrary.simpleMessage("Total Expenses"),
    "totalTripCost": MessageLookupByLibrary.simpleMessage("Total Trip Cost"),
    "travelNotes": MessageLookupByLibrary.simpleMessage("Travel notes"),
    "tripDetail": MessageLookupByLibrary.simpleMessage("Trip Details"),
    "tripMember": m9,
    "tripTitle": MessageLookupByLibrary.simpleMessage("Trip Title"),
    "type": MessageLookupByLibrary.simpleMessage("Type"),
    "update": MessageLookupByLibrary.simpleMessage("Update"),
    "updated": MessageLookupByLibrary.simpleMessage("updated"),
  };
}
