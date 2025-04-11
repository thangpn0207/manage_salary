
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manage_salary/core/extensions/string_extension.dart'; // For formatting
import 'package:manage_salary/core/util/money_util.dart';

import '../../../../bloc/activity/activity_bloc.dart';
import '../../../../bloc/activity/activity_event.dart';
import '../../../../bloc/activity/activity_state.dart';
import '../../../../core/constants/enums.dart';
import '../../../../models/budget.dart';
// Import the Add/Edit Dialog (will create next)
// import 'widgets/add_edit_budget_dialog.dart';

class BudgetManagementScreen extends StatelessWidget {
  const BudgetManagementScreen({super.key});

  // Helper to format enum names nicely for display
  String _formatEnumName(dynamic enumValue) {
    if (enumValue == null) return '';
    String name = enumValue.name;
    // Split by uppercase letters and join with space
    name = name.replaceAllMapped(RegExp(r'([A-Z])'), (match) => ' \${match.group(1)}');
    // Capitalize first letter (using extension or basic)
    try {
      name = name.capitalizeFirstLetter();
    } catch (_) {
      if (name.isNotEmpty) {
        name = name[0].toUpperCase() + name.substring(1);
      }
    }
    name = name.replaceFirst('And', '&');
    return name.trim();
  }

  // Helper to get icon for category
   IconData _getIconForCategory(ActivityType type) {
    // Reusing icon logic from other places
    switch (type) {
      case ActivityType.shopping: return Icons.shopping_bag_outlined;
      case ActivityType.foodAndDrinks: return Icons.restaurant_menu_outlined;
      case ActivityType.utilities: return Icons.lightbulb_outline;
      case ActivityType.rent: return Icons.house_outlined;
      case ActivityType.groceries: return Icons.shopping_cart_outlined;
      case ActivityType.entertainment: return Icons.movie_filter_outlined;
      case ActivityType.education: return Icons.school_outlined;
      case ActivityType.healthcare: return Icons.local_hospital_outlined;
      case ActivityType.travel: return Icons.flight_takeoff_outlined;
      case ActivityType.expenseOther:
      default: return Icons.receipt_long_outlined;
    }
     // Only expense types relevant for budgeting generally
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Budgets'),
      ),
      body: BlocBuilder<ActivityBloc, ActivityState>(
        builder: (context, state) {
          if (state.budgets.isEmpty) {
            return const Center(
              child: Text(
                'No budgets set yet. Tap + to add one.',
                textAlign: TextAlign.center,
              ),
            );
          }

          return ListView.builder(
            itemCount: state.budgets.length,
            itemBuilder: (context, index) {
              final budget = state.budgets[index];
              return Dismissible(
                 key: Key(budget.id), // Unique key for dismissal
                 direction: DismissDirection.endToStart,
                 background: Container(
                   color: Colors.redAccent.withOpacity(0.8),
                   alignment: Alignment.centerRight,
                   padding: const EdgeInsets.only(right: 20.0),
                   child: const Icon(Icons.delete_outline, color: Colors.white),
                 ),
                 onDismissed: (direction) {
                   // Dispatch event to remove the budget
                   context.read<ActivityBloc>().add(RemoveBudget(budget.id));
                   ScaffoldMessenger.of(context).showSnackBar(
                     SnackBar(content: Text('\${_formatEnumName(budget.category)} budget removed')),
                   );
                 },
                 child: ListTile(
                   leading: Icon(_getIconForCategory(budget.category)),
                   title: Text(_formatEnumName(budget.category)),
                   subtitle: Text('Period: \${_formatEnumName(budget.period)}'),
                   trailing: Text(MoneyUtil.formatDefault(budget.amount)),
                   onTap: () {
                     // TODO: Implement edit functionality
                     // Show the Add/Edit dialog in edit mode
                     // _showAddEditBudgetDialog(context, budgetToEdit: budget);
                     ScaffoldMessenger.of(context).showSnackBar(
                       const SnackBar(content: Text('Edit functionality not yet implemented.')),
                     );
                   },
                 ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
           // TODO: Implement add functionality
           // Show the Add/Edit dialog in add mode
           // _showAddEditBudgetDialog(context);
           ScaffoldMessenger.of(context).showSnackBar(
             const SnackBar(content: Text('Add functionality not yet implemented.')),
           );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  /*
  // Function to show the Add/Edit Budget Dialog (placeholder)
  void _showAddEditBudgetDialog(BuildContext context, {Budget? budgetToEdit}) {
     showDialog(
        context: context,
        builder: (_) => AddEditBudgetDialog(
              budget: budgetToEdit,
              // Pass existing budget for editing, null for adding
              onSave: (newOrUpdatedBudget) {
                 if (budgetToEdit == null) {
                   // Add new budget
                   context.read<ActivityBloc>().add(AddBudget(newOrUpdatedBudget));
                 } else {
                   // Update existing budget
                   context.read<ActivityBloc>().add(UpdateBudget(newOrUpdatedBudget));
                 }
              },
            ),
     );
  }
  */

}
