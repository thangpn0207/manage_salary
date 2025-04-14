import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manage_salary/core/constants/enums.dart'; // Assuming ActivityType, BudgetCategory, BudgetPeriod are here
import 'package:manage_salary/core/util/money_util.dart'; // Assuming for currency formatting
import 'package:manage_salary/models/budget.dart'; // Import budget model
import 'package:manage_salary/ui/budget/widgets/add_edit_budget_sheet.dart'; // Import sheet function

import '../../../bloc/activity/activity_bloc.dart';
import '../../../bloc/activity/activity_event.dart';
import '../../../bloc/activity/activity_state.dart';

class BudgetManagementScreen extends StatelessWidget {
  const BudgetManagementScreen({super.key});

  // Helper to format enum names (same as before)
  String _formatEnumName(dynamic enumValue) {
    if (enumValue == null) return '';
    String name = enumValue.toString().split('.').last;
    name = name
        .replaceAllMapped(RegExp(r'([A-Z])'), (match) => ' ${match.group(1)}')
        .trim();
    name = name[0].toUpperCase() + name.substring(1);
    name = name.replaceFirst('And', '&');
    return name;
  }

  // Helper to get icon (same as before)
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

  // Helper to convert BudgetCategory to ActivityType
  ActivityType _convertBudgetCategoryToActivityType(BudgetCategory budgetCategory) {
    switch (budgetCategory) {
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

  // --- Function to trigger Add/Edit Sheet and dispatch events (same as before) ---
  void _showAddEditBudgetDialog(BuildContext context, {Budget? budget}) async {
    final resultBudget = await showAddEditBudgetSheet(context, budget: budget);
    if (resultBudget != null && context.mounted) {
      if (budget == null) {
        context.read<ActivityBloc>().add(AddBudget(resultBudget));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  '${_formatEnumName(resultBudget.category)} budget added.')),
        );
      } else {
        context.read<ActivityBloc>().add(UpdateBudget(resultBudget));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  '${_formatEnumName(resultBudget.category)} budget updated.')),
        );
      }
    }
  }

