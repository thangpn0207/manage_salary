import 'package:flutter/material.dart';
import 'package:manage_salary/core/extensions/string_extension.dart';

import '../../../../models/budget.dart';

enum BudgetCategory {
  foodAndDrinks,
  transportation,
  entertainment,
  utilities,
  expenseOther,
}

enum BudgetPeriod {
  daily,
  weekly,
  monthly,
  yearly,
}

class AddEditBudgetDialog extends StatefulWidget {
  final Budget? budget;
  final Function(Budget) onSave;

  const AddEditBudgetDialog({
    Key? key,
    this.budget,
    required this.onSave,
  }) : super(key: key);

  @override
  _AddEditBudgetDialogState createState() => _AddEditBudgetDialogState();
}

class _AddEditBudgetDialogState extends State<AddEditBudgetDialog> {
  late BudgetCategory _selectedCategory;
  late BudgetPeriod _selectedPeriod;
  late TextEditingController _amountController;

  final List<BudgetCategory> _categories = BudgetCategory.values;
  final List<BudgetPeriod> _periods = BudgetPeriod.values;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.budget?.category ?? _categories[0];
    _selectedPeriod = widget.budget?.period ?? _periods[0];
    _amountController = TextEditingController(
        text: widget.budget?.amount?.toStringAsFixed(2) ?? '');
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  String _formatEnumName(dynamic enumValue) {
    if (enumValue == null) return '';
    return enumValue.name.capitalizeFirstLetter();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.budget == null ? 'Add Budget' : 'Edit Budget'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<BudgetCategory>(
              value: _selectedCategory,
              items: _categories.map((BudgetCategory category) {
                return DropdownMenuItem<BudgetCategory>(
                  value: category,
                  child: Text(_formatEnumName(category)),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                });
              },
              decoration: const InputDecoration(labelText: 'Category'),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<BudgetPeriod>(
              value: _selectedPeriod,
              items: _periods.map((BudgetPeriod period) {
                return DropdownMenuItem<BudgetPeriod>(
                  value: period,
                  child: Text(_formatEnumName(period)),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedPeriod = value!;
                });
              },
              decoration: const InputDecoration(labelText: 'Period'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Budget Amount'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            double amount = double.tryParse(_amountController.text) ?? 0.0;
            final budget = Budget(
                id: widget.budget?.id ?? DateTime.now().toString(),
                category: _selectedCategory,
                period: _selectedPeriod,
                amount: amount
            );

            widget.onSave(budget);
            Navigator.of(context).pop();
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}