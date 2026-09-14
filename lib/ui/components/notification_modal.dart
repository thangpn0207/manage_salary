import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../bloc/salary/salary_bloc.dart';
import '../../bloc/salary/salary_event.dart';
import '../../bloc/salary/salary_state.dart';
import '../../core/constants/colors.dart';
import '../../core/locale/generated/l10n.dart';
import '../../core/routes/app_router.dart';

void showNotificationModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) => const NotificationModalSheet(),
  );
}

class NotificationModalSheet extends StatelessWidget {
  const NotificationModalSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
        top: 16.h,
        bottom: MediaQuery.of(context).padding.bottom + 20.h,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        border: Border.all(
          color: isDark ? AppColors.darkOutline : AppColors.outline,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 36.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
          SizedBox(height: 16.h),

          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Icon(
                      Icons.notifications_active_rounded,
                      color: AppColors.secondary,
                      size: 20.sp,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    S.current.notifications,
                    style: TextStyle(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppColors.onBackground,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Notification Cards List
          BlocBuilder<SalaryBloc, SalaryState>(
            builder: (context, salaryState) {
              final today = DateTime.now();
              final hasCheckedInToday = salaryState.attendances.any(
                (a) =>
                    a.date.year == today.year &&
                    a.date.month == today.month &&
                    a.date.day == today.day,
              );

              return Column(
                children: [
                  // Attendance card
                  _buildNotificationTile(
                    context: context,
                    isDark: isDark,
                    icon: hasCheckedInToday
                        ? Icons.check_circle_outline_rounded
                        : Icons.alarm_rounded,
                    iconColor: hasCheckedInToday
                        ? AppColors.upGreen
                        : AppColors.secondary,
                    title: hasCheckedInToday
                        ? S.current.checkedInToday
                        : S.current.notCheckedInToday,
                    subtitle: hasCheckedInToday
                        ? '${S.current.workDaysStat}: ${salaryState.totalWorkDays} • OT: ${salaryState.totalOtHours}h'
                        : S.current.quickAttendanceSubtitle,
                    actionWidget: hasCheckedInToday
                        ? null
                        : TextButton(
                            onPressed: () {
                              context
                                  .read<SalaryBloc>()
                                  .add(const QuickCheckInToday(status: 'full'));
                              Navigator.pop(context);
                            },
                            child: Text(
                              S.current.oneTapCheckIn,
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                  ),
                  SizedBox(height: 10.h),

                  // Salary summary action
                  _buildNotificationTile(
                    context: context,
                    isDark: isDark,
                    icon: Icons.account_balance_wallet_outlined,
                    iconColor: AppColors.primary,
                    title: S.current.salaryAndAttendance,
                    subtitle: S.current.estimatedSalary,
                    actionWidget: IconButton(
                      icon: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                      onPressed: () {
                        Navigator.pop(context);
                        context.push(AppRoutes.salary);
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationTile({
    required BuildContext context,
    required bool isDark,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    Widget? actionWidget,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceContainer : AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark ? AppColors.darkOutline : AppColors.outline,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 20.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : AppColors.onBackground,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          if (actionWidget != null) actionWidget,
        ],
      ),
    );
  }
}
