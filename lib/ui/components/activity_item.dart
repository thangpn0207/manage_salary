import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:manage_salary/core/constants/enums.dart'; // For currency formatting

// Assume ActivityPaying enum is defined above or in another file

class ActivityListItem extends StatelessWidget {
  final ActivityPaying activityType;
  final String title;
  final String subtitle; // e.g., Date as String
  final double amount;
  final VoidCallback? onTap; // Optional tap action

  const ActivityListItem({
    super.key,
    required this.activityType,
    required this.title,
    required this.subtitle,
    required this.amount,
    this.onTap,
  });

  // Helper function to get the appropriate icon based on the enum
  IconData _getIconForActivity(ActivityPaying type) {
    switch (type) {
      case ActivityPaying.shopping:
        return Icons.shopping_bag_outlined;
      case ActivityPaying.foodAndDrinks:
        return Icons.restaurant_menu_outlined; // Or Icons.local_dining
      case ActivityPaying.utilities:
        return Icons.lightbulb_outline;
      case ActivityPaying.rent:
        return Icons.house_outlined;
      case ActivityPaying.groceries:
        return Icons.shopping_cart_outlined;
      case ActivityPaying.entertainment:
        return Icons.movie_filter_outlined; // Or Icons.local_activity
      case ActivityPaying.education:
        return Icons.school_outlined;
      case ActivityPaying.healthcare:
        return Icons.local_hospital_outlined; // Or Icons.health_and_safety
      case ActivityPaying.travel:
        return Icons.flight_takeoff_outlined; // Or Icons.directions_car
      case ActivityPaying.savings:
        return Icons.savings_outlined;
      case ActivityPaying.other:
      return Icons.receipt_long_outlined; // Default icon
    }
  }

  // Helper function to format the currency
  String _formatCurrency(double value) {
    // Adjust locale and symbol as needed (e.g., 'en_US', 'EUR')
    final format = NumberFormat.simpleCurrency(locale: 'en_US');
    return format.format(value);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    // Define colors for the icon container and icon itself
    // Using theme colors makes it adapt to light/dark mode
    final Color iconBackgroundColor = colorScheme.secondaryContainer.withOpacity(0.5);
    final Color iconColor = colorScheme.onSecondaryContainer;

    return ListTile(
      onTap: onTap,
      // Increase content padding slightly if needed
      // contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      leading: Container(
        padding: const EdgeInsets.all(10.0), // Padding inside the container
        decoration: BoxDecoration(
          color: iconBackgroundColor,
          borderRadius: BorderRadius.circular(12.0), // Rounded corners
        ),
        child: Icon(
          _getIconForActivity(activityType),
          color: iconColor,
          size: 24.0, // Standard icon size
        ),
      ),
      title: Text(
        title,
        style: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w600, // Slightly bold title
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        subtitle,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.hintColor, // Use a less prominent color for subtitle
        ),
         maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Text(
        _formatCurrency(amount),
        style: theme.textTheme.bodyLarge?.copyWith(
           fontWeight: FontWeight.w600, // Match title weight
           // Consider a specific color if needed, e.g., colorScheme.primary
        ),
         maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}