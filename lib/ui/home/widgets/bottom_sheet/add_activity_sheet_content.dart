import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For TextInputFormatters
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:manage_salary/bloc/locale/cubit/locale_cubit.dart';
import 'package:manage_salary/core/util/formatter.dart';
import 'package:manage_salary/core/util/log_util.dart';
import 'package:manage_salary/core/util/spell_number.dart';

import '../../../../core/constants/enums.dart';
import '../../../../core/locale/generated/l10n.dart';
import '../../../../core/util/localization_utils.dart';
import '../../../../models/activity_data.dart';

class AddActivitySheetContent extends StatefulWidget {
  const AddActivitySheetContent({super.key});

  @override
  State<AddActivitySheetContent> createState() =>
      _AddActivitySheetContentState();
}

class _AddActivitySheetContentState extends State<AddActivitySheetContent> {
  final _formKey = GlobalKey<FormBuilderState>();
  DateTime _selectedDate = DateTime.now(); // Default to today
  String spelledAmount = '';
  // Function to show the date picker
  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000), // Or relevant start date
      lastDate:
          DateTime.now().add(const Duration(days: 365)), // Or relevant end date
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Function to handle form submission
  void _submitForm() {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final formData = _formKey.currentState?.value;

      final activityData = ActivityData(
        nature: formData?['activityNature'],
        type: formData?['activityType'],
        title: formData?['title'],
        amount:
            double.tryParse(formData?['amount']?.replaceAll('.', '') ?? '0') ??
                0,
        date: _selectedDate,
      );

      Navigator.pop(context, activityData);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).formValidationError)),
      );
    }
  }

  // Get icon for dropdown item
  IconData _getIconForActivity(ActivityType type) {
    switch (type) {
      case ActivityType.salary:
        return Icons.wallet;
      case ActivityType.freelance:
        return Icons.work_history_outlined;
      case ActivityType.investment:
        return Icons.trending_up;
      case ActivityType.incomeOther:
        return Icons.attach_money;
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
        return Icons.flight_takeoff_outlined;
      case ActivityType.expenseOther:
        return Icons.receipt_long_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentLocale = Localizations.localeOf(context).toString();

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          top: 20,
          left: 16,
          right: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: FormBuilder(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                S.of(context).addNewActivitySheetTitle,
                style: theme.textTheme.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              FormBuilderDropdown<ActivityNature>(
                name: 'activityNature',
                decoration: InputDecoration(
                  labelText: S.of(context).activityNatureLabel,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onChanged: (value) {
                  // Force rebuild to update activityType dropdown
                  setState(() {});
                },
                items: ActivityNature.values.map((ActivityNature value) {
                  return DropdownMenuItem<ActivityNature>(
                    value: value,
                    child: Row(
                      children: [
                        Icon(
                          value == ActivityNature.income
                              ? Icons.arrow_circle_down_outlined
                              : Icons.arrow_circle_up_outlined,
                          size: 20,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(localizedActivityNature(context, value)),
                        // Use utils
                      ],
                    ),
                  );
                }).toList(),
                validator: FormBuilderValidators.required(),
              ),
              const SizedBox(height: 16),
              // --- Activity Type Dropdown (Dynamically Filtered) ---
              FormBuilderDropdown<ActivityType>(
                name: 'activityType',
                decoration: InputDecoration(
                  labelText: S.of(context).activityTypeLabel,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                items: ActivityType.values.where((type) {
                  final selectedNature =
                      _formKey.currentState?.fields['activityNature']?.value;
                      LogUtil.i( 'Selected Nature: $selectedNature');
                  if (selectedNature == ActivityNature.income) {
                    return [
                      ActivityType.salary,
                      ActivityType.freelance,
                      ActivityType.investment,
                      ActivityType.incomeOther
                    ].contains(type);
                  } else if (selectedNature == ActivityNature.expense) {
                    return ![
                      ActivityType.salary,
                      ActivityType.freelance,
                      ActivityType.investment,
                      ActivityType.incomeOther
                    ].contains(type);
                  } else {
                    // Show only relevant types if nature is selected, otherwise empty
                    return false;
                  }
                }).map((ActivityType value) {
                  return DropdownMenuItem<ActivityType>(
                    value: value,
                    child: Row(
                      children: [
                        Icon(
                          _getIconForActivity(value),
                          size: 20,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(localizedActivityPaying(context, value)),
                        // Use utils
                      ],
                    ),
                  );
                }).toList(),
                validator: FormBuilderValidators.required(),
              ),
              const SizedBox(height: 16),
              FormBuilderTextField(
                name: 'title',
                decoration: InputDecoration(
                  labelText: S.of(context).titleDescriptionLabel,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                textCapitalization: TextCapitalization.sentences,
                validator: FormBuilderValidators.required(),
              ),
              const SizedBox(height: 16),
              FormBuilderTextField(
                name: 'amount',
                decoration: InputDecoration(
                  helperText: spelledAmount,
                  labelText: S.of(context).amountLabel,
                  prefixText:
                      '${NumberFormat.simpleCurrency(locale: currentLocale).currencySymbol} ',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                MoneyInputFormatter(),
              ],
                onChanged: (value) => setState(() {
                if (value?.isEmpty ?? true) {
                  spelledAmount = '';
                  return;
                }
                final cleanAmount = value?.replaceAll(RegExp(r'[^\d]'), '');
                final amount = double.parse(cleanAmount ?? '0'); // Convert back to actual amount
                context.read<LocaleCubit>().state.languageCode == 'vi'
                    ? spelledAmount = SpellNumber().spellMoneyVND(amount)
                    : spelledAmount = SpellNumber().spellMoney(amount);
              }),
                 validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(errorText: S.of(context).fieldRequired),
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

              // --- Date Picker ---
              Row(
                children: [
                  Expanded(
                    child: Text(
                      S.of(context).dateLabelPrefix +
                          DateFormat.yMd(currentLocale).format(_selectedDate),
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                  TextButton.icon(
                    icon: const Icon(Icons.calendar_month_outlined),
                    label: Text(S.of(context).changeButton),
                    onPressed: () => _pickDate(context),
                    style: TextButton.styleFrom(
                      foregroundColor: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.add_task_outlined),
                  label: Text(S.of(context).addActivityButton),
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    textStyle: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
