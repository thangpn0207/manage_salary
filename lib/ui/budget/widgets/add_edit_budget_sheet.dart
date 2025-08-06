import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:manage_salary/bloc/concurrent/concurrent_cubit.dart';
import 'package:manage_salary/core/util/formatter.dart';
import 'package:manage_salary/core/util/localization_utils.dart';
import 'package:manage_salary/core/util/spell_number.dart';

import '../../../bloc/activity/activity_bloc.dart';
import '../../../core/constants/enums.dart';
import '../../../core/locale/generated/l10n.dart';
import '../../../core/util/money_util.dart';
import '../../../models/budget.dart';

Future<Budget?> showAddEditBudgetSheet(BuildContext context,
    {Budget? budget}) async {
  return await showModalBottomSheet<Budget>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext bc) {
      return Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(bc).padding.top + 16.0,
          left: 16.0,
          right: 16.0,
          bottom: MediaQuery.of(bc).viewInsets.bottom + 16.0,
        ),
        child: _BudgetFormContent(budget: budget),
      );
    },
  );
}

class _BudgetFormContent extends StatefulWidget {
  final Budget? budget;

  const _BudgetFormContent({this.budget});

  @override
  _BudgetFormContentState createState() => _BudgetFormContentState();
}

class _BudgetFormContentState extends State<_BudgetFormContent> {
  final _formKey = GlobalKey<FormBuilderState>();
  late BudgetCategory _selectedCategory;
  late BudgetPeriod _selectedPeriod;
  late TextEditingController _amountController;
  String spelledAmount = '';
  double _currentSpending = 0.0;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.budget?.category ?? BudgetCategory.values[0];
    _selectedPeriod = widget.budget?.period ?? BudgetPeriod.monthly;
    _amountController = TextEditingController(
      text: widget.budget?.amount != null
          ? MoneyUtil.formatDefault(widget.budget!.amount)
          : '',
    );
    _updateSpendingForCategory();
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _updateSpendingForCategory() {
    final state = context.read<ActivityBloc>().state;
    final activityType =
        _convertBudgetCategoryToActivityType(_selectedCategory);
    final periodRange = _getPeriodDateRange(_selectedPeriod);

    _currentSpending = state.allActivities
        .where((a) =>
            a.nature == ActivityNature.expense &&
            a.type == activityType &&
            !a.date.isBefore(periodRange.start) &&
            a.date.isBefore(periodRange.end))
        .fold(0.0, (sum, activity) => sum + activity.amount);

    setState(() {});
  }

  ActivityType _convertBudgetCategoryToActivityType(BudgetCategory category) {
    switch (category) {
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

  ({DateTime start, DateTime end}) _getPeriodDateRange(BudgetPeriod period) {
    final now = DateTime.now();
    switch (period) {
      case BudgetPeriod.weekly:
        final start = now.subtract(Duration(days: now.weekday - 1));
        final end = start.add(const Duration(days: 7));
        return (
          start: DateTime(start.year, start.month, start.day),
          end: DateTime(end.year, end.month, end.day),
        );

      case BudgetPeriod.monthly:
        return (
          start: DateTime(now.year, now.month, 1),
          end: DateTime(now.year, now.month + 1, 1),
        );

      case BudgetPeriod.yearly:
        return (
          start: DateTime(now.year, 1, 1),
          end: DateTime(now.year + 1, 1, 1),
        );
    }
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      // Parse the formatted amount by removing currency symbol and thousands separators
      final cleanAmount =
          _amountController.text.replaceAll(RegExp(r'[^\d]'), '');
      final amount = double.parse(cleanAmount); // Convert back to actual amount

      final budget = Budget(
        id: widget.budget?.id,
        category: _selectedCategory,
        period: _selectedPeriod,
        amount: amount,
        currentSpending: _currentSpending,
        lastUpdated: DateTime.now(),
      );
      Navigator.of(context).pop(budget);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    double? currentAmount = double.tryParse(_amountController.text);
    bool hasAmount = currentAmount != null && currentAmount > 0;
    double progress =
        hasAmount ? (_currentSpending / currentAmount).clamp(0.0, 1.0) : 0.0;
    Color progressColor = Colors.green.shade600;
    if (progress > 0.9) {
      progressColor = Colors.red.shade600;
    } else if (progress > 0.7) {
      progressColor = Colors.orange.shade600;
    }

    return FormBuilder(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.budget == null
                  ? S.of(context).addBudget
                  : S.of(context).editBudget,
              style: theme.textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Category Dropdown with icon
            FormBuilderDropdown<BudgetCategory>(
              name: 'category',
              initialValue: _selectedCategory,
              decoration: InputDecoration(
                labelText: S.of(context).category,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              ),
              items: BudgetCategory.values.map((category) {
                final activityType =
                    _convertBudgetCategoryToActivityType(category);
                return DropdownMenuItem(
                  value: category,
                  child: Row(
                    children: [
                      Icon(_getIconForCategory(activityType), size: 20),
                      const SizedBox(width: 8),
                      Text(localizedActivityPaying(context, activityType)),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedCategory = value;
                    _updateSpendingForCategory();
                  });
                }
              },
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(
                    errorText: S.of(context).fieldRequired),
              ]),
            ),
            const SizedBox(height: 16),

            // Period Dropdown
            FormBuilderDropdown<BudgetPeriod>(
              name: 'period',
              initialValue: _selectedPeriod,
              decoration: InputDecoration(
                labelText: S.of(context).period,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              ),
              items: BudgetPeriod.values.map((period) {
                return DropdownMenuItem(
                  value: period,
                  child: Text(localizedBudgetPeriod(context, period)),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedPeriod = value;
                    _updateSpendingForCategory();
                  });
                }
              },
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(
                    errorText: S.of(context).fieldRequired),
              ]),
            ),
            const SizedBox(height: 16),

