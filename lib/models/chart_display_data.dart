// Helper class to hold processed data for chart/legend items
import 'dart:ui';

class ChartDisplayData {
  final String name; // Category name or "Other"
  final double value;
  final double percentage;
  final Color color;

  ChartDisplayData({
    required this.name,
    required this.value,
    required this.percentage,
    required this.color,
  });
}
