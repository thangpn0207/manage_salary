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

  static String m6(month, amount) =>
      "Are you sure you want to finalize salary for ${month} with the amount of ${amount}?";

  static String m7(number) => "Expenses ${number}";

  static String m8(monthStr) => "ATTENDANCE & SALARY REPORT ${monthStr}";

  static String m9(name) => "Paid by ${name}";

  static String m10(name) => "Are you sure you want to delete ${name}?";

  static String m11(number) => "Trip Members (${number})";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "aboutApp": MessageLookupByLibrary.simpleMessage("About App"),
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
    "advanceAmount": MessageLookupByLibrary.simpleMessage("Salary Advance"),
    "advanceSalary": MessageLookupByLibrary.simpleMessage("Advance"),
    "advanceStat": MessageLookupByLibrary.simpleMessage("Advance"),
    "amount": MessageLookupByLibrary.simpleMessage("Amount"),
    "amountLabel": MessageLookupByLibrary.simpleMessage("Amount"),
    "amountMustBePositive": MessageLookupByLibrary.simpleMessage(
      "Amount must be greater than 0",
    ),
    "appVersion": MessageLookupByLibrary.simpleMessage("App Version"),
    "areYouSureDeleteMember": m3,
    "attendanceSheetTitle": MessageLookupByLibrary.simpleMessage(
      "Daily Check-in",
    ),
    "autoCalculationPreview": MessageLookupByLibrary.simpleMessage(
      "Auto-calculation preview:",
    ),
    "autoDailyRate": MessageLookupByLibrary.simpleMessage("Daily Rate"),
    "autoDeductRules": MessageLookupByLibrary.simpleMessage(
      "8% Social + 1.5% Health + 1% Unemp",
    ),
    "autoHourlyRate": MessageLookupByLibrary.simpleMessage("Hourly Rate"),
    "baseSalaryAmount": MessageLookupByLibrary.simpleMessage(
      "Base Salary Amount",
    ),
    "bonusMoney": MessageLookupByLibrary.simpleMessage("Bonus"),
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
    "checkInFull": MessageLookupByLibrary.simpleMessage("Full Day"),
    "checkInHalf": MessageLookupByLibrary.simpleMessage("Half Day"),
    "checkedInToday": MessageLookupByLibrary.simpleMessage("Checked in today"),
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
    "confirmFinalizeSalary": m6,
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
    "dailyOtPay": MessageLookupByLibrary.simpleMessage("OT Pay"),
    "dailyReminder": MessageLookupByLibrary.simpleMessage("Daily Reminder"),
    "dailyReminderDesc": MessageLookupByLibrary.simpleMessage(
      "Reminds you every day at 20:00",
    ),
    "dailyReminderDisabledMsg": MessageLookupByLibrary.simpleMessage(
      "Daily reminder disabled",
    ),
    "dailyReminderEnabledMsg": MessageLookupByLibrary.simpleMessage(
      "Daily reminder enabled",
    ),
    "dailyWage": MessageLookupByLibrary.simpleMessage("Daily Wage"),
    "darkMode": MessageLookupByLibrary.simpleMessage("Dark mode"),
    "dashboard": MessageLookupByLibrary.simpleMessage("DashBoard"),
    "dateLabelPrefix": MessageLookupByLibrary.simpleMessage("Date: "),
    "daysSuffix": MessageLookupByLibrary.simpleMessage("days"),
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
    "enableInsurance": MessageLookupByLibrary.simpleMessage(
      "Auto-deduct insurance (10.5%)",
    ),
    "endDate": MessageLookupByLibrary.simpleMessage("End Date"),
    "enterValidNumber": MessageLookupByLibrary.simpleMessage(
      "Please enter a valid number",
    ),
    "equalSplit": MessageLookupByLibrary.simpleMessage("Equal Split"),
    "equalSplitDes": MessageLookupByLibrary.simpleMessage(
      "Split equally among all members",
    ),
    "errorEmptyNote": MessageLookupByLibrary.simpleMessage(
      "Please enter a note",
    ),
    "estimatedDailyIncome": MessageLookupByLibrary.simpleMessage(
      "Estimated Daily Income",
    ),
    "estimatedSalary": MessageLookupByLibrary.simpleMessage("Estimated Salary"),
    "expenseTitle": MessageLookupByLibrary.simpleMessage("Expense Title"),
    "expenses": MessageLookupByLibrary.simpleMessage("Expenses"),
    "expensesLength": m7,
    "exportAdvanceColumn": MessageLookupByLibrary.simpleMessage("Advance"),
    "exportAdvancePayment": MessageLookupByLibrary.simpleMessage(
      "Advance Payment:",
    ),
    "exportAttendanceLog": MessageLookupByLibrary.simpleMessage(
      "ATTENDANCE LOG",
    ),
    "exportBaseSalary": MessageLookupByLibrary.simpleMessage("Base Salary:"),
    "exportBonus": MessageLookupByLibrary.simpleMessage("Bonus:"),
    "exportBonusColumn": MessageLookupByLibrary.simpleMessage("Bonus"),
    "exportDate": MessageLookupByLibrary.simpleMessage("Export Date:"),
    "exportDateColumn": MessageLookupByLibrary.simpleMessage("Date"),
    "exportEmptyLog": MessageLookupByLibrary.simpleMessage(
      "No attendance records found.",
    ),
    "exportExcel": MessageLookupByLibrary.simpleMessage("Export Excel"),
    "exportExcelDesc": MessageLookupByLibrary.simpleMessage("Export report"),
    "exportFooterDesc": MessageLookupByLibrary.simpleMessage(
      "Auto-generated report from Manage Salary - Available on Google Play Store",
    ),
    "exportFooterTitle": MessageLookupByLibrary.simpleMessage(
      "Report generated by Manage Salary - Expense & Salary App",
    ),
    "exportInsuranceDeduction": MessageLookupByLibrary.simpleMessage(
      "Insurance (10.5%):",
    ),
    "exportMonth": MessageLookupByLibrary.simpleMessage("Month:"),
    "exportNetSalary": MessageLookupByLibrary.simpleMessage(
      "NET ESTIMATED SALARY:",
    ),
    "exportNoteColumn": MessageLookupByLibrary.simpleMessage("Note"),
    "exportOtHoursColumn": MessageLookupByLibrary.simpleMessage("OT Hours"),
    "exportOtPay": MessageLookupByLibrary.simpleMessage("OT Pay:"),
    "exportPdf": MessageLookupByLibrary.simpleMessage("Export PDF"),
    "exportPdfDesc": MessageLookupByLibrary.simpleMessage(
      "Export report as PDF",
    ),
    "exportProfileSummary": MessageLookupByLibrary.simpleMessage(
      "SALARY PROFILE",
    ),
    "exportReport": MessageLookupByLibrary.simpleMessage("Export report"),
    "exportReportTitle": MessageLookupByLibrary.simpleMessage(
      "ATTENDANCE & SALARY REPORT",
    ),
    "exportReportTitlePdf": m8,
    "exportSalaryType": MessageLookupByLibrary.simpleMessage("Salary Type:"),
    "exportStandardDays": MessageLookupByLibrary.simpleMessage(
      "Standard Days:",
    ),
    "exportStatusColumn": MessageLookupByLibrary.simpleMessage("Status"),
    "exportSummary": MessageLookupByLibrary.simpleMessage("SUMMARY"),
    "exportTotalOtHours": MessageLookupByLibrary.simpleMessage(
      "Total OT Hours:",
    ),
    "exportTotalWorkDays": MessageLookupByLibrary.simpleMessage(
      "Total Work Days:",
    ),
    "fieldRequired": MessageLookupByLibrary.simpleMessage(
      "This field is required",
    ),
    "finalizeSalary": MessageLookupByLibrary.simpleMessage("Finalize Salary"),
    "formValidationError": MessageLookupByLibrary.simpleMessage(
      "Please complete all fields correctly.",
    ),
    "frequency": MessageLookupByLibrary.simpleMessage("Frequency"),
    "frequencyBiWeekly": MessageLookupByLibrary.simpleMessage("Bi-Weekly"),
    "frequencyDaily": MessageLookupByLibrary.simpleMessage("Daily"),
    "frequencyMonthly": MessageLookupByLibrary.simpleMessage("Monthly"),
    "frequencyWeekly": MessageLookupByLibrary.simpleMessage("Weekly"),
    "frequencyYearly": MessageLookupByLibrary.simpleMessage("Yearly"),
    "hoursSuffix": MessageLookupByLibrary.simpleMessage("hours"),
    "income": MessageLookupByLibrary.simpleMessage("Income"),
    "insuranceStat": MessageLookupByLibrary.simpleMessage("Insurance"),
    "isUsingGroupBudget": MessageLookupByLibrary.simpleMessage(
      "Using group budget",
    ),
    "language": MessageLookupByLibrary.simpleMessage("Language"),
    "leavePaid": MessageLookupByLibrary.simpleMessage("Paid Leave"),
    "leaveUnpaid": MessageLookupByLibrary.simpleMessage("Unpaid Leave"),
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
    "notCheckedInToday": MessageLookupByLibrary.simpleMessage(
      "Not checked in today",
    ),
    "noteToday": MessageLookupByLibrary.simpleMessage(
      "Note for today (optional)",
    ),
    "notes": MessageLookupByLibrary.simpleMessage("Notes"),
    "notifications": MessageLookupByLibrary.simpleMessage("Notifications"),
    "ofBudgetUsed": MessageLookupByLibrary.simpleMessage("of budget used"),
    "oneTapCheckIn": MessageLookupByLibrary.simpleMessage("1-Tap Check-in"),
    "otHoliday": MessageLookupByLibrary.simpleMessage("x3.0 Holiday"),
    "otHourlyRateDesc": MessageLookupByLibrary.simpleMessage(
      "Converted to OT hourly rate",
    ),
    "otHoursStat": MessageLookupByLibrary.simpleMessage("OT Hours"),
    "otNormalDay": MessageLookupByLibrary.simpleMessage("x1.5 Normal Day"),
    "otWeekend": MessageLookupByLibrary.simpleMessage("x2.0 Weekend"),
    "otherCategory": MessageLookupByLibrary.simpleMessage("Other"),
    "overtimeHours": MessageLookupByLibrary.simpleMessage("Overtime Hours"),
    "overtimeSection": MessageLookupByLibrary.simpleMessage("Overtime"),
    "owes": MessageLookupByLibrary.simpleMessage("Owes"),
    "paid": MessageLookupByLibrary.simpleMessage("Paid"),
    "paidBy": m9,
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
    "privacyPolicy": MessageLookupByLibrary.simpleMessage("Privacy Policy"),
    "privacyPolicyDesc": MessageLookupByLibrary.simpleMessage(
      "How we protect your data",
    ),
    "quickAttendanceSubtitle": MessageLookupByLibrary.simpleMessage(
      "Tap to check in",
    ),
    "quickCheckIn": MessageLookupByLibrary.simpleMessage("Quick Check-in"),
    "remaining": MessageLookupByLibrary.simpleMessage("Remaining"),
    "remainingGroupDeposit": MessageLookupByLibrary.simpleMessage(
      "Remaining Group Deposit",
    ),
    "remove": MessageLookupByLibrary.simpleMessage("Remove"),
    "salaryAndAttendance": MessageLookupByLibrary.simpleMessage(
      "Salary & Attendance",
    ),
    "salaryDaily": MessageLookupByLibrary.simpleMessage("Daily"),
    "salaryHourly": MessageLookupByLibrary.simpleMessage("Hourly"),
    "salaryMonthly": MessageLookupByLibrary.simpleMessage("Monthly"),
    "salaryProfile": MessageLookupByLibrary.simpleMessage("Salary Profile"),
    "salarySettingsTitle": MessageLookupByLibrary.simpleMessage(
      "Salary Settings",
    ),
    "salaryType": MessageLookupByLibrary.simpleMessage("Salary Type"),
    "saveAttendance": MessageLookupByLibrary.simpleMessage("Save Check-in"),
    "saveChanges": MessageLookupByLibrary.simpleMessage("Save Changes"),
    "selectDate": MessageLookupByLibrary.simpleMessage("Select Date"),
    "settings": MessageLookupByLibrary.simpleMessage("Settings"),
    "spent": MessageLookupByLibrary.simpleMessage("Spent"),
    "splitType": MessageLookupByLibrary.simpleMessage("Split Type"),
    "standardHoursPerDay": MessageLookupByLibrary.simpleMessage(
      "Standard Hours/Day",
    ),
    "standardWorkingDays": MessageLookupByLibrary.simpleMessage(
      "Standard Working Days/Month",
    ),
    "startDate": MessageLookupByLibrary.simpleMessage("Start Date"),
    "suggestedSettlements": MessageLookupByLibrary.simpleMessage(
      "Suggested Settlements",
    ),
    "summary": MessageLookupByLibrary.simpleMessage("Summary"),
    "sureDeleteTrip": m10,
    "tapToAddBudget": MessageLookupByLibrary.simpleMessage(
      "Tap the + button above to add your first budget",
    ),
    "termsOfService": MessageLookupByLibrary.simpleMessage("Terms of Service"),
    "title": MessageLookupByLibrary.simpleMessage("Title"),
    "titleDescriptionLabel": MessageLookupByLibrary.simpleMessage(
      "Title / Description",
    ),
    "totalBalance": MessageLookupByLibrary.simpleMessage("Total Balance"),
    "totalExpenses": MessageLookupByLibrary.simpleMessage("Total Expenses"),
    "totalTripCost": MessageLookupByLibrary.simpleMessage("Total Trip Cost"),
    "travelNotes": MessageLookupByLibrary.simpleMessage("Travel notes"),
    "tripDetail": MessageLookupByLibrary.simpleMessage("Trip Details"),
    "tripMember": m11,
    "tripTitle": MessageLookupByLibrary.simpleMessage("Trip Title"),
    "type": MessageLookupByLibrary.simpleMessage("Type"),
    "update": MessageLookupByLibrary.simpleMessage("Update"),
    "updated": MessageLookupByLibrary.simpleMessage("updated"),
    "workDate": MessageLookupByLibrary.simpleMessage("Date"),
    "workDay": MessageLookupByLibrary.simpleMessage("Full Day"),
    "workDaysStat": MessageLookupByLibrary.simpleMessage("Work Days"),
    "workHalfDay": MessageLookupByLibrary.simpleMessage("Half Day"),
    "workOff": MessageLookupByLibrary.simpleMessage("Off"),
    "workStatus": MessageLookupByLibrary.simpleMessage("Status"),
    "workType": MessageLookupByLibrary.simpleMessage("Work Type"),
  };
}
