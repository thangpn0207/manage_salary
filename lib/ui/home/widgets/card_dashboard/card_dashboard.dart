// presentation/screens/dashboard_screen.dart
import 'dart:math'; // Import math for min function

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tilt/flutter_tilt.dart';
import 'package:manage_salary/core/util/money_util.dart';
import 'package:manage_salary/ui/home/widgets/card_dashboard/card_info.dart';
import 'package:manage_salary/ui/home/widgets/chart/chart_session.dart';

import '../../../../bloc/activity/activity_bloc.dart';
import '../../../../bloc/activity/activity_state.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/enums.dart';
import '../../../../core/locale/generated/l10n.dart';
import '../../../../models/chart_display_data.dart';

class DashboardCard extends StatelessWidget {
  const DashboardCard({super.key});

  // Helper to format category enum names (reuse from previous examples)
  String _formatEnumName(ActivityPaying value) {
    String name = value.name;
    // Simple split and capitalize for enums like 'foodAndDrink'
    if (name.contains(RegExp(r'[A-Z]'))) {
      name = name.replaceAllMapped(
          RegExp(r'([A-Z])'), (match) => ' ${match.group(1)}');
      name = name[0].toUpperCase() + name.substring(1).trim();
      name = name.replaceFirst('And', '&'); // Specific replacement if needed
    } else {
      // Handle single-word enums
      name = name[0].toUpperCase() + name.substring(1);
    }
    return name;
  }

  // Define colors for the chart (match the image theme)
  final List<Color> _chartColors = const [
    Color(0xFF006064), // Deep Cyan – bold and readable
    Color(0xFFFF7043), // Bright Coral – vibrant contrast
    Color(0xFF66BB6A), // Soft Green – natural and balanced
    Color(0xFFFFCA28), // Amber/Yellow – eye-catching
    Color(0xFFAB47BC), // Violet – deep and distinct
  ];

