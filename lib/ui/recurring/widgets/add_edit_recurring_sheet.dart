import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:manage_salary/bloc/locale/locale_cubit.dart';
import 'package:manage_salary/core/constants/enums.dart';
import 'package:manage_salary/core/locale/generated/l10n.dart';
import 'package:manage_salary/core/util/formatter.dart';
import 'package:manage_salary/core/util/localization_utils.dart';
import 'package:manage_salary/core/util/money_util.dart';
import 'package:manage_salary/core/util/spell_number.dart';
import 'package:manage_salary/models/recurring_activity.dart';

Future<RecurringActivity?> showAddEditRecurringSheet(
  BuildContext context, 
  {RecurringActivity? activity}
) async {
  return await showModalBottomSheet<RecurringActivity>(
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
        child: _RecurringFormContent(activity: activity),
      );
    },
  );
}

class _RecurringFormContent extends StatefulWidget {
  final RecurringActivity? activity;

  const _RecurringFormContent({this.activity});

  @override
  _RecurringFormContentState createState() => _RecurringFormContentState();
}

class _RecurringFormContentState extends State<_RecurringFormContent> {
  final _formKey = GlobalKey<FormBuilderState>();
  late ActivityType _selectedType;
  late RecurringFrequency _selectedFrequency;
  late TextEditingController _titleController;
  late TextEditingController _amountController;
  late DateTime _startDate;
  DateTime? _endDate;
  String spelledAmount = '';

  @override
  void initState() {
    super.initState();
    _selectedType = widget.activity?.type ?? ActivityType.expenseOther;
    _selectedFrequency = widget.activity?.frequency ?? RecurringFrequency.monthly;
    _titleController = TextEditingController(text: widget.activity?.title ?? '');
    _amountController = TextEditingController(
      text: widget.activity?.amount != null
          ? MoneyUtil.formatDefault(widget.activity!.amount)
          : '',
    );
    _startDate = widget.activity?.startDate ?? DateTime.now();
    _endDate = widget.activity?.endDate;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      // Parse the formatted amount
      final cleanAmount = _amountController.text.replaceAll(RegExp(r'[^\d]'), '');
      final amount = double.parse(cleanAmount);

      final activity = RecurringActivity(
        id: widget.activity?.id,
        title: _titleController.text,
        type: _selectedType,
        amount: amount,
        frequency: _selectedFrequency,
        startDate: _startDate,
        endDate: _endDate,
      );

      Navigator.of(context).pop(activity);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = S.of(context);

    return FormBuilder(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.activity == null ? s.addRecurring : s.editRecurring,
              style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Title TextField
            FormBuilderTextField(
              name: 'title',
              controller: _titleController,
              decoration: InputDecoration(
                labelText: s.title,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              ),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(errorText: s.fieldRequired),
              ]),
            ),
            const SizedBox(height: 16),

            // Activity Type Dropdown
            FormBuilderDropdown<ActivityType>(
              name: 'type',
              initialValue: _selectedType,
              decoration: InputDecoration(
                labelText: s.type,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              ),
              items: ActivityType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Row(
                    children: [
                      Icon(_getIconForType(type), size: 20),
                      const SizedBox(width: 8),
                      Text(localizedActivityPaying(context, type)),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedType = value);
                }
              },
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(errorText: s.fieldRequired),
              ]),
            ),
            const SizedBox(height: 16),

            // Amount TextField
            FormBuilderTextField(
              name: 'amount',
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                helperText: spelledAmount,
                labelText: s.amount,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
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
                final cleanAmount = _amountController.text.replaceAll(RegExp(r'[^\d]'), '');
                final amount = double.parse(cleanAmount);
                context.read<LocaleCubit>().state.languageCode == 'vi'
                    ? spelledAmount = SpellNumber().spellMoneyVND(amount)
                    : spelledAmount = SpellNumber().spellMoney(amount);
              }),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(errorText: s.fieldRequired),
                (value) {
                  if (value == null || value.isEmpty) return null;
                  final cleanValue = value.replaceAll(RegExp(r'[^\d]'), '');
                  if (cleanValue.isEmpty || double.parse(cleanValue) <= 0) {
                    return s.amountMustBePositive;
                  }
                  return null;
                },
              ]),
            ),
            const SizedBox(height: 16),

            // Frequency Dropdown
            FormBuilderDropdown<RecurringFrequency>(
              name: 'frequency',
              initialValue: _selectedFrequency,
              decoration: InputDecoration(
                labelText: s.frequency,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              ),
              items: RecurringFrequency.values.map((frequency) {
                return DropdownMenuItem(
                  value: frequency,
                  child: Text(localizedRecurringFrequency(context, frequency)),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedFrequency = value);
                }
              },
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(errorText: s.fieldRequired),
              ]),
            ),
            const SizedBox(height: 16),

            // Start Date Picker
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(s.startDate),
              subtitle: Text(
                _startDate.toString().split(' ')[0],
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
              trailing: Icon(
                Icons.calendar_today,
                color: theme.colorScheme.primary,
              ),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _startDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (date != null) {
                  setState(() => _startDate = date);
                  // Adjust end date if it's before start date
                  if (_endDate != null && _endDate!.isBefore(_startDate)) {
                    _endDate = null;
                  }
                }
              },
            ),

            // End Date Picker
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(s.endDate),
              subtitle: Text(
                _endDate?.toString().split(' ')[0] ?? s.noEndDate,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: _endDate != null ? theme.colorScheme.primary : theme.hintColor,
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_endDate != null)
                    IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () => setState(() => _endDate = null),
                      color: theme.hintColor,
                    ),
                  Icon(
                    Icons.calendar_today,
                    color: theme.colorScheme.primary,
                  ),
                ],
              ),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _endDate ?? _startDate.add(const Duration(days: 1)),
                  firstDate: _startDate.add(const Duration(days: 1)),
                  lastDate: DateTime(2100),
                );
                if (date != null) {
                  setState(() => _endDate = date);
                }
              },
            ),
            const SizedBox(height: 24),

            // Save Button
            ElevatedButton(
              onPressed: _saveForm,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(
                widget.activity == null ? s.addRecurring : s.saveChanges
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForType(ActivityType type) {
    switch (type) {
      case ActivityType.salary:
        return Icons.payments_outlined;
      case ActivityType.freelance:
        return Icons.work_outline;
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
        return Icons.directions_car_outlined;
      case ActivityType.expenseOther:
        return Icons.receipt_long_outlined;
    }
  }
}