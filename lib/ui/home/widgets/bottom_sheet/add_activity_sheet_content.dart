import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For TextInputFormatters
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/enums.dart';
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
        activityType: formData?['activityType'],
        title: formData?['title'],
        amount: double.tryParse(formData?['amount'] ?? '0') ?? 0,
        date: _selectedDate,
      );

      // Pop the bottom sheet and return the data
      Navigator.pop(context, activityData);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all fields correctly.')),
      );
    }
  }

  // Get icon for dropdown item (optional but nice)
  IconData _getIconForActivity(ActivityPaying type) {
    // Reuse the logic from ActivityListItem or define it here
    // (Copied from previous example for completeness)
    switch (type) {
      case ActivityPaying.salary:
        return Icons.wallet;
      case ActivityPaying.shopping:
        return Icons.shopping_bag_outlined;
      case ActivityPaying.foodAndDrinks:
        return Icons.restaurant_menu_outlined;
      case ActivityPaying.utilities:
        return Icons.lightbulb_outline;
      case ActivityPaying.rent:
        return Icons.house_outlined;
      case ActivityPaying.groceries:
        return Icons.shopping_cart_outlined;
      case ActivityPaying.entertainment:
        return Icons.movie_filter_outlined;
      case ActivityPaying.education:
        return Icons.school_outlined;
      case ActivityPaying.healthcare:
        return Icons.local_hospital_outlined;
      case ActivityPaying.travel:
        return Icons.flight_takeoff_outlined;
      case ActivityPaying.savings:
        return Icons.savings_outlined;
      case ActivityPaying.other:
        return Icons.receipt_long_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                'Add New Activity',
                style: theme.textTheme.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              // --- Activity nature Dropdown ---
              FormBuilderDropdown<ActivityNature>(
                name: 'activityNature',
                decoration: InputDecoration(
                  labelText: 'Activity Nature',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                items: ActivityNature.values.map((ActivityNature value) {
                  return DropdownMenuItem<ActivityNature>(
                    value: value,
                    child: Row(
                      children: [
                        Icon(
                          value == ActivityNature.income
                              ? Icons.arrow_circle_down_outlined
                              : Icons.arrow_circle_up_outlined,
                          // Use the helper function to get the icon
                          size: 20,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(value.name),
                      ],
                    ),
                  );
                }).toList(),
                validator: FormBuilderValidators.required(),
              ),
              const SizedBox(height: 16),
              // --- Activity Type Dropdown ---
              FormBuilderDropdown<ActivityPaying>(
                name: 'activityType',
                decoration: InputDecoration(
                  labelText: 'Activity Type',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                items: ActivityPaying.values.map((ActivityPaying value) {
                  return DropdownMenuItem<ActivityPaying>(
                    value: value,
                    child: Row(
                      children: [
                        Icon(
                          _getIconForActivity(value),
                          // Use the helper function to get the icon
                          size: 20,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(value.name),
                      ],
                    ),
                  );
                }).toList(),
                validator: FormBuilderValidators.required(),
              ),
              const SizedBox(height: 16),

              // --- Title/Description Field ---
              FormBuilderTextField(
                name: 'title',
                decoration: InputDecoration(
                  labelText: 'Title / Description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                textCapitalization: TextCapitalization.sentences,
                validator: FormBuilderValidators.required(),
              ),
              const SizedBox(height: 16),

              // --- Amount Field ---
              FormBuilderTextField(
                name: 'amount',
                decoration: InputDecoration(
                  labelText: 'Amount',
                  prefixText:
                      '${NumberFormat.simpleCurrency(locale: 'en_US').currencySymbol} ',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.numeric(),
                  FormBuilderValidators.min(0.01),
                ]),
              ),
              const SizedBox(height: 16),

              // --- Date Picker ---
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Date: ${DateFormat.yMd().format(_selectedDate)}',
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                  TextButton.icon(
                    icon: const Icon(Icons.calendar_month_outlined),
                    label: const Text('Change'),
                    onPressed: () => _pickDate(context),
                    style: TextButton.styleFrom(
                      foregroundColor: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // --- Submit Button ---
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.add_task_outlined),
                  label: const Text('Add Activity'),
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
