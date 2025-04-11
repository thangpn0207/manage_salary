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

  // Get icon based on type and category
  IconData _getIcon() {
    // Otherwise (expense), use category icon
    return _getIconForExpenseCategory(
        activity.activityType ?? ActivityPaying.other);
  }

  // Specific helper for expense category icons
  IconData _getIconForExpenseCategory(ActivityPaying cat) {
    switch (cat) {
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
        return Icons.directions_car_outlined; // Match image better?
      case ActivityPaying.savings:
        return Icons.savings_outlined;
      case ActivityPaying.other:
      default:
        return Icons.receipt_long_outlined;
    }
  }

  // Format date like "Apr 22"
  String _formatDate(DateTime date) {
    return DateFormat('MMM d yyyy').format(date); // e.g., Apr 22
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    // Define colors based on image - Use theme variants for adaptability
    final Color iconBackgroundColor =
        colorScheme.surfaceContainerHighest; // Light greyish
    final Color iconColor =
        colorScheme.onSurfaceVariant; // Darker grey for icon
    final Color amountColor = activity.nature == ActivityNature.income
        ? Colors.green.shade700 // Green for income amount
        : Colors.red.shade700; // Default text color for expense amount

    final itemContent = ListTile(
      onTap: onTap,
      leading: Container(
        width: 48,
        // Fixed width for consistency
        height: 48,
        // Fixed height for consistency
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: iconBackgroundColor,
          borderRadius: BorderRadius.circular(12.0), // Rounded corners
        ),
        child: Icon(_getIcon(), color: iconColor, size: 24.0),
      ),
      title: Text(
        activity.title, // Use title from data
        style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
        // Slightly bold
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        _formatDate(activity.date), // Format the date
        style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor),
        maxLines: 1, overflow: TextOverflow.ellipsis,
      ),
      trailing: Text(
        MoneyUtil.formatDefault(activity.amount), // Format amount without sign
        style: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: amountColor, // Color based on nature
        ),
        maxLines: 1, overflow: TextOverflow.ellipsis,
      ),
      contentPadding: const EdgeInsets.symmetric(
          vertical: 8.0, horizontal: 20), // Adjust padding as needed
    );

    // Wrap with Dismissible if onDismissed callback is provided
    if (onDismissed != null) {
      return Dismissible(
        key: Key(activity.id),
        // MUST use a unique key per item (activity.id)
        direction: DismissDirection.endToStart,
        // Swipe left to delete
        onDismissed: (direction) => onDismissed!(activity.id),
        // Call callback with ID
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
