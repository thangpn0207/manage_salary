import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:manage_salary/bloc/activity/activity_event.dart';
import 'package:manage_salary/core/config/build_config.dart';
import 'package:manage_salary/ui/components/banner_ad_widget.dart';
import 'package:manage_salary/ui/components/base_button.dart';
import 'package:manage_salary/ui/home/widgets/activity_list/activity_tabs_view.dart';
import 'package:manage_salary/ui/home/widgets/bottom_sheet/show_add_activity_sheet.dart';
import 'package:manage_salary/ui/home/widgets/card_dashboard/card_dashboard.dart';

import '../../bloc/activity/activity_bloc.dart';
import '../../core/dependency/injection.dart';
import '../../core/locale/generated/l10n.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Example list to hold activities - you'd likely use a proper state management solution

  void _handleAddNewActivity() async {
    // Show the bottom sheet and wait for the result
    final newActivity = await showAddActivitySheet(context);

    // If the user added an activity (didn't dismiss), add it to the list
    if (newActivity != null) {
      getIt<ActivityBloc>().add(AddActivity(newActivity));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(S.current.addActivitySuccess(newActivity.title)),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.current.dashboard,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            BuildConfig.enableAds
                ? Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: BannerAdWidget(),
                  )
                : SizedBox.shrink(),
            SizedBox(height: 500, child: DashboardCard()),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child: SizedBox(
                width: 350,
                child: Row(
                  children: [
                    Expanded(
                      child: BaseButton(
                          text: S.current.addActivity,
                          onPressed: _handleAddNewActivity,
                          icon: const Icon(Icons.add)),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 500.h, child: ActivityTabsView()),
            SizedBox(
              height: 50.h,
            ),
          ],
        ),
      ),
    );
  }
}
