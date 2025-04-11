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
