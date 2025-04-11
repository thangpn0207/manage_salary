import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manage_salary/core/constants/enums.dart';
import 'package:manage_salary/core/extensions/context.dart';
import 'package:manage_salary/core/util/money_util.dart';
import 'package:manage_salary/ui/settings/budget/widgets/add_edit_budget_dialog.dart';

import '../../../../bloc/activity/activity_bloc.dart'; // Corrected path
import '../../../../bloc/activity/activity_event.dart'; // Corrected path
import '../../../../bloc/activity/activity_state.dart'; // Corrected path
import '../../../../models/budget_category.dart';// Corrected path
import '../../../../models/budget.dart';

// Import the Add/Edit Dialog (will create next)
class BudgetManagementScreen extends StatelessWidget {
  const BudgetManagementScreen({super.key});

  // Helper to format enum names nicely for display
  String _formatEnumName(dynamic enumValue) {
    if (enumValue == null) return '';
    String name = enumValue.name;
    // Split by uppercase letters and join with space
    name = name.replaceAllMapped(
        RegExp(r'([A-Z])'), (match) => ' \${match.group(1)}');
    // Capitalize first letter (using extension or basic)
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

  // Helper to get icon for category
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
        return Icons.flight_takeoff_outlined;
      case ActivityType.expenseOther:
      default:
        return Icons.receipt_long_outlined;
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
            return Center(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('No budgets set yet.'),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    _showAddEditBudgetBottomSheet(context);
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add Budget'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
                ),
              ],
            ),
            );

          }

          return ListView.builder(
            itemCount: state.budgets.length,
            itemBuilder: (context, index) {
              final budget = state.budgets[index];
              return Dismissible(
                key: Key(budget.id),
                // Unique key for dismissal
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
                    SnackBar(
                        content: Text(
                            '\${_formatEnumName(budget.category)} budget removed')),
                  );
                },
                child: ListTile(
                  leading: Icon(_getIconForCategory(
                      _convertBudgetCategoryToActivityType(budget.category))),
                  title: Text(_formatEnumName(budget.category)),
                  subtitle: Text('Period: \${_formatEnumName(budget.period)}'),
                  trailing: Text(MoneyUtil.formatDefault(budget.amount)),
                  onTap: () {
                    _showAddEditBudgetBottomSheet(context, budgetToEdit: budget);
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddEditBudgetBottomSheet(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddEditBudgetBottomSheet(BuildContext context,
      {Budget? budgetToEdit}) {
    AddEditBudgetDialog.show(context,
        budget: budgetToEdit, onSave: (Budget newOrUpdatedBudget) {
      if (budgetToEdit == null) {
        context.read<ActivityBloc>().add(AddBudget(newOrUpdatedBudget));
      } else {
        context.read<ActivityBloc>().add(UpdateBudget(newOrUpdatedBudget));
      }
        },
    );  
  }
  

  ActivityType _convertBudgetCategoryToActivityType(
      BudgetCategory budgetCategory) {
    switch (budgetCategory) {
      case BudgetCategory.foodAndDrinks:
        return ActivityType.foodAndDrinks;
      case BudgetCategory.transportation:
        return ActivityType.travel;
      case BudgetCategory.entertainment:
        return ActivityType.entertainment;
      case BudgetCategory.utilities:
        return ActivityType.utilities;
      case BudgetCategory.expenseOther:
        return ActivityType.expenseOther;
      default:
        return ActivityType.expenseOther;
    }
  }
}
