import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/enums.dart';
import '../../../../models/budget.dart'; // Import for TextInputFormatter

// --- Enums remain the same ---
enum BudgetCategory {
  foodAndDrinks,
  transportation,
  entertainment,
  utilities,
  expenseOther,
}

// --- Function to show the bottom sheet ---
// Moved outside the widget class
Future<Budget?> showAddEditBudgetSheet(BuildContext context,
    {Budget? budget}) async {
  // ShowModalBottomSheet now returns the result from Navigator.pop
  return await showModalBottomSheet<Budget>(
    context: context,
    isScrollControlled: true, // Important for keyboard handling
    shape: const RoundedRectangleBorder(
      // Optional: Add rounded corners
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext bc) {
      // Add padding for safe areas and keyboard insets
      return Padding(
        padding: EdgeInsets.only(
          // Add padding for elements like notch, status bar, etc.
          top: MediaQuery.of(bc).padding.top + 16.0,
          left: 16.0,
          right: 16.0,
          // Adjust bottom padding dynamically for the keyboard
          bottom: MediaQuery.of(bc).viewInsets.bottom + 16.0,
        ),
        // Pass the budget data to the form content widget
        child: _BudgetFormContent(budget: budget), // Pass only budget
      );
    },
  );
}

// --- Renamed StatefulWidget for the Bottom Sheet Content ---
// Made private as it's mainly used by the show function above
class _BudgetFormContent extends StatefulWidget {
  final Budget? budget; // Optional budget for editing

  // No onSave needed here, data is returned via Navigator.pop
  const _BudgetFormContent({Key? key, this.budget}) : super(key: key);

  @override
  _BudgetFormContentState createState() => _BudgetFormContentState();
}

class _BudgetFormContentState extends State<_BudgetFormContent> {
  // Use a Form key for validation
  final _formKey = GlobalKey<FormState>();

  late BudgetCategory _selectedCategory;
  late BudgetPeriod _selectedPeriod;
  late TextEditingController _amountController;

  final List<BudgetCategory> _categories = BudgetCategory.values;
  final List<BudgetPeriod> _periods = BudgetPeriod.values;

  @override
  void initState() {
    super.initState();
    // Initialize state from widget.budget if provided
    _selectedCategory = widget.budget?.category ?? _categories[0];
    _selectedPeriod = widget.budget?.period ?? _periods[0];
    _amountController = TextEditingController(
      text: widget.budget?.amount != null
          ? widget.budget!.amount.toStringAsFixed(2) // Format existing amount
          : '',
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  // Helper function to format enum names (keep this)
  String _formatEnumName(dynamic enumValue) {
    if (enumValue == null) return '';
    // Simplified version using simple replace and capitalize
    String name = enumValue.toString().split('.').last; // Get name after '.'
    name = name
        .replaceAllMapped(RegExp(r'([A-Z])'), (match) => ' ${match.group(1)}')
        .trim(); // Add space before caps
    name = name[0].toUpperCase() + name.substring(1); // Capitalize first letter
    name = name.replaceFirst('And', '&'); // Specific case
    return name;
  }

  void _saveForm() {
    // Validate the form
    if (_formKey.currentState!.validate()) {
      // Parse amount safely
      final double amount =
          double.tryParse(_amountController.text.trim()) ?? 0.0;

      // Create the Budget object
      final budget = Budget(
        // Use existing ID if editing, otherwise generate a new one
        id: widget.budget?.id ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        category: _selectedCategory,
        period: _selectedPeriod,
        amount: amount,
      );

      // Pop the bottom sheet and return the saved budget object
      Navigator.of(context).pop(budget);
    }
  }

  @override
  Widget build(BuildContext context) {
    // No Scaffold or AppBar here anymore
    return Form(
      // Wrap content in a Form
      key: _formKey,
      child: SingleChildScrollView(
        // Allows scrolling if content overflows (e.g., keyboard)
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min, // Take minimum vertical space needed
          children: [
            // Title for the bottom sheet
            Text(
              widget.budget == null ? 'Add Budget' : 'Edit Budget',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Category Dropdown
            DropdownButtonFormField<BudgetCategory>(
              value: _selectedCategory,
              items: _categories.map((BudgetCategory category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(_formatEnumName(category)),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedCategory = value;
                  });
                }
              },
              decoration: InputDecoration(
                labelText: 'Category',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              ),
              validator: (value) =>
                  value == null ? 'Please select a category' : null,
            ),
            const SizedBox(height: 16),

            // Period Dropdown
            DropdownButtonFormField<BudgetPeriod>(
              value: _selectedPeriod,
              items: _periods.map((BudgetPeriod period) {
                return DropdownMenuItem(
                  value: period,
                  child: Text(_formatEnumName(period)),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedPeriod = value;
                  });
                }
              },
              decoration: InputDecoration(
                labelText: 'Period',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              ),
              validator: (value) =>
                  value == null ? 'Please select a period' : null,
            ),
            const SizedBox(height: 16),

            // Amount Text Field
            TextFormField(
              // Use TextFormField for validation
              controller: _amountController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              // Allow decimals
              inputFormatters: [
                // Allow digits and a single decimal point with up to 2 decimal places
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              decoration: InputDecoration(
                labelText: 'Budget Amount',
                prefixText:
                    '${NumberFormat.simpleCurrency(locale: 'en_US').currencySymbol} ', // Optional: Show currency symbol
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter an amount';
                }
                if (double.tryParse(value.trim()) == null) {
                  return 'Please enter a valid number';
                }
                if (double.parse(value.trim()) <= 0) {
                  return 'Amount must be positive';
                }
                return null; // Return null if valid
              },
            ),
            const SizedBox(height: 24),

            // Save Button
            ElevatedButton(
              onPressed: _saveForm, // Call the save function
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                // Optional: Add styling from theme
                // backgroundColor: Theme.of(context).colorScheme.primary,
                // foregroundColor: Theme.of(context).colorScheme.onPrimary,
              ),
              child:
                  Text(widget.budget == null ? 'Add Budget' : 'Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
