import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manage_salary/core/config/build_config.dart';
import 'package:manage_salary/core/constants/enums.dart';
import 'package:manage_salary/core/locale/generated/l10n.dart';
import 'package:manage_salary/core/util/convert_enum.dart';
import 'package:manage_salary/core/util/localization_utils.dart';
import 'package:manage_salary/core/util/money_util.dart';
import 'package:manage_salary/models/budget.dart';
import 'package:manage_salary/ui/budget/widgets/add_edit_budget_sheet.dart';
import 'package:manage_salary/ui/components/banner_ad_widget.dart';

import '../../../bloc/activity/activity_bloc.dart';
import '../../../bloc/activity/activity_event.dart';
import '../../../bloc/activity/activity_state.dart';

class BudgetManagementScreen extends StatelessWidget {
  const BudgetManagementScreen({super.key});

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

  void _showAddEditBudgetDialog(BuildContext context, {Budget? budget}) async {
    final resultBudget = await showAddEditBudgetSheet(context, budget: budget);
    if (resultBudget != null && context.mounted) {
      if (budget == null) {
        context.read<ActivityBloc>().add(AddBudget(resultBudget));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  '${localizedActivityPaying(context, convertBudgetCategoryToActivityType(resultBudget.category))} ${S.of(context).addBudget.toLowerCase()}')),
        );
      } else {
        context.read<ActivityBloc>().add(UpdateBudget(resultBudget));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  '${localizedActivityPaying(context, convertBudgetCategoryToActivityType(resultBudget.category))} ${S.of(context).editBudget.toLowerCase()}')),
        );
      }
    }
  }

  void _confirmAndRemoveBudget(
      BuildContext context, String budgetId, String categoryName) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        final s = S.of(context);
        return AlertDialog(
          title: Text(s.confirmDeletion),
          content: Text(S.current.confirmBudgetDeletion(categoryName)),
          actions: <Widget>[
            TextButton(
              child: Text(s.cancelButton),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: Text(s.remove),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.read<ActivityBloc>().add(RemoveBudget(budgetId));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(s.budgetRemoved(categoryName)),
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
    final s = S.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(s.manageBudgets),
      ),
      body: BlocBuilder<ActivityBloc, ActivityState>(
        builder: (context, state) {
          Map<ActivityType, double> monthlySpendingByType = {};
          final monthRange = _getThisMonthRange();
          state.allActivities
              .where((a) =>
                  a.nature == ActivityNature.expense &&
                  !a.date.isBefore(monthRange.start) &&
                  a.date.isBefore(monthRange.end))
              .forEach((activity) {
            monthlySpendingByType.update(
                activity.type, (value) => value + activity.amount,
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
            children: [
              BuildConfig.enableAds
                  ? Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: BannerAdWidget(),
                    )
                  : SizedBox.shrink(),
              _buildSummaryCardWithAddButton(
                context: context,
                period: s.budgetPeriodMonthly,
                totalBudget: totalMonthlyBudget,
                totalSpending: actualMonthlySpending,
                remaining: remainingMonthly,
                onAddBudget: () => _showAddEditBudgetDialog(context),
              ),
              if (state.budgets.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 8.0),
                  child: Text(
                    s.budgetDetails,
                    style: theme.textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              if (state.budgets.isEmpty)
                _buildEmptyState(context)
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: state.budgets.length,
                  itemBuilder: (context, index) {
                    final budget = state.budgets[index];
                    final activityType =
                        convertBudgetCategoryToActivityType(budget.category);

                    double spendingForBudget = 0;
                    if (budget.period == BudgetPeriod.monthly) {
                      spendingForBudget =
                          monthlySpendingByType[activityType] ?? 0.0;
                    }

                    return _buildBudgetListItem(
                      context: context,
                      budget: budget,
                      actualSpending: spendingForBudget,
                      onTap: () =>
                          _showAddEditBudgetDialog(context, budget: budget),
                      onDismissed: (id) => _confirmAndRemoveBudget(context, id,
                          localizedActivityPaying(context, activityType)),
                    );
                  },
                  separatorBuilder: (context, index) => Divider(
                    height: 1,
                    thickness: 1,
                    indent: 16,
                    endIndent: 16,
                    color: theme.dividerColor.withValues(alpha: 0.5),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSummaryCardWithAddButton({
    required BuildContext context,
    required String period,
    required double totalBudget,
    required double totalSpending,
    required double remaining,
    required VoidCallback onAddBudget,
  }) {
    final theme = Theme.of(context);
    final s = S.of(context);
    final remainingColor =
        remaining >= 0 ? Colors.green.shade700 : theme.colorScheme.error;
    final hasBudgets = totalBudget > 0;

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
                Text('$period ${s.budgetSummary}',
                    style: theme.textTheme.titleMedium),
                TextButton.icon(
                  onPressed: onAddBudget,
                  icon: const Icon(Icons.add_circle_outline, size: 20),
                  label: Text(s.add),
                  style: TextButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  ),
                )
              ],
            ),
            const SizedBox(height: 12),
            if (hasBudgets) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${s.budget}:', style: theme.textTheme.bodyMedium),
                  Text(MoneyUtil.formatDefault(totalBudget),
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${s.spent}:', style: theme.textTheme.bodyMedium),
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
                  Text('${s.remaining}:',
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
              const SizedBox(height: 10),
              Center(
                child: Text(
                  s.noBudgetsSet,
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

  Widget _buildBudgetListItem({
    required BuildContext context,
    required Budget budget,
    required double actualSpending,
    required VoidCallback onTap,
    required Function(String) onDismissed,
  }) {
    final theme = Theme.of(context);
    final s = S.of(context);
    double progress = 0.0;
    if (budget.amount > 0) {
      progress = (actualSpending / budget.amount).clamp(0.0, 1.0);
    }
    Color progressColor = Colors.green.shade600;
    if (progress > 0.9) {
      progressColor = Colors.red.shade600;
    } else if (progress > 0.7) {
      progressColor = Colors.orange.shade600;
    }

    final budgetActivityType =
        convertBudgetCategoryToActivityType(budget.category);

    return Dismissible(
      key: Key(budget.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.redAccent.withValues(alpha: 0.8),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20.0),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      onDismissed: (_) => onDismissed(budget.id),
      child: ListTile(
        leading: Icon(_getIconForCategory(budgetActivityType),
            color: theme.colorScheme.primary),
        title: Text(localizedActivityPaying(context, budgetActivityType),
            style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                '${s.budget}: ${MoneyUtil.formatDefault(budget.amount)} / ${localizedActivityPaying(context, budgetActivityType)}'),
            const SizedBox(height: 4),
            if (budget.period == BudgetPeriod.monthly) ...[
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor:
                            theme.dividerColor.withValues(alpha: 0.3),
                        valueColor:
                            AlwaysStoppedAnimation<Color>(progressColor),
                        minHeight: 8,
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
                  '${s.spent}: ${MoneyUtil.formatDefault(actualSpending)}',
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.hintColor),
                ),
              ),
            ]
          ],
        ),
        trailing:
            Icon(Icons.edit_note_outlined, size: 22, color: theme.hintColor),
        onTap: onTap,
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final s = S.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 16.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.account_balance_wallet_outlined,
                size: 60, color: Theme.of(context).hintColor),
            const SizedBox(height: 16),
            Text(s.noBudgetsSet, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text(
              s.tapToAddBudget,
              style: TextStyle(color: Theme.of(context).hintColor),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  ({DateTime start, DateTime end}) _getThisMonthRange() {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, 1);
    final end = (now.month < 12)
        ? DateTime(now.year, now.month + 1, 1)
        : DateTime(now.year + 1, 1, 1);
    return (start: start, end: end);
  }
}
