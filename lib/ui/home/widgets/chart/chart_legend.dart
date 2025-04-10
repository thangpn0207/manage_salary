import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../models/chart_display_data.dart';

class ChartLegend extends StatelessWidget {
  final List<ChartDisplayData> legendItems;

  const ChartLegend({super.key, required this.legendItems});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: legendItems.map((item) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 3.h), // Adjusted padding
          child: Row(
            children: [
              Container(
                width: 10.w, // Responsive size
                height: 10.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: item.color,
                ),
              ),
              SizedBox(width: 6.w), // Adjusted space
              Flexible(
                child: Text(
                  item.name, // Use name from prepared data
                  style: theme.textTheme.bodySmall, // Slightly smaller text
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
