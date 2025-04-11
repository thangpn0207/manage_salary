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

// Helper function to get localized string for ActivityPaying
String localizedActivityPaying(BuildContext context, ActivityType type) {
  switch (type) {
    case ActivityType.salary:
      return S.of(context).activityTypeSalary;
    case ActivityType.shopping:
      return S.of(context).activityTypeShopping;
    case ActivityType.foodAndDrinks:
      return S.of(context).activityTypeFoodAndDrinks;
    case ActivityType.utilities:
      return S.of(context).activityTypeUtilities;
    case ActivityType.rent:
      return S.of(context).activityTypeRent;
    case ActivityType.groceries:
      return S.of(context).activityTypeGroceries;
    case ActivityType.entertainment:
      return S.of(context).activityTypeEntertainment;
    case ActivityType.education:
      return S.of(context).activityTypeEducation;
    case ActivityType.healthcare:
      return S.of(context).activityTypeHealthcare;
    case ActivityType.travel:
      return S.of(context).activityTypeTravel;
    case ActivityType.savings:
      return S.of(context).activityTypeSavings;
    case ActivityType.other:
      return S.of(context).activityTypeOther;
  }
}
