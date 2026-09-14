import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:manage_salary/core/locale/generated/l10n.dart';
import 'package:manage_salary/core/util/localization_utils.dart';
import 'package:manage_salary/core/util/money_util.dart';
import 'package:manage_salary/ui/home/widgets/card_dashboard/card_info.dart';
import 'package:manage_salary/ui/home/widgets/chart/chart_session.dart';
import 'package:manage_salary/ui/home/widgets/chart/weekly_chart.dart';

import '../../../../bloc/activity/activity_bloc.dart';
import '../../../../bloc/activity/activity_state.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/enums.dart';
import '../../../../models/chart_display_data.dart';

class DashboardCard extends StatefulWidget {
  const DashboardCard({super.key});

  @override
  State<DashboardCard> createState() => _DashboardCardState();
}

class _DashboardCardState extends State<DashboardCard> {
  bool _isWeeklyView = false;

  // Define colors for the chart
  final List<Color> _chartColors = const [
    Color(0xFF006064), // Deep Cyan
    Color(0xFFFF7043), // Bright Coral
    Color(0xFF66BB6A), // Soft Green
    Color(0xFFFFCA28), // Amber/Yellow
    Color(0xFFAB47BC), // Violet
  ];

  List<ChartDisplayData> _prepareChartData(
      Map<ActivityType, double> expensesByType, double totalExpenses) {
    if (totalExpenses == 0) return [];
    
    final List<ChartDisplayData> displayData = [];
    int colorIndex = 0;

    expensesByType.forEach((type, amount) {
      if (amount > 0) {
        final percentage = (amount / totalExpenses) * 100;
        
        displayData.add(ChartDisplayData(
          name: localizedActivityPaying(context, type),
          value: amount,
          percentage: percentage,
          color: _chartColors[colorIndex % _chartColors.length],
        ));
        colorIndex++;
      }
    });

    // Sort by amount descending
    displayData.sort((a, b) => b.value.compareTo(a.value));
    
    // Group small items into "Other" if there are many categories
    if (displayData.length > 5) {
      final topItems = displayData.sublist(0, 4);
      final otherItems = displayData.sublist(4);
      
      double otherAmount = 0;
      for (var item in otherItems) {
        otherAmount += item.value;
      }
      
      topItems.add(ChartDisplayData(
        name: S.of(context).activityTypeExpenseOther,
        value: otherAmount,
        percentage: (otherAmount / totalExpenses) * 100,
        color: Colors.grey,
      ));
      
      return topItems;
    }

    return displayData;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocBuilder<ActivityBloc, ActivityState>(
      builder: (context, state) {
        final double totalExpensesForChart = state.thisMonthExpenses;
        final List<ChartDisplayData> chartDisplayItems = _prepareChartData(
            state.expensesByType, totalExpensesForChart);

        // Compute weekly data
        final List<double> weeklyIncomes = List.filled(7, 0.0);
        final List<double> weeklyExpenses = List.filled(7, 0.0);
        double maxWeeklyVal = 0.0;
        
        final today = DateTime.now();
        // Determine the start of this week (Monday)
        final int currentWeekday = today.weekday;
        final startOfWeek = DateTime(today.year, today.month, today.day).subtract(Duration(days: currentWeekday - 1));
        final endOfWeek = startOfWeek.add(const Duration(days: 7));
        
        for (var a in state.allActivities) {
          if (!a.date.isBefore(startOfWeek) && a.date.isBefore(endOfWeek)) {
            final dayIndex = a.date.weekday - 1; // 0 = Monday, 6 = Sunday
            if (a.nature == ActivityNature.income) {
              weeklyIncomes[dayIndex] += a.amount;
              maxWeeklyVal = max(maxWeeklyVal, weeklyIncomes[dayIndex]);
            } else {
              weeklyExpenses[dayIndex] += a.amount;
              maxWeeklyVal = max(maxWeeklyVal, weeklyExpenses[dayIndex]);
            }
          }
        }

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Bento Tile 1: Total Balance (Nordic Minimalist)
              Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : Colors.white,
                  borderRadius: BorderRadius.circular(24.r),
                  border: Border.all(
                    color: isDark
                        ? AppColors.darkOutline
                        : AppColors.outline,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black
                          .withValues(alpha: isDark ? 0.2 : 0.04),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(8.w),
                              decoration: BoxDecoration(
                                color:
                                    AppColors.primary.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Icon(
                                Icons.account_balance_wallet_rounded,
                                color: AppColors.primary,
                                size: 18.sp,
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Text(
                              S.of(context).totalBalance,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: theme.hintColor,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: (state.netBalance >= 0
                                    ? const Color(0xFF10B981)
                                    : const Color(0xFFEF4444))
                                .withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                state.netBalance >= 0
                                    ? Icons.arrow_upward_rounded
                                    : Icons.arrow_downward_rounded,
                                size: 13.sp,
                                color: state.netBalance >= 0
                                    ? const Color(0xFF10B981)
                                    : const Color(0xFFEF4444),
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                state.netBalance >= 0 ? 'Surplus' : 'Deficit',
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w700,
                                  color: state.netBalance >= 0
                                      ? const Color(0xFF10B981)
                                      : const Color(0xFFEF4444),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 14.h),

                    // Primary Balance Display
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        MoneyUtil.formatDefault(state.netBalance),
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                          color: state.netBalance >= 0
                              ? (isDark
                                  ? Colors.white
                                  : const Color(0xFF0F172A))
                              : const Color(0xFFEF4444),
                        ),
                      ),
                    ),
                    SizedBox(height: 18.h),

                    // Bento Subgrid: Income & Expenses
                    Row(
                      children: [
                        Expanded(
                          child: CardInfo(
                            title: S.of(context).income,
                            amount: state.thisMonthIncome,
                            amountColor: const Color(0xFF10B981),
                            icon: Icons.south_west_rounded,
                            iconColor: const Color(0xFF10B981),
                            iconBg: const Color(0xFF10B981)
                                .withValues(alpha: 0.14),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: CardInfo(
                            title: S.of(context).expenses,
                            amount: state.thisMonthExpenses,
                            amountColor: const Color(0xFFEF4444),
                            icon: Icons.north_east_rounded,
                            iconColor: const Color(0xFFEF4444),
                            iconBg: const Color(0xFFEF4444)
                                .withValues(alpha: 0.14),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Bento Tile 2: Analytics Chart
              if (chartDisplayItems.isNotEmpty || maxWeeklyVal > 0) ...[
                SizedBox(height: 14.h),
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : Colors.white,
                    borderRadius: BorderRadius.circular(22.r),
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.08)
                          : const Color(0xFFE2E8F0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black
                            .withValues(alpha: isDark ? 0.2 : 0.04),
                        blurRadius: 14,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                _isWeeklyView ? Icons.bar_chart_rounded : Icons.pie_chart_outline_rounded,
                                size: 16.sp, 
                                color: theme.hintColor
                              ),
                              SizedBox(width: 6.w),
                              Text(
                                _isWeeklyView ? "This Week" : S.of(context).expenses,
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              if (!_isWeeklyView)
                                Text(
                                  MoneyUtil.formatDefault(totalExpensesForChart),
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFFEF4444),
                                  ),
                                ),
                              if (!_isWeeklyView) SizedBox(width: 10.w),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isWeeklyView = !_isWeeklyView;
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                                  decoration: BoxDecoration(
                                    color: theme.primaryColor.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: Icon(
                                    Icons.swap_horiz_rounded,
                                    size: 18.sp,
                                    color: theme.primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      SizedBox(
                        height: 160.h,
                        child: _isWeeklyView
                            ? WeeklyChart(
                                weeklyIncomes: weeklyIncomes,
                                weeklyExpenses: weeklyExpenses,
                                maxY: maxWeeklyVal,
                              )
                            : (chartDisplayItems.isNotEmpty 
                                ? ChartSession(chartItems: chartDisplayItems)
                                : const Center(child: Text("No Data"))),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
