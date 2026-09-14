import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:manage_salary/core/locale/generated/l10n.dart';
import 'package:manage_salary/core/util/money_util.dart';

class WeeklyChart extends StatelessWidget {
  final List<double> weeklyIncomes;
  final List<double> weeklyExpenses;
  final double maxY;

  const WeeklyChart({
    super.key,
    required this.weeklyIncomes,
    required this.weeklyExpenses,
    required this.maxY,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Days of week (Mon-Sun)
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxY == 0 ? 100 : maxY * 1.2,
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (group) => isDark ? Colors.blueGrey[800]! : Colors.white,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final isIncome = rodIndex == 0;
              final val = rod.toY;
              return BarTooltipItem(
                '${isIncome ? S.of(context).income : S.of(context).expenses}\n${MoneyUtil.formatDefault(val)}',
                TextStyle(
                  color: isIncome ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                  fontWeight: FontWeight.bold,
                  fontSize: 12.sp,
                ),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, TitleMeta meta) {
                final style = TextStyle(
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                  fontWeight: FontWeight.w600,
                  fontSize: 10.sp,
                );
                Widget text = Text(days[value.toInt() % 7], style: style);
                return SideTitleWidget(
                  meta: meta,
                  space: 4,
                  child: text,
                );
              },
            ),
          ),
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: (maxY == 0 ? 100 : maxY) / 4,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: isDark ? Colors.white10 : Colors.black12,
              strokeWidth: 1,
              dashArray: [4, 4],
            );
          },
        ),
        borderData: FlBorderData(show: false),
        barGroups: List.generate(7, (i) {
          return BarChartGroupData(
            x: i,
            barsSpace: 4,
            barRods: [
              BarChartRodData(
                toY: weeklyIncomes[i],
                color: const Color(0xFF10B981),
                width: 8.w,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4.r),
                  topRight: Radius.circular(4.r),
                ),
              ),
              BarChartRodData(
                toY: weeklyExpenses[i],
                color: const Color(0xFFEF4444),
                width: 8.w,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4.r),
                  topRight: Radius.circular(4.r),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
