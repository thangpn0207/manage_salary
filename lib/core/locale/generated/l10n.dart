// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name =
        (locale.countryCode?.isEmpty ?? false)
            ? locale.languageCode
            : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Total Balance`
  String get totalBalance {
    return Intl.message(
      'Total Balance',
      name: 'totalBalance',
      desc: '',
      args: [],
    );
  }

  /// `Income`
  String get income {
    return Intl.message('Income', name: 'income', desc: '', args: []);
  }

  /// `Expenses`
  String get expenses {
    return Intl.message('Expenses', name: 'expenses', desc: '', args: []);
  }

  /// `Add Activity`
  String get addActivity {
    return Intl.message(
      'Add Activity',
      name: 'addActivity',
      desc: '',
      args: [],
    );
  }

  /// `Dark mode`
  String get darkMode {
    return Intl.message('Dark mode', name: 'darkMode', desc: '', args: []);
  }

  /// `Language`
  String get language {
    return Intl.message('Language', name: 'language', desc: '', args: []);
  }

  /// `Clear Cache`
  String get clearCache {
    return Intl.message('Clear Cache', name: 'clearCache', desc: '', args: []);
  }

  /// `Settings`
  String get settings {
    return Intl.message('Settings', name: 'settings', desc: '', args: []);
  }

  /// `DashBoard`
  String get dashboard {
    return Intl.message('DashBoard', name: 'dashboard', desc: '', args: []);
  }

  /// `No income activities recorded yet.`
  String get noIncomeActivities {
    return Intl.message(
      'No income activities recorded yet.',
      name: 'noIncomeActivities',
      desc: '',
      args: [],
    );
  }

  /// `No expense activities recorded yet.`
  String get noExpenseActivities {
    return Intl.message(
      'No expense activities recorded yet.',
      name: 'noExpenseActivities',
      desc: '',
      args: [],
    );
  }

  /// `{title} deleted`
  String activityDeleted(Object title) {
    return Intl.message(
      '$title deleted',
      name: 'activityDeleted',
      desc: '',
      args: [title],
    );
  }

  /// `Confirm Clear Cache`
  String get confirmClearCacheTitle {
    return Intl.message(
      'Confirm Clear Cache',
      name: 'confirmClearCacheTitle',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure? This will remove all stored activity data and might reset preferences.`
  String get confirmClearCacheContent {
    return Intl.message(
      'Are you sure? This will remove all stored activity data and might reset preferences.',
      name: 'confirmClearCacheContent',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancelButton {
    return Intl.message('Cancel', name: 'cancelButton', desc: '', args: []);
  }

  /// `Clear`
  String get clearButton {
    return Intl.message('Clear', name: 'clearButton', desc: '', args: []);
  }

  /// `Cache Cleared Successfully.`
  String get cacheClearedSuccess {
    return Intl.message(
      'Cache Cleared Successfully.',
      name: 'cacheClearedSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Error clearing cache.`
  String get cacheClearError {
    return Intl.message(
      'Error clearing cache.',
      name: 'cacheClearError',
      desc: '',
      args: [],
    );
  }

  /// `Add New Activity`
  String get addNewActivitySheetTitle {
    return Intl.message(
      'Add New Activity',
      name: 'addNewActivitySheetTitle',
      desc: '',
      args: [],
    );
  }

  /// `Activity Nature`
  String get activityNatureLabel {
    return Intl.message(
      'Activity Nature',
      name: 'activityNatureLabel',
      desc: '',
      args: [],
    );
  }

  /// `Activity Type`
  String get activityTypeLabel {
    return Intl.message(
      'Activity Type',
      name: 'activityTypeLabel',
      desc: '',
      args: [],
    );
  }

  /// `Title / Description`
  String get titleDescriptionLabel {
    return Intl.message(
      'Title / Description',
      name: 'titleDescriptionLabel',
      desc: '',
      args: [],
    );
  }

  /// `Amount`
  String get amountLabel {
    return Intl.message('Amount', name: 'amountLabel', desc: '', args: []);
  }

  /// `Date: `
  String get dateLabelPrefix {
    return Intl.message('Date: ', name: 'dateLabelPrefix', desc: '', args: []);
  }

  /// `Change`
  String get changeButton {
    return Intl.message('Change', name: 'changeButton', desc: '', args: []);
  }

  /// `Add Activity`
  String get addActivityButton {
    return Intl.message(
      'Add Activity',
      name: 'addActivityButton',
      desc: '',
      args: [],
    );
  }

  /// `Please complete all fields correctly.`
  String get formValidationError {
    return Intl.message(
      'Please complete all fields correctly.',
      name: 'formValidationError',
      desc: '',
      args: [],
    );
  }

  /// `Income`
  String get activityNatureIncome {
    return Intl.message(
      'Income',
      name: 'activityNatureIncome',
      desc: '',
      args: [],
    );
  }

  /// `Expense`
  String get activityNatureExpense {
    return Intl.message(
      'Expense',
      name: 'activityNatureExpense',
      desc: '',
      args: [],
    );
  }

  /// `Salary`
  String get activityTypeSalary {
    return Intl.message(
      'Salary',
      name: 'activityTypeSalary',
      desc: '',
      args: [],
    );
  }

  /// `Shopping`
  String get activityTypeShopping {
    return Intl.message(
      'Shopping',
      name: 'activityTypeShopping',
      desc: '',
      args: [],
    );
  }

  /// `Food & Drinks`
  String get activityTypeFoodAndDrinks {
    return Intl.message(
      'Food & Drinks',
      name: 'activityTypeFoodAndDrinks',
      desc: '',
      args: [],
    );
  }

  /// `Utilities`
  String get activityTypeUtilities {
    return Intl.message(
      'Utilities',
      name: 'activityTypeUtilities',
      desc: '',
      args: [],
    );
  }

  /// `Rent`
  String get activityTypeRent {
    return Intl.message('Rent', name: 'activityTypeRent', desc: '', args: []);
  }

  /// `Groceries`
  String get activityTypeGroceries {
    return Intl.message(
      'Groceries',
      name: 'activityTypeGroceries',
      desc: '',
      args: [],
    );
  }

  /// `Entertainment`
  String get activityTypeEntertainment {
    return Intl.message(
      'Entertainment',
      name: 'activityTypeEntertainment',
      desc: '',
      args: [],
    );
  }

  /// `Education`
  String get activityTypeEducation {
    return Intl.message(
      'Education',
      name: 'activityTypeEducation',
      desc: '',
      args: [],
    );
  }

  /// `Healthcare`
  String get activityTypeHealthcare {
    return Intl.message(
      'Healthcare',
      name: 'activityTypeHealthcare',
      desc: '',
      args: [],
    );
  }

  /// `Travel`
  String get activityTypeTravel {
    return Intl.message(
      'Travel',
      name: 'activityTypeTravel',
      desc: '',
      args: [],
    );
  }

  /// `Savings`
  String get activityTypeSavings {
    return Intl.message(
      'Savings',
      name: 'activityTypeSavings',
      desc: '',
      args: [],
    );
  }

  /// `Other`
  String get activityTypeOther {
    return Intl.message('Other', name: 'activityTypeOther', desc: '', args: []);
  }

  /// `Other Expense`
  String get activityTypeExpenseOther {
    return Intl.message(
      'Other Expense',
      name: 'activityTypeExpenseOther',
      desc: '',
      args: [],
    );
  }

  /// `Freelance`
  String get activityTypeFreelance {
    return Intl.message(
      'Freelance',
      name: 'activityTypeFreelance',
      desc: '',
      args: [],
    );
  }

  /// `Investment`
  String get activityTypeInvestment {
    return Intl.message(
      'Investment',
      name: 'activityTypeInvestment',
      desc: '',
      args: [],
    );
  }

  /// `Other Income`
  String get activityTypeIncomeOther {
    return Intl.message(
      'Other Income',
      name: 'activityTypeIncomeOther',
      desc: '',
      args: [],
    );
  }

  /// `Other`
  String get otherCategory {
    return Intl.message('Other', name: 'otherCategory', desc: '', args: []);
  }

  /// `No expense data for this period to display chart.`
  String get noChartData {
    return Intl.message(
      'No expense data for this period to display chart.',
      name: 'noChartData',
      desc: '',
      args: [],
    );
  }

  /// `Add Budget`
  String get addBudget {
    return Intl.message('Add Budget', name: 'addBudget', desc: '', args: []);
  }

  /// `Edit Budget`
  String get editBudget {
    return Intl.message('Edit Budget', name: 'editBudget', desc: '', args: []);
  }

  /// `Category`
  String get category {
    return Intl.message('Category', name: 'category', desc: '', args: []);
  }

  /// `Period`
  String get period {
    return Intl.message('Period', name: 'period', desc: '', args: []);
  }

  /// `Budget Amount`
  String get budgetAmount {
    return Intl.message(
      'Budget Amount',
      name: 'budgetAmount',
      desc: '',
      args: [],
    );
  }

  /// `This field is required`
  String get fieldRequired {
    return Intl.message(
      'This field is required',
      name: 'fieldRequired',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid number`
  String get enterValidNumber {
    return Intl.message(
      'Please enter a valid number',
      name: 'enterValidNumber',
      desc: '',
      args: [],
    );
  }

  /// `Amount must be greater than 0`
  String get amountMustBePositive {
    return Intl.message(
      'Amount must be greater than 0',
      name: 'amountMustBePositive',
      desc: '',
      args: [],
    );
  }

  /// `Current Spending`
  String get currentSpending {
    return Intl.message(
      'Current Spending',
      name: 'currentSpending',
      desc: '',
      args: [],
    );
  }

  /// `of budget used`
  String get ofBudgetUsed {
    return Intl.message(
      'of budget used',
      name: 'ofBudgetUsed',
      desc: '',
      args: [],
    );
  }

  /// `Save Changes`
  String get saveChanges {
    return Intl.message(
      'Save Changes',
      name: 'saveChanges',
      desc: '',
      args: [],
    );
  }

  /// `Weekly`
  String get budgetPeriodWeekly {
    return Intl.message(
      'Weekly',
      name: 'budgetPeriodWeekly',
      desc: '',
      args: [],
    );
  }

  /// `Monthly`
  String get budgetPeriodMonthly {
    return Intl.message(
      'Monthly',
      name: 'budgetPeriodMonthly',
      desc: '',
      args: [],
    );
  }

  /// `Yearly`
  String get budgetPeriodYearly {
    return Intl.message(
      'Yearly',
      name: 'budgetPeriodYearly',
      desc: '',
      args: [],
    );
  }

  /// `Manage Budgets`
  String get manageBudgets {
    return Intl.message(
      'Manage Budgets',
      name: 'manageBudgets',
      desc: '',
      args: [],
    );
  }

  /// `Budget Summary`
  String get budgetSummary {
    return Intl.message(
      'Budget Summary',
      name: 'budgetSummary',
      desc: '',
      args: [],
    );
  }

  /// `Budget Details`
  String get budgetDetails {
    return Intl.message(
      'Budget Details',
      name: 'budgetDetails',
      desc: '',
      args: [],
    );
  }

  /// `Add`
  String get add {
    return Intl.message('Add', name: 'add', desc: '', args: []);
  }

  /// `Budget`
  String get budget {
    return Intl.message('Budget', name: 'budget', desc: '', args: []);
  }

  /// `Spent`
  String get spent {
    return Intl.message('Spent', name: 'spent', desc: '', args: []);
  }

  /// `Remaining`
  String get remaining {
    return Intl.message('Remaining', name: 'remaining', desc: '', args: []);
  }

  /// `No budgets set`
  String get noBudgetsSet {
    return Intl.message(
      'No budgets set',
      name: 'noBudgetsSet',
      desc: '',
      args: [],
    );
  }

  /// `Tap the + button above to add your first budget`
  String get tapToAddBudget {
    return Intl.message(
      'Tap the + button above to add your first budget',
      name: 'tapToAddBudget',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Deletion`
  String get confirmDeletion {
    return Intl.message(
      'Confirm Deletion',
      name: 'confirmDeletion',
      desc: '',
      args: [],
    );
  }

  /// `Remove`
  String get remove {
    return Intl.message('Remove', name: 'remove', desc: '', args: []);
  }

  /// `{category} budget removed`
  String budgetRemoved(Object category) {
    return Intl.message(
      '$category budget removed',
      name: 'budgetRemoved',
      desc: '',
      args: [category],
    );
  }

  /// `Manage Recurring`
  String get manageRecurring {
    return Intl.message(
      'Manage Recurring',
      name: 'manageRecurring',
      desc: '',
      args: [],
    );
  }

  /// `Add Recurring`
  String get addRecurring {
    return Intl.message(
      'Add Recurring',
      name: 'addRecurring',
      desc: '',
      args: [],
    );
  }

  /// `Edit Recurring`
  String get editRecurring {
    return Intl.message(
      'Edit Recurring',
      name: 'editRecurring',
      desc: '',
      args: [],
    );
  }

  /// `Title`
  String get title {
    return Intl.message('Title', name: 'title', desc: '', args: []);
  }

  /// `Amount`
  String get amount {
    return Intl.message('Amount', name: 'amount', desc: '', args: []);
  }

  /// `Type`
  String get type {
    return Intl.message('Type', name: 'type', desc: '', args: []);
  }

  /// `Frequency`
  String get frequency {
    return Intl.message('Frequency', name: 'frequency', desc: '', args: []);
  }

  /// `Start Date`
  String get startDate {
    return Intl.message('Start Date', name: 'startDate', desc: '', args: []);
  }

  /// `End Date`
  String get endDate {
    return Intl.message('End Date', name: 'endDate', desc: '', args: []);
  }

  /// `No End Date`
  String get noEndDate {
    return Intl.message('No End Date', name: 'noEndDate', desc: '', args: []);
  }

  /// `Daily`
  String get frequencyDaily {
    return Intl.message('Daily', name: 'frequencyDaily', desc: '', args: []);
  }

  /// `Weekly`
  String get frequencyWeekly {
    return Intl.message('Weekly', name: 'frequencyWeekly', desc: '', args: []);
  }

  /// `Bi-Weekly`
  String get frequencyBiWeekly {
    return Intl.message(
      'Bi-Weekly',
      name: 'frequencyBiWeekly',
      desc: '',
      args: [],
    );
  }

  /// `Monthly`
  String get frequencyMonthly {
    return Intl.message(
      'Monthly',
      name: 'frequencyMonthly',
      desc: '',
      args: [],
    );
  }

  /// `Yearly`
  String get frequencyYearly {
    return Intl.message('Yearly', name: 'frequencyYearly', desc: '', args: []);
  }

  /// `No recurring activities`
  String get noRecurringActivities {
    return Intl.message(
      'No recurring activities',
      name: 'noRecurringActivities',
      desc: '',
      args: [],
    );
  }

  /// `Add recurring activities to automate your regular income and expenses`
  String get addRecurringDescription {
    return Intl.message(
      'Add recurring activities to automate your regular income and expenses',
      name: 'addRecurringDescription',
      desc: '',
      args: [],
    );
  }

  /// `added`
  String get added {
    return Intl.message('added', name: 'added', desc: '', args: []);
  }

  /// `updated`
  String get updated {
    return Intl.message('updated', name: 'updated', desc: '', args: []);
  }

  /// `{name} removed`
  String activityRemoved(Object name) {
    return Intl.message(
      '$name removed',
      name: 'activityRemoved',
      desc: '',
      args: [name],
    );
  }

  /// `Are you sure you want to remove the {name} budget?`
  String confirmBudgetDeletion(Object name) {
    return Intl.message(
      'Are you sure you want to remove the $name budget?',
      name: 'confirmBudgetDeletion',
      desc: '',
      args: [name],
    );
  }

  /// `Currency`
  String get currency {
    return Intl.message('Currency', name: 'currency', desc: '', args: []);
  }

  /// `{name} added successfully.`
  String addActivitySuccess(Object name) {
    return Intl.message(
      '$name added successfully.',
      name: 'addActivitySuccess',
      desc: '',
      args: [name],
    );
  }

  /// `Travel notes`
  String get travelNotes {
    return Intl.message(
      'Travel notes',
      name: 'travelNotes',
      desc: '',
      args: [],
    );
  }

  /// `No trips yet`
  String get noTripYet {
    return Intl.message('No trips yet', name: 'noTripYet', desc: '', args: []);
  }

  /// `Create your first trip to get started`
  String get createFirstTrip {
    return Intl.message(
      'Create your first trip to get started',
      name: 'createFirstTrip',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get edit {
    return Intl.message('Edit', name: 'edit', desc: '', args: []);
  }

  /// `Delete`
  String get delete {
    return Intl.message('Delete', name: 'delete', desc: '', args: []);
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Update`
  String get update {
    return Intl.message('Update', name: 'update', desc: '', args: []);
  }

  /// `Create`
  String get create {
    return Intl.message('Create', name: 'create', desc: '', args: []);
  }

  /// `No dates set`
  String get noDatesSet {
    return Intl.message('No dates set', name: 'noDatesSet', desc: '', args: []);
  }

  /// `Delete Trip`
  String get deleteTrip {
    return Intl.message('Delete Trip', name: 'deleteTrip', desc: '', args: []);
  }

  /// `Are you sure you want to delete {name}?`
  String sureDeleteTrip(Object name) {
    return Intl.message(
      'Are you sure you want to delete $name?',
      name: 'sureDeleteTrip',
      desc: '',
      args: [name],
    );
  }

  /// `Edit Trip`
  String get editTrip {
    return Intl.message('Edit Trip', name: 'editTrip', desc: '', args: []);
  }

  /// `Create New Trip`
  String get createNewTrip {
    return Intl.message(
      'Create New Trip',
      name: 'createNewTrip',
      desc: '',
      args: [],
    );
  }

  /// `Trip Title`
  String get tripTitle {
    return Intl.message('Trip Title', name: 'tripTitle', desc: '', args: []);
  }

  /// `Please enter a trip title`
  String get pleaseEnterTripTitle {
    return Intl.message(
      'Please enter a trip title',
      name: 'pleaseEnterTripTitle',
      desc: '',
      args: [],
    );
  }

  /// `Description (Optional)`
  String get description {
    return Intl.message(
      'Description (Optional)',
      name: 'description',
      desc: '',
      args: [],
    );
  }

  /// `Select Date`
  String get selectDate {
    return Intl.message('Select Date', name: 'selectDate', desc: '', args: []);
  }

  /// `Trip Details`
  String get tripDetail {
    return Intl.message('Trip Details', name: 'tripDetail', desc: '', args: []);
  }

  /// `Member`
  String get member {
    return Intl.message('Member', name: 'member', desc: '', args: []);
  }

  /// `Notes`
  String get notes {
    return Intl.message('Notes', name: 'notes', desc: '', args: []);
  }

  /// `Summary`
  String get summary {
    return Intl.message('Summary', name: 'summary', desc: '', args: []);
  }

  /// `No members yet`
  String get noMembersYet {
    return Intl.message(
      'No members yet',
      name: 'noMembersYet',
      desc: '',
      args: [],
    );
  }

  /// `Add member`
  String get addMember {
    return Intl.message('Add member', name: 'addMember', desc: '', args: []);
  }

  /// `Trip Members ({number})`
  String tripMember(Object number) {
    return Intl.message(
      'Trip Members ($number)',
      name: 'tripMember',
      desc: '',
      args: [number],
    );
  }

  /// `Delete Member`
  String get deleteMember {
    return Intl.message(
      'Delete Member',
      name: 'deleteMember',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to remove {name} from this trip?`
  String areYouSureDeleteMember(Object name) {
    return Intl.message(
      'Are you sure you want to remove $name from this trip?',
      name: 'areYouSureDeleteMember',
      desc: '',
      args: [name],
    );
  }

  /// `Add New Member`
  String get addNewMember {
    return Intl.message(
      'Add New Member',
      name: 'addNewMember',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message('Name', name: 'name', desc: '', args: []);
  }

  /// `Phone (Optional)`
  String get email {
    return Intl.message('Phone (Optional)', name: 'email', desc: '', args: []);
  }

  /// `Add members first before creating expenses`
  String get addMemberFirstEx {
    return Intl.message(
      'Add members first before creating expenses',
      name: 'addMemberFirstEx',
      desc: '',
      args: [],
    );
  }

  /// `No expenses yet`
  String get noExpenses {
    return Intl.message(
      'No expenses yet',
      name: 'noExpenses',
      desc: '',
      args: [],
    );
  }

  /// `Add Expense`
  String get addExpenses {
    return Intl.message('Add Expense', name: 'addExpenses', desc: '', args: []);
  }

  /// `Total Expenses`
  String get totalExpenses {
    return Intl.message(
      'Total Expenses',
      name: 'totalExpenses',
      desc: '',
      args: [],
    );
  }

  /// `Expenses {number}`
  String expensesLength(Object number) {
    return Intl.message(
      'Expenses $number',
      name: 'expensesLength',
      desc: '',
      args: [number],
    );
  }

  /// `Paid by {name}`
  String paidBy(Object name) {
    return Intl.message(
      'Paid by $name',
      name: 'paidBy',
      desc: '',
      args: [name],
    );
  }

  /// `Add members first before creating notes`
  String get addMemberFirstNote {
    return Intl.message(
      'Add members first before creating notes',
      name: 'addMemberFirstNote',
      desc: '',
      args: [],
    );
  }

  /// `No notes yet`
  String get noNotesYet {
    return Intl.message('No notes yet', name: 'noNotesYet', desc: '', args: []);
  }

  /// `Edit Expense`
  String get editExpense {
    return Intl.message(
      'Edit Expense',
      name: 'editExpense',
      desc: '',
      args: [],
    );
  }

  /// `Add New Expense`
  String get addNewExpense {
    return Intl.message(
      'Add New Expense',
      name: 'addNewExpense',
      desc: '',
      args: [],
    );
  }

  /// `Expense Title`
  String get expenseTitle {
    return Intl.message(
      'Expense Title',
      name: 'expenseTitle',
      desc: '',
      args: [],
    );
  }

  /// `Please enter an expense title`
  String get pleaseEnterExpenseTitle {
    return Intl.message(
      'Please enter an expense title',
      name: 'pleaseEnterExpenseTitle',
      desc: '',
      args: [],
    );
  }

  /// `Please enter an amount`
  String get pleaseEnterAmount {
    return Intl.message(
      'Please enter an amount',
      name: 'pleaseEnterAmount',
      desc: '',
      args: [],
    );
  }

  /// `Using group budget`
  String get isUsingGroupBudget {
    return Intl.message(
      'Using group budget',
      name: 'isUsingGroupBudget',
      desc: '',
      args: [],
    );
  }

  /// `Split Type`
  String get splitType {
    return Intl.message('Split Type', name: 'splitType', desc: '', args: []);
  }

  /// `Equal Split`
  String get equalSplit {
    return Intl.message('Equal Split', name: 'equalSplit', desc: '', args: []);
  }

  /// `Split equally among all members`
  String get equalSplitDes {
    return Intl.message(
      'Split equally among all members',
      name: 'equalSplitDes',
      desc: '',
      args: [],
    );
  }

  /// `Custom Split`
  String get customSplit {
    return Intl.message(
      'Custom Split',
      name: 'customSplit',
      desc: '',
      args: [],
    );
  }

  /// `Set custom amounts for each member`
  String get customSplitDes {
    return Intl.message(
      'Set custom amounts for each member',
      name: 'customSplitDes',
      desc: '',
      args: [],
    );
  }

  /// `Custom Split Amount`
  String get customSplitAmount {
    return Intl.message(
      'Custom Split Amount',
      name: 'customSplitAmount',
      desc: '',
      args: [],
    );
  }

  /// `Deposit`
  String get deposit {
    return Intl.message('Deposit', name: 'deposit', desc: '', args: []);
  }

  /// `Add deposit`
  String get addDeposit {
    return Intl.message('Add deposit', name: 'addDeposit', desc: '', args: []);
  }

  /// `No deposits yet`
  String get noDepositsYet {
    return Intl.message(
      'No deposits yet',
      name: 'noDepositsYet',
      desc: '',
      args: [],
    );
  }

  /// `Deposits`
  String get deposits {
    return Intl.message('Deposits', name: 'deposits', desc: '', args: []);
  }

  /// `Remaining Group Deposit`
  String get remainingGroupDeposit {
    return Intl.message(
      'Remaining Group Deposit',
      name: 'remainingGroupDeposit',
      desc: '',
      args: [],
    );
  }

  /// `Member Balances`
  String get memberBalances {
    return Intl.message(
      'Member Balances',
      name: 'memberBalances',
      desc: '',
      args: [],
    );
  }

  /// `Paid`
  String get paid {
    return Intl.message('Paid', name: 'paid', desc: '', args: []);
  }

  /// `Owes`
  String get owes {
    return Intl.message('Owes', name: 'owes', desc: '', args: []);
  }

  /// `Total Trip Cost`
  String get totalTripCost {
    return Intl.message(
      'Total Trip Cost',
      name: 'totalTripCost',
      desc: '',
      args: [],
    );
  }

  /// `Suggested Settlements`
  String get suggestedSettlements {
    return Intl.message(
      'Suggested Settlements',
      name: 'suggestedSettlements',
      desc: '',
      args: [],
    );
  }

  /// `x1.5 Normal Day`
  String get otNormalDay {
    return Intl.message(
      'x1.5 Normal Day',
      name: 'otNormalDay',
      desc: '',
      args: [],
    );
  }

  /// `x2.0 Weekend`
  String get otWeekend {
    return Intl.message('x2.0 Weekend', name: 'otWeekend', desc: '', args: []);
  }

  /// `x3.0 Holiday`
  String get otHoliday {
    return Intl.message('x3.0 Holiday', name: 'otHoliday', desc: '', args: []);
  }

  /// `Note for today (optional)`
  String get noteToday {
    return Intl.message(
      'Note for today (optional)',
      name: 'noteToday',
      desc: '',
      args: [],
    );
  }

  /// `8% Social + 1.5% Health + 1% Unemp`
  String get autoDeductRules {
    return Intl.message(
      '8% Social + 1.5% Health + 1% Unemp',
      name: 'autoDeductRules',
      desc: '',
      args: [],
    );
  }

  /// `days`
  String get daysSuffix {
    return Intl.message('days', name: 'daysSuffix', desc: '', args: []);
  }

  /// `hours`
  String get hoursSuffix {
    return Intl.message('hours', name: 'hoursSuffix', desc: '', args: []);
  }

  /// `Auto-calculation preview:`
  String get autoCalculationPreview {
    return Intl.message(
      'Auto-calculation preview:',
      name: 'autoCalculationPreview',
      desc: '',
      args: [],
    );
  }

  /// `Salary & Attendance`
  String get salaryAndAttendance {
    return Intl.message(
      'Salary & Attendance',
      name: 'salaryAndAttendance',
      desc: '',
      args: [],
    );
  }

  /// `1-Tap Check-in`
  String get oneTapCheckIn {
    return Intl.message(
      '1-Tap Check-in',
      name: 'oneTapCheckIn',
      desc: '',
      args: [],
    );
  }

  /// `Advance`
  String get advanceStat {
    return Intl.message('Advance', name: 'advanceStat', desc: '', args: []);
  }

  /// `Daily Check-in`
  String get attendanceSheetTitle {
    return Intl.message(
      'Daily Check-in',
      name: 'attendanceSheetTitle',
      desc: '',
      args: [],
    );
  }

  /// `Date`
  String get workDate {
    return Intl.message('Date', name: 'workDate', desc: '', args: []);
  }

  /// `Work Type`
  String get workType {
    return Intl.message('Work Type', name: 'workType', desc: '', args: []);
  }

  /// `Full Day`
  String get workDay {
    return Intl.message('Full Day', name: 'workDay', desc: '', args: []);
  }

  /// `Half Day`
  String get workHalfDay {
    return Intl.message('Half Day', name: 'workHalfDay', desc: '', args: []);
  }

  /// `Off`
  String get workOff {
    return Intl.message('Off', name: 'workOff', desc: '', args: []);
  }

  /// `Overtime Hours`
  String get overtimeHours {
    return Intl.message(
      'Overtime Hours',
      name: 'overtimeHours',
      desc: '',
      args: [],
    );
  }

  /// `Salary Advance`
  String get advanceAmount {
    return Intl.message(
      'Salary Advance',
      name: 'advanceAmount',
      desc: '',
      args: [],
    );
  }

  /// `Save Check-in`
  String get saveAttendance {
    return Intl.message(
      'Save Check-in',
      name: 'saveAttendance',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a note`
  String get errorEmptyNote {
    return Intl.message(
      'Please enter a note',
      name: 'errorEmptyNote',
      desc: '',
      args: [],
    );
  }

  /// `Salary Settings`
  String get salarySettingsTitle {
    return Intl.message(
      'Salary Settings',
      name: 'salarySettingsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Salary Type`
  String get salaryType {
    return Intl.message('Salary Type', name: 'salaryType', desc: '', args: []);
  }

  /// `Monthly`
  String get salaryMonthly {
    return Intl.message('Monthly', name: 'salaryMonthly', desc: '', args: []);
  }

  /// `Hourly`
  String get salaryHourly {
    return Intl.message('Hourly', name: 'salaryHourly', desc: '', args: []);
  }

  /// `Daily`
  String get salaryDaily {
    return Intl.message('Daily', name: 'salaryDaily', desc: '', args: []);
  }

  /// `Base Salary Amount`
  String get baseSalaryAmount {
    return Intl.message(
      'Base Salary Amount',
      name: 'baseSalaryAmount',
      desc: '',
      args: [],
    );
  }

  /// `Standard Working Days/Month`
  String get standardWorkingDays {
    return Intl.message(
      'Standard Working Days/Month',
      name: 'standardWorkingDays',
      desc: '',
      args: [],
    );
  }

  /// `Standard Hours/Day`
  String get standardHoursPerDay {
    return Intl.message(
      'Standard Hours/Day',
      name: 'standardHoursPerDay',
      desc: '',
      args: [],
    );
  }

  /// `Daily Rate`
  String get autoDailyRate {
    return Intl.message(
      'Daily Rate',
      name: 'autoDailyRate',
      desc: '',
      args: [],
    );
  }

  /// `Hourly Rate`
  String get autoHourlyRate {
    return Intl.message(
      'Hourly Rate',
      name: 'autoHourlyRate',
      desc: '',
      args: [],
    );
  }

  /// `Converted to OT hourly rate`
  String get otHourlyRateDesc {
    return Intl.message(
      'Converted to OT hourly rate',
      name: 'otHourlyRateDesc',
      desc: '',
      args: [],
    );
  }

  /// `Auto-deduct insurance (10.5%)`
  String get enableInsurance {
    return Intl.message(
      'Auto-deduct insurance (10.5%)',
      name: 'enableInsurance',
      desc: '',
      args: [],
    );
  }

  /// `Daily reminder enabled`
  String get dailyReminderEnabledMsg {
    return Intl.message(
      'Daily reminder enabled',
      name: 'dailyReminderEnabledMsg',
      desc: '',
      args: [],
    );
  }

  /// `Daily reminder disabled`
  String get dailyReminderDisabledMsg {
    return Intl.message(
      'Daily reminder disabled',
      name: 'dailyReminderDisabledMsg',
      desc: '',
      args: [],
    );
  }

  /// `Daily Reminder`
  String get dailyReminder {
    return Intl.message(
      'Daily Reminder',
      name: 'dailyReminder',
      desc: '',
      args: [],
    );
  }

  /// `Reminds you every day at 20:00`
  String get dailyReminderDesc {
    return Intl.message(
      'Reminds you every day at 20:00',
      name: 'dailyReminderDesc',
      desc: '',
      args: [],
    );
  }

  /// `About App`
  String get aboutApp {
    return Intl.message('About App', name: 'aboutApp', desc: '', args: []);
  }

  /// `Privacy Policy`
  String get privacyPolicy {
    return Intl.message(
      'Privacy Policy',
      name: 'privacyPolicy',
      desc: '',
      args: [],
    );
  }

  /// `How we protect your data`
  String get privacyPolicyDesc {
    return Intl.message(
      'How we protect your data',
      name: 'privacyPolicyDesc',
      desc: '',
      args: [],
    );
  }

  /// `Terms of Service`
  String get termsOfService {
    return Intl.message(
      'Terms of Service',
      name: 'termsOfService',
      desc: '',
      args: [],
    );
  }

  /// `App Version`
  String get appVersion {
    return Intl.message('App Version', name: 'appVersion', desc: '', args: []);
  }

  /// `Export report`
  String get exportExcelDesc {
    return Intl.message(
      'Export report',
      name: 'exportExcelDesc',
      desc: '',
      args: [],
    );
  }

  /// `Export report`
  String get exportReport {
    return Intl.message(
      'Export report',
      name: 'exportReport',
      desc: '',
      args: [],
    );
  }

  /// `Salary Profile`
  String get salaryProfile {
    return Intl.message(
      'Salary Profile',
      name: 'salaryProfile',
      desc: '',
      args: [],
    );
  }

  /// `Estimated Salary`
  String get estimatedSalary {
    return Intl.message(
      'Estimated Salary',
      name: 'estimatedSalary',
      desc: '',
      args: [],
    );
  }

  /// `Work Days`
  String get workDaysStat {
    return Intl.message('Work Days', name: 'workDaysStat', desc: '', args: []);
  }

  /// `OT Hours`
  String get otHoursStat {
    return Intl.message('OT Hours', name: 'otHoursStat', desc: '', args: []);
  }

  /// `Insurance`
  String get insuranceStat {
    return Intl.message('Insurance', name: 'insuranceStat', desc: '', args: []);
  }

  /// `Finalize Salary`
  String get finalizeSalary {
    return Intl.message(
      'Finalize Salary',
      name: 'finalizeSalary',
      desc: '',
      args: [],
    );
  }

  /// `Quick Check-in`
  String get quickCheckIn {
    return Intl.message(
      'Quick Check-in',
      name: 'quickCheckIn',
      desc: '',
      args: [],
    );
  }

  /// `Full Day`
  String get checkInFull {
    return Intl.message('Full Day', name: 'checkInFull', desc: '', args: []);
  }

  /// `Half Day`
  String get checkInHalf {
    return Intl.message('Half Day', name: 'checkInHalf', desc: '', args: []);
  }

  /// `Paid Leave`
  String get leavePaid {
    return Intl.message('Paid Leave', name: 'leavePaid', desc: '', args: []);
  }

  /// `Status`
  String get workStatus {
    return Intl.message('Status', name: 'workStatus', desc: '', args: []);
  }

  /// `Unpaid Leave`
  String get leaveUnpaid {
    return Intl.message(
      'Unpaid Leave',
      name: 'leaveUnpaid',
      desc: '',
      args: [],
    );
  }

  /// `Overtime`
  String get overtimeSection {
    return Intl.message(
      'Overtime',
      name: 'overtimeSection',
      desc: '',
      args: [],
    );
  }

  /// `Advance`
  String get advanceSalary {
    return Intl.message('Advance', name: 'advanceSalary', desc: '', args: []);
  }

  /// `Bonus`
  String get bonusMoney {
    return Intl.message('Bonus', name: 'bonusMoney', desc: '', args: []);
  }

  /// `Estimated Daily Income`
  String get estimatedDailyIncome {
    return Intl.message(
      'Estimated Daily Income',
      name: 'estimatedDailyIncome',
      desc: '',
      args: [],
    );
  }

  /// `Daily Wage`
  String get dailyWage {
    return Intl.message('Daily Wage', name: 'dailyWage', desc: '', args: []);
  }

  /// `OT Pay`
  String get dailyOtPay {
    return Intl.message('OT Pay', name: 'dailyOtPay', desc: '', args: []);
  }

  /// `Notifications`
  String get notifications {
    return Intl.message(
      'Notifications',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `Checked in today`
  String get checkedInToday {
    return Intl.message(
      'Checked in today',
      name: 'checkedInToday',
      desc: '',
      args: [],
    );
  }

  /// `Not checked in today`
  String get notCheckedInToday {
    return Intl.message(
      'Not checked in today',
      name: 'notCheckedInToday',
      desc: '',
      args: [],
    );
  }

  /// `Tap to check in`
  String get quickAttendanceSubtitle {
    return Intl.message(
      'Tap to check in',
      name: 'quickAttendanceSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Export PDF`
  String get exportPdf {
    return Intl.message('Export PDF', name: 'exportPdf', desc: '', args: []);
  }

  /// `Export report as PDF`
  String get exportPdfDesc {
    return Intl.message(
      'Export report as PDF',
      name: 'exportPdfDesc',
      desc: '',
      args: [],
    );
  }

  /// `Export Excel`
  String get exportExcel {
    return Intl.message(
      'Export Excel',
      name: 'exportExcel',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to finalize salary for {month} with the amount of {amount}?`
  String confirmFinalizeSalary(String month, String amount) {
    return Intl.message(
      'Are you sure you want to finalize salary for $month with the amount of $amount?',
      name: 'confirmFinalizeSalary',
      desc: '',
      args: [month, amount],
    );
  }

  /// `ATTENDANCE & SALARY REPORT`
  String get exportReportTitle {
    return Intl.message(
      'ATTENDANCE & SALARY REPORT',
      name: 'exportReportTitle',
      desc: '',
      args: [],
    );
  }

  /// `Month:`
  String get exportMonth {
    return Intl.message('Month:', name: 'exportMonth', desc: '', args: []);
  }

  /// `Export Date:`
  String get exportDate {
    return Intl.message('Export Date:', name: 'exportDate', desc: '', args: []);
  }

  /// `SALARY PROFILE`
  String get exportProfileSummary {
    return Intl.message(
      'SALARY PROFILE',
      name: 'exportProfileSummary',
      desc: '',
      args: [],
    );
  }

  /// `Salary Type:`
  String get exportSalaryType {
    return Intl.message(
      'Salary Type:',
      name: 'exportSalaryType',
      desc: '',
      args: [],
    );
  }

  /// `Base Salary:`
  String get exportBaseSalary {
    return Intl.message(
      'Base Salary:',
      name: 'exportBaseSalary',
      desc: '',
      args: [],
    );
  }

  /// `Standard Days:`
  String get exportStandardDays {
    return Intl.message(
      'Standard Days:',
      name: 'exportStandardDays',
      desc: '',
      args: [],
    );
  }

  /// `SUMMARY`
  String get exportSummary {
    return Intl.message('SUMMARY', name: 'exportSummary', desc: '', args: []);
  }

  /// `Total Work Days:`
  String get exportTotalWorkDays {
    return Intl.message(
      'Total Work Days:',
      name: 'exportTotalWorkDays',
      desc: '',
      args: [],
    );
  }

  /// `Total OT Hours:`
  String get exportTotalOtHours {
    return Intl.message(
      'Total OT Hours:',
      name: 'exportTotalOtHours',
      desc: '',
      args: [],
    );
  }

  /// `OT Pay:`
  String get exportOtPay {
    return Intl.message('OT Pay:', name: 'exportOtPay', desc: '', args: []);
  }

  /// `Bonus:`
  String get exportBonus {
    return Intl.message('Bonus:', name: 'exportBonus', desc: '', args: []);
  }

  /// `Advance Payment:`
  String get exportAdvancePayment {
    return Intl.message(
      'Advance Payment:',
      name: 'exportAdvancePayment',
      desc: '',
      args: [],
    );
  }

  /// `Insurance (10.5%):`
  String get exportInsuranceDeduction {
    return Intl.message(
      'Insurance (10.5%):',
      name: 'exportInsuranceDeduction',
      desc: '',
      args: [],
    );
  }

  /// `NET ESTIMATED SALARY:`
  String get exportNetSalary {
    return Intl.message(
      'NET ESTIMATED SALARY:',
      name: 'exportNetSalary',
      desc: '',
      args: [],
    );
  }

  /// `ATTENDANCE LOG`
  String get exportAttendanceLog {
    return Intl.message(
      'ATTENDANCE LOG',
      name: 'exportAttendanceLog',
      desc: '',
      args: [],
    );
  }

  /// `Date`
  String get exportDateColumn {
    return Intl.message('Date', name: 'exportDateColumn', desc: '', args: []);
  }

  /// `Status`
  String get exportStatusColumn {
    return Intl.message(
      'Status',
      name: 'exportStatusColumn',
      desc: '',
      args: [],
    );
  }

  /// `OT Hours`
  String get exportOtHoursColumn {
    return Intl.message(
      'OT Hours',
      name: 'exportOtHoursColumn',
      desc: '',
      args: [],
    );
  }

  /// `Advance`
  String get exportAdvanceColumn {
    return Intl.message(
      'Advance',
      name: 'exportAdvanceColumn',
      desc: '',
      args: [],
    );
  }

  /// `Bonus`
  String get exportBonusColumn {
    return Intl.message('Bonus', name: 'exportBonusColumn', desc: '', args: []);
  }

  /// `Note`
  String get exportNoteColumn {
    return Intl.message('Note', name: 'exportNoteColumn', desc: '', args: []);
  }

  /// `No attendance records found.`
  String get exportEmptyLog {
    return Intl.message(
      'No attendance records found.',
      name: 'exportEmptyLog',
      desc: '',
      args: [],
    );
  }

  /// `Report generated by Manage Salary - Expense & Salary App`
  String get exportFooterTitle {
    return Intl.message(
      'Report generated by Manage Salary - Expense & Salary App',
      name: 'exportFooterTitle',
      desc: '',
      args: [],
    );
  }

  /// `ATTENDANCE & SALARY REPORT {monthStr}`
  String exportReportTitlePdf(String monthStr) {
    return Intl.message(
      'ATTENDANCE & SALARY REPORT $monthStr',
      name: 'exportReportTitlePdf',
      desc: '',
      args: [monthStr],
    );
  }

  /// `Auto-generated report from Manage Salary - Available on Google Play Store`
  String get exportFooterDesc {
    return Intl.message(
      'Auto-generated report from Manage Salary - Available on Google Play Store',
      name: 'exportFooterDesc',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'vi', countryCode: 'VN'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
