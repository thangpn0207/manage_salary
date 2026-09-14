import 'package:manage_salary/ui/home/widgets/home_sliver_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:manage_salary/bloc/activity/activity_event.dart';
import 'package:manage_salary/ui/components/banner_ad_widget.dart';
import 'package:manage_salary/ui/home/widgets/activity_list/activity_tabs_view.dart';
import 'package:manage_salary/ui/home/widgets/bottom_sheet/show_add_activity_sheet.dart';
import 'package:manage_salary/ui/home/widgets/card_dashboard/card_dashboard.dart';

import '../../bloc/activity/activity_bloc.dart';
import '../../core/constants/colors.dart';
import '../../core/dependency/injection.dart';
import '../../core/locale/generated/l10n.dart';
import '../../core/routes/app_router.dart';
import '../../core/services/ad_manager.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Example list to hold activities - you'd likely use a proper state management solution

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AdManager.instance.showAppOpenAdIfAvailable();
    });
  }

  void _handleAddNewActivity() async {
    // Show the bottom sheet and wait for the result
    final newActivity = await showAddActivitySheet(context);

    // If the user added an activity (didn't dismiss), add it to the list
    if (newActivity != null) {
      getIt<ActivityBloc>().add(AddActivity(newActivity));
      // Tối ưu ads: Đếm hành động và hiển thị Interstitial khi đạt ngưỡng
      AdManager.instance.showInterstitialAd();
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
      
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            HomeSliverAppBar(innerBoxIsScrolled: innerBoxIsScrolled),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: BannerAdWidget(),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 8.0),
                    child: DashboardCard(),
                  ),

                  // Salary & Attendance Quick Card (Nordic Minimalist Aesthetic)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
                    child: Builder(
                      builder: (context) {
                        final isDark = Theme.of(context).brightness == Brightness.dark;
                        return InkWell(
                          onTap: () => context.push(AppRoutes.salary),
                          borderRadius: BorderRadius.circular(18.r),
                          child: Container(
                            padding:
                                EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.darkSurface : Colors.white,
                              borderRadius: BorderRadius.circular(18.r),
                              border: Border.all(
                                color: isDark ? AppColors.darkOutline : AppColors.outline,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(10.w),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: Icon(Icons.calendar_month_rounded,
                                      color: AppColors.primary, size: 22.sp),
                                ),
                                SizedBox(width: 14.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        S.current.salaryAndAttendance,
                                        style: TextStyle(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.bold,
                                          color: isDark ? Colors.white : AppColors.onBackground,
                                        ),
                                      ),
                                      SizedBox(height: 3.h),
                                      Text(
                                        '${S.current.oneTapCheckIn} • OT • ${S.current.advanceStat}',
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(6.w),
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? Colors.white.withValues(alpha: 0.06)
                                        : Colors.black.withValues(alpha: 0.04),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: isDark ? Colors.white70 : AppColors.onBackground,
                                    size: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildActionCard(
                            context,
                            title: S.current.addActivity,
                            icon: Icons.add_circle_outline_rounded,
                            color: AppColors.primary,
                            onTap: _handleAddNewActivity,
                            isDark: Theme.of(context).brightness == Brightness.dark,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: _buildActionCard(
                            context,
                            title: S.current.travelNotes,
                            icon: Icons.flight_takeoff_rounded,
                            color: AppColors.accent,
                            onTap: () => context.push(AppRoutes.trips),
                            isDark: Theme.of(context).brightness == Brightness.dark,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ];
        },
        body: const ActivityTabsView(),
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 12.w),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isDark ? AppColors.darkOutline : AppColors.outline,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24.sp),
            ),
            SizedBox(height: 10.h),
            Text(
              title,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : AppColors.secondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

