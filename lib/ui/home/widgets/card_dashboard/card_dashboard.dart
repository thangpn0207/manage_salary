// presentation/screens/dashboard_screen.dart
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tilt/flutter_tilt.dart';
import 'package:manage_salary/core/locale/generated/l10n.dart';
import 'package:manage_salary/core/util/localization_utils.dart'; // Import the utils
import 'package:manage_salary/core/util/money_util.dart';
import 'package:manage_salary/ui/home/widgets/card_dashboard/card_info.dart';
import 'package:manage_salary/ui/home/widgets/chart/chart_session.dart';

import '../../../../bloc/activity/activity_bloc.dart';
import '../../../../bloc/activity/activity_state.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/enums.dart';
import '../../../../models/chart_display_data.dart';

class DashboardCard extends StatelessWidget {
  const DashboardCard({super.key});

  // Define colors for the chart
  final List<Color> _chartColors = const [
    Color(0xFF006064), // Deep Cyan
    Color(0xFFFF7043), // Bright Coral
    Color(0xFF66BB6A), // Soft Green
    Color(0xFFFFCA28), // Amber/Yellow
    Color(0xFFAB47BC), // Violet
  ];

  // --- Helper to prepare aggregated chart data --- (Uses localization)
  List<ChartDisplayData> _prepareChartData(
      BuildContext context,
      // Need context for localization
      Map<ActivityType, double> expensesByType,
      double totalExpenses) {
    if (totalExpenses <= 0 || expensesByType.isEmpty) {
      return [];
    }

    final sortedEntries = expensesByType.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final List<ChartDisplayData> displayData = [];
    int colorIndex = 0;
    double otherTotal = 0.0;
    const int maxIndividualCategories = 5; // Show top 5 potentially

    // Process top categories
    for (int i = 0;
        i < min(maxIndividualCategories, sortedEntries.length);
        i++) {
      final entry = sortedEntries[i];
      final percentage = (entry.value / totalExpenses) * 100;
      final color = _chartColors[colorIndex % _chartColors.length];
      colorIndex++;
      displayData.add(ChartDisplayData(
        name: localizedActivityPaying(context, entry.key), // Use utils
        value: entry.value,
        percentage: percentage,
        color: color,
      ));
    }

    // Calculate "Other" total
    if (sortedEntries.length > maxIndividualCategories) {
      for (int i = maxIndividualCategories; i < sortedEntries.length; i++) {
        otherTotal += sortedEntries[i].value;
      }
    }

    // Add "Other" category if it has value
    if (otherTotal > 0) {
      final percentage = (otherTotal / totalExpenses) * 100;
      final color = _chartColors[colorIndex % _chartColors.length];
      displayData.add(ChartDisplayData(
        name: S.of(context).otherCategory, // Use localized "Other"
        value: otherTotal,
        percentage: percentage,
        color: color,
      ));
    }

    return displayData;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActivityBloc, ActivityState>(
      builder: (context, state) {
        // Prepare data for the Pie Chart using the new helper
        final double totalExpensesForChart = state.thisMonthExpenses;
        final List<ChartDisplayData> chartDisplayItems = _prepareChartData(
            context,
            state.expensesByType,
            totalExpensesForChart); // Pass context
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Tilt(
            borderRadius: BorderRadius.circular(30),
            tiltConfig: const TiltConfig(
              angle: 30,
              leaveDuration: Duration(milliseconds: 800),
              leaveCurve: Curves.elasticOut,
            ),
            lightConfig: const LightConfig(
              color: Colors.white,
              minIntensity: 0.2,
              maxIntensity: 0.8,
            ),
            shadowConfig: const ShadowConfig(
              disable: false,
              color: Colors.black54,
            ),
            childLayout: ChildLayout(
              outer: [
                Positioned(
                  top: 20.h,
                  left: 0,
                  right: 0,
                  child: TiltParallax(
                    size: const Offset(15, 15),
                    child: _buildTotalBalance(context, state.netBalance),
                  ),
                ),
                Positioned(
                  top: 90.h,
                  left: 20.w,
                  right: 20.w,
                  child: TiltParallax(
                    size: const Offset(25, 25),
                    child: _buildIncomeExpenseRow(context,
                        state.thisMonthIncome, state.thisMonthExpenses),
                  ),
                ),
                // --- Chart Section ---
                Positioned(
                  bottom: 20.h,
                  left: 10.w,
                  right: 10.w,
                  height: 200.h,
                  child: TiltParallax(
                    size: const Offset(20, 20),
                    child: (chartDisplayItems.isNotEmpty)
                        ? ChartSession(chartItems: chartDisplayItems)
                        : _buildEmptyChartPlaceholder(context),
                  ),
                ),
              ],
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primary,
                    AppColors.onSurface,
                  ],
                  stops: [0.1, 0.9],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 5,
                    spreadRadius: -2,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // --- Helper Widgets ---

  Widget _buildTotalBalance(BuildContext context, double balance) {
    final theme = Theme.of(context);
    // Determine color based on balance
    final balanceColor = balance >= 0 ? AppColors.onSurface : theme.colorScheme.error;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            S.of(context).totalBalance, // Use localization
            style: theme.textTheme.titleMedium?.copyWith(
                color: AppColors.onSurface
                    .withValues(alpha: 0.8)), // Keep subtle color
          ),
          SizedBox(height: 4.h),
          Text(
            MoneyUtil.formatDefault(balance),
            style: theme.textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: balanceColor, // Apply determined color
                shadows: [
                  Shadow(
                    blurRadius: 1.0,
                    color: Colors.black.withValues(alpha: 0.2),
                    offset: const Offset(1.0, 1.0),
                  ),
                ]),
          ).animate().fadeIn(),
        ],
      ),
    );
  }

  Widget _buildIncomeExpenseRow(
      BuildContext context, double income, double expenses) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
            child: CardInfo(
          title: S.of(context).income, // Use localization
          amount: income,
          amountColor: AppColors.upGreen,
        )),
        SizedBox(width: 10.w),
        Expanded(
            child: CardInfo(
          title: S.of(context).expenses, // Use localization
          amount: expenses,
          amountColor: Theme.of(context).colorScheme.error,
        )),
      ],
    );
  }

  Widget _buildEmptyChartPlaceholder(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(16.w),
      child: Text(
        S.of(context).noChartData, // Use localization
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).hintColor.withValues(alpha: 0.7)),
        textAlign: TextAlign.center,
      ),
    );
  }
}
