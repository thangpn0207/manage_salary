import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:manage_salary/core/constants/enums.dart';
import 'package:manage_salary/core/util/money_util.dart';

import '../../models/activity_data.dart'; // For currency formatting

class ActivityListItem extends StatelessWidget {
  final ActivityData activity; // Pass the whole data object
  final VoidCallback? onTap;
  final Function(String)? onDismissed; // Callback with ID when dismissed

  const ActivityListItem({
    super.key,
    required this.activity,
    this.onTap,
    this.onDismissed,
  });

  // Combined helper to get icon based on the ActivityType
  IconData _getIconForType(ActivityType type) {
    switch (type) {
      // Income types
      case ActivityType.salary:
        return Icons.wallet_outlined;
      case ActivityType.freelance:
        return Icons.work_history_outlined;
      case ActivityType.investment:
        return Icons.trending_up;
      case ActivityType.incomeOther:
        return Icons.attach_money;

      // Expense types
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
        return Icons.flight_takeoff_outlined; // Updated icon
      case ActivityType.expenseOther:
      // Fallback icon for expenseOther or any unexpected value
        return Icons.receipt_long_outlined;
    }
  }

  // Format date like "Apr 22, 2024"
  String _formatDate(DateTime date) {
    return DateFormat('MMM d, yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    // Determine colors
    final Color iconBackgroundColor = colorScheme.surfaceContainerHighest;
    final Color iconColor = colorScheme.onSurfaceVariant;
    final Color amountColor = activity.nature == ActivityNature.income
        ? Colors.green.shade700 // Consider using theme colors like colorScheme.tertiary
        : colorScheme.error; // Use theme error color for expenses

    final itemContent = ListTile(
      onTap: onTap,
      leading: Container(
        width: 48,
        height: 48,
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: iconBackgroundColor,
          borderRadius: BorderRadius.circular(12.0),
        ),
        // Use the updated icon helper and the activity's type field
        child: Icon(_getIconForType(activity.type), color: iconColor, size: 24.0),
      ),
      title: Text(
        activity.title,
        style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        _formatDate(activity.date),
        style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Text(
        // Add sign based on nature for clarity
        '${activity.nature == ActivityNature.income ? '+' : '-'}${MoneyUtil.formatDefault(activity.amount)}',
        style: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: amountColor,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      contentPadding:
          const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0), // Adjusted padding
    );

    // Wrap with Dismissible if onDismissed callback is provided
    if (onDismissed != null) {
      return Dismissible(
        key: Key(activity.id),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) => onDismissed!(activity.id),
        background: Container(
          color: Colors.redAccent.withValues(alpha: 0.8),
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20.0),
          child: const Icon(Icons.delete_outline, color: Colors.white),
        ),
        child: itemContent,
      );
    } else {
      return itemContent;
    }
  }
}
