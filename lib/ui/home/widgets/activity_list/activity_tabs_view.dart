import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/activity/activity_bloc.dart';
import '../../../../bloc/activity/activity_event.dart'; // Import the event
import '../../../../bloc/activity/activity_state.dart';
import '../../../../core/constants/enums.dart';
import '../../../../core/locale/generated/l10n.dart'; // Import generated localization
import '../../../../models/activity_data.dart';
import '../../../components/activity_item.dart';

class ActivityTabsView extends StatefulWidget {
  const ActivityTabsView({super.key});

  @override
  State<ActivityTabsView> createState() => _ActivityTabsViewState();
}

class _ActivityTabsViewState extends State<ActivityTabsView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // Initialize TabController with 2 tabs (Income, Expense)
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose(); // Important to dispose the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Use BlocBuilder (or your state management equivalent)
    // to listen for changes in the activity list
    return BlocBuilder<ActivityBloc, ActivityState>(
      builder: (context, state) {
        // --- Filter activities based on ActivityNature ---
        // Assuming state.allActivities holds the full list, potentially sorted
        final allActivities = state.allActivities;

        final incomeActivities = allActivities
            .where((activity) => activity.nature == ActivityNature.income)
            .toList();

        final expenseActivities = allActivities
            .where((activity) => activity.nature == ActivityNature.expense)
            .toList();

        // --- Build the UI with Tabs ---
        return Column(
          children: [
            // The TabBar itself
            TabBar(
              controller: _tabController,
              tabs: [
                Tab(text: S.of(context).income), // Use localization
                Tab(text: S.of(context).expenses), // Use localization
              ],
              // Customize appearance as needed
              labelColor: Theme.of(context).colorScheme.primary,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Theme.of(context).colorScheme.primary,
              indicatorSize: TabBarIndicatorSize.tab,
            ),
            Expanded(
              // Ensures TabBarView fills the remaining space
              child: TabBarView(
                controller: _tabController,
                children: [
                  // --- Income Tab Content ---
                  _buildActivityListView(
                    context, // Pass context
                    incomeActivities,
                    S.of(context).noIncomeActivities, // Use localization
                  ),

                  // --- Expense Tab Content ---
                  _buildActivityListView(
                    context, // Pass context
                    expenseActivities,
                    S.of(context).noExpenseActivities, // Use localization
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  // --- Helper Widget to build the ListView ---
  Widget _buildActivityListView(
    BuildContext context, // Need context to access BLoC
    List<ActivityData> activities,
    String emptyListMessage,
  ) {
    if (activities.isEmpty) {
      return Center(
        child: Text(
          emptyListMessage, // Already uses the localized string passed in
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: Colors.grey),
        ),
      );
    }

    // Use ListView.builder for performance with long lists
    return ListView.builder(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 8.0), // Add some padding
      itemCount: activities.length,
      itemBuilder: (context, index) {
        final activity = activities[index];
        // Use your existing ActivityListItem widget
        // *** MODIFIED: Added onDismissed callback ***
        return ActivityListItem(
          activity: activity,
          onDismissed: (activityId) {
            // Dispatch the RemoveActivity event using the BLoC
            context.read<ActivityBloc>().add(RemoveActivity(activityId));
            // Optional: Show a snackbar to confirm deletion or offer undo
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                // Use localization for the snackbar message
                content: Text(S.of(context).activityDeleted(activity.title)),
                duration: const Duration(seconds: 2),
                // Optionally add an Undo action
              ),
            );
          },
        );
      },
    );
  }
}
