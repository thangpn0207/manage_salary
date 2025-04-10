import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/util/money_util.dart';

class CardInfo extends StatelessWidget {
  final String title;
  final double amount;
  final Color amountColor;

  const CardInfo(
      {super.key,
      required this.title,
      required this.amount,
      required this.amountColor});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 2,
      // Slightly increased elevation
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      // Adjusted radius
      color: Theme.of(context).cardColor.withValues(alpha: 0.85),
      // Slightly less transparent
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
        // Adjusted padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          // Center content vertically
          children: [
            Text(title,
                style: theme.textTheme.bodySmall?.copyWith(
                    // Smaller title
                    color: theme.hintColor,
                    fontWeight: FontWeight.w500)),
            SizedBox(height: 4.h), // Reduced space
            FittedBox(
              // Ensure text fits
              fit: BoxFit.scaleDown,
              child: Text(
                MoneyUtil.formatDefault(amount),
                style: theme.textTheme.titleMedium // Adjusted text style
                    ?.copyWith(fontWeight: FontWeight.w600, color: amountColor),
                maxLines: 1,
              ).animate().fadeIn(),
            ),
          ],
        ),
      ),
    );
  }
}
