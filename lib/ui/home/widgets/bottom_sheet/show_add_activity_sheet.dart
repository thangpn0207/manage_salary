import 'package:flutter/material.dart';

// Import the necessary files
import '../../../../models/activity_data.dart';
import 'add_activity_sheet_content.dart'; // The _AddActivitySheetContent widget defined above

/// Shows the modal bottom sheet for adding a new activity.
///
/// Returns a Future that completes with the [ActivityData] if the user
/// successfully adds an activity, or null if the sheet is dismissed.
Future<ActivityData?> showAddActivitySheet(BuildContext context) {
  return showModalBottomSheet<ActivityData>(
    context: context,
    // Make sheet scrollable and avoid resizing when keyboard appears
    isScrollControlled: true,
    // Use rounded corners that match the theme
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
    ),
    // Set background color based on theme (optional, usually handled by theme)
    // backgroundColor: Theme.of(context).canvasColor,
    builder: (BuildContext builderContext) {
      // Pass the context from the builder to the sheet content if needed,
      // but usually the context passed to showModalBottomSheet is sufficient.
      return const AddActivitySheetContent();
    },
  );
}