// --- Function to confirm and dispatch RemoveBudget event ---
  void _confirmAndRemoveBudget(
      BuildContext context, String budgetId, String categoryName) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: Text(
              'Are you sure you want to remove the "$categoryName" budget?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Remove'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Close dialog
                context
                    .read<ActivityBloc>()
                    .add(RemoveBudget(budgetId)); // Dispatch remove
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text('"$categoryName" budget removed'),
                      duration: const Duration(seconds: 2)),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Budgets'),
      ),
      body: BlocBuilder<ActivityBloc, ActivityState>(
        builder: (context, state) {
          // --- Calculate summary data (assuming monthly for simplicity) ---
          Map<ActivityType, double> monthlySpendingByType = {};
          final monthRange = _getThisMonthRange();
          state.allActivities
              .where((a) =>
                  a.nature == ActivityNature.expense &&
                  !a.date.isBefore(monthRange.start) &&
                  a.date.isBefore(monthRange.end) &&
                  a.type != null) // Ensure activityType is not null
              .forEach((activity) {
            monthlySpendingByType.update(
                activity.type!, // Safe due to null check above
                (value) => value + activity.amount,
                ifAbsent: () => activity.amount);
          });

          double totalMonthlyBudget = state.budgets
              .where((b) => b.period == BudgetPeriod.monthly)
              .fold(0.0, (sum, b) => sum + b.amount);
          double actualMonthlySpending = monthlySpendingByType.values
              .fold(0.0, (sum, amount) => sum + amount);
          double remainingMonthly = totalMonthlyBudget - actualMonthlySpending;

          return ListView(
            padding: const EdgeInsets.only(bottom: 80),
            // Padding for potential FAB if kept
            children: [
              // --- Updated Summary Card ---
              _buildSummaryCardWithAddButton(
                // Use the new summary card widget
                context: context,
                period: "This Month",
                totalBudget: totalMonthlyBudget,
                totalSpending: actualMonthlySpending,
                remaining: remainingMonthly,
                onAddBudget: () =>
                    _showAddEditBudgetDialog(context), // Pass the add function
              ),

              // --- Title for Budget List ---
              if (state
                  .budgets.isNotEmpty) // Only show title if there are budgets
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 8.0),
                  // Adjusted padding
                  child: Text(
                    "Budget Details",
                    style: theme.textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),

              // --- Budget List or Empty State Placeholder ---
              if (state.budgets.isEmpty)
                _buildEmptyState(context) // Keep the empty state
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: state.budgets.length,
                  itemBuilder: (context, index) {
                    final budget = state.budgets[index];
                    final activityType =
                        _convertBudgetCategoryToActivityType(budget.category);

                    // Get spending specific to this budget's category and period
                    // Still simplified for monthly here
                    double spendingForBudget = 0;
                    if (budget.period == BudgetPeriod.monthly) {
                      spendingForBudget =
                          monthlySpendingByType[activityType] ?? 0.0;
                    } else {
                      // TODO: Calculate spending for non-monthly periods
                    }

                    return _buildBudgetListItem(
                      // Use the same list item
                      context: context,
                      budget: budget,
                      actualSpending: spendingForBudget,
                      onTap: () =>
                          _showAddEditBudgetDialog(context, budget: budget),
                      onDismissed: (id) => _confirmAndRemoveBudget(
                          context, id, _formatEnumName(budget.category)),
                    );
                  },
                  separatorBuilder: (context, index) => Divider(
                    height: 1,
                    thickness: 1,
                    indent: 16,
                    endIndent: 16,
                    color: theme.dividerColor.withOpacity(0.5),
                  ),
                ),
            ],
          );
        },
      ),
      // FloatingActionButton is removed as Add button is now in the summary card
      // floatingActionButton: FloatingActionButton( ... ),
    );
  }

  // --- UI Helper Widgets ---

  // NEW Summary Card Widget with Add Button
  Widget _buildSummaryCardWithAddButton({
    required BuildContext context,
    required String period,
    required double totalBudget,
    required double totalSpending,
    required double remaining,
    required VoidCallback onAddBudget,
  }) {
    final theme = Theme.of(context);
    final remainingColor =
        remaining >= 0 ? Colors.green.shade700 : theme.colorScheme.error;
    final hasBudgets = totalBudget > 0; // Check if any budget is set

    return Card(
      margin: const EdgeInsets.all(16.0),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("$period Budget Summary",
                    style: theme.textTheme.titleMedium),
                // Add Budget Button (replaces FAB)
                TextButton.icon(
                  onPressed: onAddBudget,
                  icon: const Icon(Icons.add_circle_outline, size: 20),
                  label: const Text("Add"),
                  style: TextButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    // visualDensity: VisualDensity.compact, // Make slightly smaller
                  ),
                )
              ],
            ),
            const SizedBox(height: 12),

            // Only show details if budgets exist
            if (hasBudgets) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Budget:", style: theme.textTheme.bodyMedium),
                  Text(MoneyUtil.formatDefault(totalBudget),
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Spent:", style: theme.textTheme.bodyMedium),
                  Text(MoneyUtil.formatDefault(totalSpending),
                      style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.error)),
                ],
              ),
              const Divider(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Remaining:",
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  Text(
                    MoneyUtil.formatDefault(remaining),
                    style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold, color: remainingColor),
                  ),
                ],
              ),
            ] else ...[
              // Message when no budgets are set yet inside the card
              const SizedBox(height: 10),
              Center(
                child: Text(
                  "No monthly budgets set yet. Tap 'Add' to create one.",
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: theme.hintColor),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 10),
            ]
          ],
        ),
      ),
    );
  }

  // Budget List Item remains the same
  Widget _buildBudgetListItem({
    required BuildContext context,
    required Budget budget,
    required double actualSpending,
    required VoidCallback onTap,
    required Function(String) onDismissed,
  }) {
    final theme = Theme.of(context);
    double progress = 0.0;
    if (budget.amount > 0) {
      progress = (actualSpending / budget.amount).clamp(0.0, 1.0);
    }
    Color progressColor = Colors.green.shade600;
    if (progress > 0.9)
      progressColor = Colors.red.shade600;
    else if (progress > 0.7) progressColor = Colors.orange.shade600;

    final budgetActivityType =
        _convertBudgetCategoryToActivityType(budget.category);

    return Dismissible(
      key: Key(budget.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.redAccent.withOpacity(0.8),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20.0),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      onDismissed: (_) => onDismissed(budget.id),
      child: ListTile(
        leading: Icon(_getIconForCategory(budgetActivityType),
            color: theme.colorScheme.primary),
        title: Text(_formatEnumName(budget.category),
            style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                'Budget: ${MoneyUtil.formatDefault(budget.amount)} / ${_formatEnumName(budget.period)}'),
            const SizedBox(height: 4),
            // Conditionally show progress based on period (simplified to monthly)
            if (budget.period == BudgetPeriod.monthly) ...[
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      // Add rounded corners to progress bar
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: theme.dividerColor.withOpacity(0.3),
                        valueColor:
                            AlwaysStoppedAnimation<Color>(progressColor),
                        minHeight: 8, // Slightly thicker
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text('${(progress * 100).toStringAsFixed(0)}%',
                      style: theme.textTheme.bodySmall
                          ?.copyWith(fontWeight: FontWeight.w600)),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  'Spent: ${MoneyUtil.formatDefault(actualSpending)}',
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.hintColor),
                ),
              ),
            ]
          ],
        ),
        trailing:
            Icon(Icons.edit_note_outlined, size: 22, color: theme.hintColor),
        // Edit icon
        onTap: onTap,
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 16.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.account_balance_wallet_outlined,
                size: 60, color: Theme.of(context).hintColor),
            const SizedBox(height: 16),
            const Text('No budgets set yet.', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text(
              'Tap the + button to add your first budget.',
              style: TextStyle(color: Theme.of(context).hintColor),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // Helper to get date range (same as before)
  ({DateTime start, DateTime end}) _getThisMonthRange() {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, 1);
    final end = (now.month < 12)
        ? DateTime(now.year, now.month + 1, 1)
        : DateTime(now.year + 1, 1, 1);
    return (start: start, end: end);
  }
}