            // Amount Text Field
            FormBuilderTextField(
              name: 'amount',
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                helperText: spelledAmount,
                labelText: S.of(context).budgetAmount,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                MoneyInputFormatter(),
              ],
              onChanged: (_) => setState(() {
                if (_amountController.text.isEmpty) {
                  spelledAmount = '';
                  return;
                }
                final cleanAmount =
                    _amountController.text.replaceAll(RegExp(r'[^\d]'), '');
                final amount =
                    double.parse(cleanAmount); // Convert back to actual amount
                context.read<CurrencyCubit>().state.languageCode == 'vi'
                    ? spelledAmount = SpellNumber().spellMoneyVND(amount)
                    : spelledAmount = SpellNumber().spellMoney(amount);
              }),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(
                    errorText: S.of(context).fieldRequired),
                (value) {
                  if (value == null || value.isEmpty) return null;
                  final cleanValue = value.replaceAll(RegExp(r'[^\d]'), '');
                  if (cleanValue.isEmpty || double.parse(cleanValue) <= 0) {
                    return S.of(context).amountMustBePositive;
                  }
                  return null;
                },
              ]),
            ),
            const SizedBox(height: 16),

            // Current spending info
            if (_currentSpending > 0) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(S.of(context).currentSpending,
                      style: theme.textTheme.bodyMedium),
                  Text(
                    MoneyUtil.formatDefault(_currentSpending),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.error,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (hasAmount) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: theme.dividerColor.withValues(alpha: 0.3),
                    valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                    minHeight: 8,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${(progress * 100).toStringAsFixed(0)}% ${S.of(context).ofBudgetUsed}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: progressColor,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.right,
                ),
              ],
            ],
            const SizedBox(height: 24),

            // Save Button
            ElevatedButton(
              onPressed: _saveForm,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(widget.budget == null
                  ? S.of(context).addBudget
                  : S.of(context).saveChanges),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForCategory(ActivityType type) {
    switch (type) {
      case ActivityType.shopping:
        return Icons.shopping_bag_outlined;
      case ActivityType.foodAndDrinks:
        return Icons.restaurant_menu_outlined;
      case ActivityType.utilities:
        return Icons.lightbulb_outline;
      case ActivityType.rent:
        return Icons.house_outlined;
      case ActivityType.groceries:
        return Icons.shopping_cart_outlined;
      case ActivityType.entertainment:
        return Icons.movie_filter_outlined;
      case ActivityType.education:
        return Icons.school_outlined;
      case ActivityType.healthcare:
        return Icons.local_hospital_outlined;
      case ActivityType.travel:
        return Icons.directions_car_outlined;
      case ActivityType.expenseOther:
      default:
        return Icons.receipt_long_outlined;
    }
  }
}
