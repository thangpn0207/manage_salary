import 'package:flutter/material.dart'; // Import for Flutter widgets
import 'package:manage_salary/core/extensions/context.dart'; // Import for context extension
import 'package:manage_salary/core/extensions/string_extension.dart'; // Import for string extension

import '../../../../models/budget.dart'; // Import for Budget model

// Enumeration for budget categories
enum BudgetCategory {
  foodAndDrinks,
  transportation,
  entertainment,
  utilities,
  expenseOther,
}

// Enumeration for budget periods
enum BudgetPeriod {
  daily,
  weekly,
  monthly,
  yearly,
}

// Stateful widget for adding or editing a budget
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

// State class for AddEditBudgetDialog
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

  // Helper function to format enum names
  String _formatEnumName(dynamic enumValue) {
    if (enumValue == null) return '';
    String name = enumValue.name;

    try {
      name = name[0].toUpperCase() + name.substring(1).trim();
    } catch (_) {
      if (name.isNotEmpty) {
        name = name[0].toUpperCase() + name.substring(1);
      }
    }
    name = name.replaceFirst('And', '&');
    return name.trim();
  }

  // Static method to show the bottom sheet
  static Future<void> show(BuildContext context,
      {Budget? budget, required Function(Budget) onSave}) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext bc) {
        return Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom),
          child: AddEditBudgetDialog(budget: budget, onSave: onSave),
        );
      },
    );
  }
  
   PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(widget.budget == null ? 'Add Budget' : 'Edit Budget'),
      actions: [
        TextButton(
          onPressed: () {
            double amount = double.tryParse(_amountController.text) ?? 0.0;
            final budget = Budget(
                id: widget.budget?.id ?? DateTime.now().toString(),
                category: _selectedCategory,
                period: _selectedPeriod,
                amount: amount);
            widget.onSave(budget);
            Navigator.of(context).pop();
          },
          child: const Text('Save'),
        ),
      ],
    );
  }

  @override
  // Build method for the widget
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<BudgetCategory>(
              value: _selectedCategory,
              items: _categories.map((BudgetCategory category) {
                return DropdownMenuItem(value: category,child: Text(_formatEnumName(category)),
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
                return DropdownMenuItem(value: period,
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
      ),
    );
  }
}
