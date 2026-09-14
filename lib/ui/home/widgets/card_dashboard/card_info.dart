import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/util/money_util.dart';

class CardInfo extends StatelessWidget {
  final String title;
  final double amount;
  final Color amountColor;
  final IconData? icon;
  final Color? iconColor;
  final Color? iconBg;

  const CardInfo({
    super.key,
    required this.title,
    required this.amount,
    required this.amountColor,
    this.icon,
    this.iconColor,
    this.iconBg,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.04)
            : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : Colors.black.withValues(alpha: 0.04),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: iconBg ?? amountColor.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: 13.sp,
                    color: iconColor ?? amountColor,
                  ),
                ),
                SizedBox(width: 6.w),
              ],
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.hintColor,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              MoneyUtil.formatDefault(amount),
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: amountColor,
              ),
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}
