import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:manage_salary/ui/home/widgets/chart/chart_legend.dart';

import '../../../../models/chart_display_data.dart';

class ChartSession extends StatefulWidget {
  final List<ChartDisplayData> chartItems;

  const ChartSession({super.key, required this.chartItems});

  @override
  State<ChartSession> createState() => _ChartSessionState();
}

class _ChartSessionState extends State<ChartSession> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Add padding around the chart/legend area
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center, // Center vertically
        children: [
          // Pie Chart
          Expanded(
            flex: 5, // Give chart slightly more relative space
            child: AspectRatio(
              aspectRatio: 1,
              child: PieChart(
                PieChartData(
                  sections:
                      _buildPieChartSections(widget.chartItems, touchedIndex),
                  centerSpaceRadius: 35.r,
                  // Responsive radius
                  sectionsSpace: 2,
                  borderData: FlBorderData(show: false),
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          touchedIndex = -1;
                          return;
                        }
                        touchedIndex = pieTouchResponse
                            .touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
                ),
                duration: Duration(milliseconds: 150), // Optional
                curve: Curves.linear, // Optional
              ),
            ),
          ),
          SizedBox(width: 12.w), // Adjusted space

          // Legend
          Expanded(
            flex: 4, // Give legend slightly less relative space
            child: ChartLegend(
                legendItems: widget.chartItems), // Pass prepared items
          ),
        ],
      ),
    );
  }

  // --- UPDATED: Pie Chart Sections use prepared data ---
  List<PieChartSectionData> _buildPieChartSections(
      List<ChartDisplayData> chartItems, int itemSelected) {
    // Data is already prepared and filtered, just map it
    return chartItems.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
      final isTouched = index == itemSelected;
      final fontSize = isTouched ? 16.sp : 10.sp;
      final radius = isTouched ? 60.0.r : 45.r;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

      return PieChartSectionData(
        color: item.color,
        value: item.value,
        // Use absolute value for proportion
        title: '${item.percentage.toStringAsFixed(0)}%',
        // Show percentage
        radius: radius,
        // Responsive radius
        titleStyle: TextStyle(
          fontSize: fontSize, // Responsive font size
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: shadows,
        ),
        showTitle:
            item.percentage > 5, // Only show title if percentage is significant
      );
    }).toList();
  }
}