  // --- NEW: Helper to prepare aggregated chart data ---
  List<ChartDisplayData> _prepareChartData(
      Map<ActivityPaying, double> expensesByType, double totalExpenses) {
    if (totalExpenses <= 0 || expensesByType.isEmpty) {
      return [];
    }

    // Sort entries descending by amount
    final sortedEntries = expensesByType.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final List<ChartDisplayData> displayData = [];
    int colorIndex = 0;
    double otherTotal = 0.0;
    const int maxIndividualCategories = 4; // Show top 4

    // Process top categories
    for (int i = 0;
        i < min(maxIndividualCategories, sortedEntries.length);
        i++) {
      final entry = sortedEntries[i];
      final percentage = (entry.value / totalExpenses) * 100;
      final color = _chartColors[colorIndex % _chartColors.length];
      colorIndex++;
      displayData.add(ChartDisplayData(
        name: _formatEnumName(entry.key),
        value: entry.value,
        percentage: percentage,
        color: color,
      ));
    }

    // Calculate "Other" total if there are more categories
    if (sortedEntries.length > maxIndividualCategories) {
      for (int i = maxIndividualCategories; i < sortedEntries.length; i++) {
        otherTotal += sortedEntries[i].value;
      }
    }

    // Add "Other" category if it has value
    if (otherTotal > 0) {
      final percentage = (otherTotal / totalExpenses) * 100;
      // Ensure "Other" gets the next available color
      final color = _chartColors[colorIndex % _chartColors.length];
      displayData.add(ChartDisplayData(
        name: 'Other',
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
        final List<ChartDisplayData> chartDisplayItems =
            _prepareChartData(state.expensesByType, totalExpensesForChart);
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Tilt(
            borderRadius: BorderRadius.circular(30),
            tiltConfig: const TiltConfig(
              angle: 30, // Reduced angle slightly
              leaveDuration: Duration(milliseconds: 800), // Faster leave
              leaveCurve: Curves.elasticOut, // Different curve
            ),
            lightConfig: const LightConfig(
              color: Colors.white, // Brighter light source
              minIntensity: 0.2,
              maxIntensity: 0.8,
            ),
            shadowConfig: const ShadowConfig(
              disable: false, // Keep shadow
              color: Colors.black54, // Darker shadow
            ),
            childLayout: ChildLayout(
              outer: [
                Positioned(
                  top: 20.h,
                  left: 0, // Align outer elements if needed
                  right: 0,
                  child: TiltParallax(
                    size: const Offset(15, 15), // Reduced parallax
                    child: _buildTotalBalance(context, state.netBalance),
                  ),
                ),
                Positioned(
                  top: 90.h, // Adjusted position
                  left: 20.w, // Added horizontal positioning
                  right: 20.w,
                  child: TiltParallax(
                    size: const Offset(25, 25), // Adjusted parallax
                    child: _buildIncomeExpenseRow(context,
                        state.thisMonthIncome, state.thisMonthExpenses),
                  ),
                ),
                // --- Chart Section ---
                // Position it lower and ensure it doesn't overlap badly
                Positioned(
                  // Adjust top/bottom/left/right as needed for your layout
                  bottom: 20.h,
                  // Position from bottom
                  left: 10.w,
                  right: 10.w,
                  height: 200.h,
                  // Give chart section explicit height
                  child: TiltParallax(
                    size: const Offset(20, 20),
                    child: (chartDisplayItems.isNotEmpty)
                        ? ChartSession(chartItems: chartDisplayItems)
                        : _buildEmptyChartPlaceholder(context),
                  ),
                ),
              ],
            ),
            // --- Main Card Content ---
            child: Container(
              // Removed fixed width/height, let content define size or use constraints
              // height: 350.h, // Example height constraint
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30), // Match Tilt border
                gradient: const LinearGradient(
                  begin: Alignment.topLeft, // Adjusted gradient direction
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primary, // Use your defined AppColors
                    AppColors.onSurface, // Use your defined AppColors
                  ],
                  stops: [0.1, 0.9], // Adjust stops for gradient spread
                ),
                boxShadow: [
                  // Add subtle inner shadow for depth if desired
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 5,
                    spreadRadius: -2,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              // Add padding inside the container if needed
              // padding: EdgeInsets.all(16.w),
            ),
          ),
        );
      },
    );
  }

  // --- Helper Widgets ---

  Widget _buildTotalBalance(BuildContext context, double balance) {
    final theme = Theme.of(context);
    final balanceColor = balance >= 0
        ? AppColors.onSurface
        : theme.colorScheme.error; // Use AppColors
    return Padding(
      // Add padding to prevent text touching edges
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Take minimum space
        children: [
          Text(
            S.current.totalBalance,
            style: theme.textTheme.titleMedium?.copyWith(
                color: AppColors.onSurface
                    .withValues(alpha: 0.8)), // Use AppColors
          ),
          SizedBox(height: 4.h), // Reduced space
          Text(
            MoneyUtil.formatDefault(balance),
            style: theme.textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: balanceColor,
                shadows: [
                  // Add subtle shadow to text for readability
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
      // Removed SizedBox wrapper, let Row manage width
      mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Distribute space
      children: [
        Expanded(
            child: CardInfo(
          title: S.current.income,
          amount: income,
          amountColor: AppColors.upGreen,
        )), // Use AppColors
        SizedBox(width: 10.w), // Reduced spacing
        Expanded(
            child: CardInfo(
          title: S.current.expenses,
          amount: expenses,
          amountColor: Theme.of(context).colorScheme.error,
        )),
      ],
    );
  }

  Widget _buildEmptyChartPlaceholder(BuildContext context) {
    return Container(
      // Removed fixed height, let alignment handle it
      alignment: Alignment.center,
      padding: EdgeInsets.all(16.w), // Add padding
      child: Text(
        "No expense data for this period to display chart.",
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context)
                .hintColor
                .withValues(alpha: 0.7)), // More subtle
        textAlign: TextAlign.center,
      ),
    );
  }
}
