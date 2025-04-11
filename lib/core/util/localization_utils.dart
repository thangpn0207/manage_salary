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
String localizedActivityPaying(BuildContext context, ActivityPaying type) {
  switch (type) {
    case ActivityPaying.salary:
      return S.of(context).activityTypeSalary;
    case ActivityPaying.shopping:
      return S.of(context).activityTypeShopping;
    case ActivityPaying.foodAndDrinks:
      return S.of(context).activityTypeFoodAndDrinks;
    case ActivityPaying.utilities:
      return S.of(context).activityTypeUtilities;
    case ActivityPaying.rent:
      return S.of(context).activityTypeRent;
    case ActivityPaying.groceries:
      return S.of(context).activityTypeGroceries;
    case ActivityPaying.entertainment:
      return S.of(context).activityTypeEntertainment;
    case ActivityPaying.education:
      return S.of(context).activityTypeEducation;
    case ActivityPaying.healthcare:
      return S.of(context).activityTypeHealthcare;
    case ActivityPaying.travel:
      return S.of(context).activityTypeTravel;
    case ActivityPaying.savings:
      return S.of(context).activityTypeSavings;
    case ActivityPaying.other:
      return S.of(context).activityTypeOther;
  }
}