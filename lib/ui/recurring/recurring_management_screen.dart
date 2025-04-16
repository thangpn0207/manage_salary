import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:manage_salary/bloc/activity/activity_bloc.dart';
import 'package:manage_salary/bloc/activity/activity_event.dart';
import 'package:manage_salary/bloc/activity/activity_state.dart';
import 'package:manage_salary/core/config/build_config.dart';
import 'package:manage_salary/core/constants/enums.dart';
import 'package:manage_salary/core/locale/generated/l10n.dart';
import 'package:manage_salary/core/util/localization_utils.dart';
import 'package:manage_salary/core/util/money_util.dart';
import 'package:manage_salary/core/util/custom_fab_position.dart';
import 'package:manage_salary/models/recurring_activity.dart';
import 'package:manage_salary/ui/components/banner_ad_widget.dart';
import 'package:manage_salary/ui/recurring/widgets/add_edit_recurring_sheet.dart';

class RecurringManagementScreen extends StatelessWidget {
  const RecurringManagementScreen({super.key});

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

  void _showAddEditRecurringDialog(BuildContext context,
      {RecurringActivity? activity}) async {
    final resultActivity =
        await showAddEditRecurringSheet(context, activity: activity);
    if (resultActivity != null && context.mounted) {
      if (activity == null) {
        context.read<ActivityBloc>().add(AddRecurringActivity(resultActivity));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                '${localizedActivityPaying(context, resultActivity.type)} ${S.of(context).added.toLowerCase()}'),
          ),
        );
      } else {
        context
            .read<ActivityBloc>()
            .add(UpdateRecurringActivity(resultActivity));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                '${localizedActivityPaying(context, resultActivity.type)} ${S.of(context).updated.toLowerCase()}'),
          ),
        );
      }
    }
  }

  void _confirmAndRemoveRecurring(
      BuildContext context, String activityId, String activityName) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        final s = S.of(context);
        return AlertDialog(
          title: Text(s.confirmDeletion),
          content: Text(
              'Are you sure you want to remove the recurring "$activityName" activity?'),
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
                context
                    .read<ActivityBloc>()
                    .add(RemoveRecurringActivity(activityId));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(s.activityRemoved(activityName)),
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
    final screenWidth = ScreenUtil().screenWidth;
    final screenHeight = ScreenUtil().screenHeight;
    return Scaffold(
      appBar: AppBar(
        title: Text(s.manageRecurring),
      ),
      floatingActionButtonLocation: CustomFloatingActionButtonLocation(
        x: screenWidth - 20,
        y: screenHeight - 170, // Position from top
      ),
      body: Column(
        children: [
          BuildConfig.enableAds
              ? Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: BannerAdWidget(),
                )
              : SizedBox.shrink(),
          BlocBuilder<ActivityBloc, ActivityState>(
            builder: (context, state) {
              if (state.recurringActivities.isEmpty) {
                return _buildEmptyState(context);
              }

              return ListView.separated(
                padding: const EdgeInsets.only(bottom: 80),
                itemCount: state.recurringActivities.length,
                itemBuilder: (context, index) {
                  final recurring = state.recurringActivities[index];
                  return _buildRecurringListItem(
                    context: context,
                    recurring: recurring,
                    onTap: () => _showAddEditRecurringDialog(context,
                        activity: recurring),
                    onDismissed: (id) => _confirmAndRemoveRecurring(
                      context,
                      id,
                      recurring.title,
                    ),
                  );
                },
                separatorBuilder: (context, index) => Divider(
                  height: 1,
                  thickness: 1,
                  indent: 16,
                  endIndent: 16,
                  color: theme.dividerColor.withOpacity(0.5),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: BlocBuilder<ActivityBloc, ActivityState>(
        builder: (context, state) {
          if (state.recurringActivities.isEmpty) {
            return const SizedBox.shrink();
          }
          return FloatingActionButton.extended(
            onPressed: () => _showAddEditRecurringDialog(context),
            icon: const Icon(Icons.add),
            label: Text(s.addRecurring),
          );
        },
      ),
    );
  }

  Widget _buildRecurringListItem({
    required BuildContext context,
    required RecurringActivity recurring,
    required VoidCallback onTap,
    required Function(String) onDismissed,
  }) {
    final theme = Theme.of(context);

    return Dismissible(
      key: Key(recurring.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.redAccent.withOpacity(0.8),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20.0),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      onDismissed: (_) => onDismissed(recurring.id),
      child: ListTile(
        leading: Icon(_getIconForType(recurring.type),
            color: theme.colorScheme.primary),
        title: Text(recurring.title,
            style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(MoneyUtil.formatDefault(recurring.amount)),
            Text(
              '${localizedRecurringFrequency(context, recurring.frequency)} • ${localizedActivityPaying(context, recurring.type)}',
              style:
                  theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
            ),
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
            Icon(Icons.repeat, size: 60, color: Theme.of(context).hintColor),
            const SizedBox(height: 16),
            Text(
              s.noRecurringActivities,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              s.addRecurringDescription,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Theme.of(context).hintColor),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => _showAddEditRecurringDialog(context),
              icon: const Icon(Icons.add),
              label: Text(s.addRecurring),
            ),
          ],
        ),
      ),
    );
  }
}
