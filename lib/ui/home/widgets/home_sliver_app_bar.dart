import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:manage_salary/bloc/activity/activity_bloc.dart';
import 'package:manage_salary/bloc/activity/activity_state.dart';
import 'package:manage_salary/bloc/salary/salary_bloc.dart';
import 'package:manage_salary/bloc/salary/salary_state.dart';
import 'package:manage_salary/core/constants/colors.dart';
import 'package:manage_salary/core/locale/generated/l10n.dart';
import 'package:manage_salary/core/util/money_util.dart';
import 'package:manage_salary/ui/components/notification_modal.dart';

class HomeSliverAppBar extends StatelessWidget {
  final bool innerBoxIsScrolled;

  const HomeSliverAppBar({super.key, required this.innerBoxIsScrolled});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SliverAppBar(
      pinned: true,
      expandedHeight: 100.h,
      elevation: innerBoxIsScrolled ? 4 : 0,
      backgroundColor: theme.scaffoldBackgroundColor,
      surfaceTintColor: theme.scaffoldBackgroundColor,
      actions: [
        BlocBuilder<SalaryBloc, SalaryState>(
          builder: (context, salaryState) {
            final today = DateTime.now();
            final hasCheckedInToday = salaryState.attendances.any(
              (a) =>
                  a.date.year == today.year &&
                  a.date.month == today.month &&
                  a.date.day == today.day,
            );

            return Padding(
              padding: EdgeInsets.only(right: 12.w),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications_none_rounded),
                    tooltip: S.current.notifications,
                    onPressed: () => showNotificationModal(context),
                  ),
                  if (!hasCheckedInToday)
                    Positioned(
                      top: 10.h,
                      right: 10.w,
                      child: Container(
                        width: 9.w,
                        height: 9.w,
                        decoration: const BoxDecoration(
                          color: AppColors.secondary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ],
      flexibleSpace: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          // The height goes from expandedHeight down to kToolbarHeight + safe area
          final top = constraints.biggest.height;
          final minHeight = MediaQuery.of(context).padding.top + kToolbarHeight;
          final maxHeight = 100.h + MediaQuery.of(context).padding.top;
          
          final t = ((maxHeight - top) / (maxHeight - minHeight)).clamp(0.0, 1.0);

          return FlexibleSpaceBar(
            titlePadding: EdgeInsets.zero,
            background: Padding(
              padding: EdgeInsets.only(
                left: 16.w,
                right: 16.w,
                bottom: 12.h,
                top: MediaQuery.of(context).padding.top,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    S.current.dashboard,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 28.sp,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    "Welcome back!",
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            // The title appears when collapsed
            title: Opacity(
              opacity: t,
              child: BlocBuilder<ActivityBloc, ActivityState>(
                builder: (context, state) {
                  return Padding(
                    padding: EdgeInsets.only(left: 16.w),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(6.w),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.account_balance_wallet_rounded,
                            color: AppColors.primary,
                            size: 16.sp,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          MoneyUtil.formatDefault(state.netBalance),
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                            color: state.netBalance >= 0
                                ? (isDark ? Colors.white : const Color(0xFF0F172A))
                                : const Color(0xFFEF4444),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
