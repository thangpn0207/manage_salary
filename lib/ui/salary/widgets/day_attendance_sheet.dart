import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../bloc/salary/salary_state.dart';
import '../../../core/constants/colors.dart';
import '../../../core/locale/generated/l10n.dart';
import '../../../core/util/money_util.dart';
import '../../../data/local/salary_database.dart';

class DayAttendanceSheet extends StatefulWidget {
  final DateTime date;
  final Attendance? attendance;
  final SalaryState? salaryState;
  final Function({
    required DateTime date,
    required String status,
    required double otHours,
    required double otMultiplier,
    required double advanceAmount,
    required double bonusAmount,
    String? note,
  }) onSave;
  final VoidCallback? onDelete;

  const DayAttendanceSheet({
    super.key,
    required this.date,
    this.attendance,
    this.salaryState,
    required this.onSave,
    this.onDelete,
  });

  @override
  State<DayAttendanceSheet> createState() => _DayAttendanceSheetState();
}

class _DayAttendanceSheetState extends State<DayAttendanceSheet> {
  late String _status;
  late double _otHours;
  late double _otMultiplier;
  late TextEditingController _advanceController;
  late TextEditingController _bonusController;
  late TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    final att = widget.attendance;
    _status = att?.status ?? 'full';
    _otHours = att?.otHours ?? 0.0;
    _otMultiplier = att?.otMultiplier ?? 1.5;
    _advanceController = TextEditingController(
      text: (att != null && att.advanceAmount > 0)
          ? att.advanceAmount.toStringAsFixed(0)
          : '',
    );
    _bonusController = TextEditingController(
      text: (att != null && att.bonusAmount > 0)
          ? att.bonusAmount.toStringAsFixed(0)
          : '',
    );
    _noteController = TextEditingController(text: att?.note ?? '');
  }

  @override
  void dispose() {
    _advanceController.dispose();
    _bonusController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _submit() {
    final advance = double.tryParse(_advanceController.text.replaceAll(',', '').replaceAll('.', '')) ?? 0.0;
    final bonus = double.tryParse(_bonusController.text.replaceAll(',', '').replaceAll('.', '')) ?? 0.0;

    widget.onSave(
      date: widget.date,
      status: _status,
      otHours: _otHours,
      otMultiplier: _otMultiplier,
      advanceAmount: advance,
      bonusAmount: bonus,
      note: _noteController.text.trim().isNotEmpty ? _noteController.text.trim() : null,
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final locale = Localizations.localeOf(context).languageCode == 'vi' ? 'vi_VN' : 'en_US';
    final dateStr = DateFormat('EEEE, dd/MM/yyyy', locale).format(widget.date);

    return Container(
      padding: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
        top: 20.h,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24.h,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.grey.withAlpha(80),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              dateStr,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : AppColors.secondary,
              ),
            ),
            SizedBox(height: 16.h),

            // Work Status
            Text(
              S.current.workStatus,
              style: TextStyle(
                fontSize: 13.sp,
                color: isDark ? Colors.grey[400] : Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: [
                _buildStatusChip('full', S.current.checkInFull, AppColors.upGreen, isDark),
                _buildStatusChip('half', S.current.checkInHalf, Colors.orange, isDark),
                _buildStatusChip('leave_paid', S.current.leavePaid, Colors.blue, isDark),
                _buildStatusChip('leave_unpaid', S.current.leaveUnpaid, AppColors.downRed, isDark),
              ],
            ),
            SizedBox(height: 16.h),

            // Overtime Section
            Text(
              S.current.overtimeSection,
              style: TextStyle(
                fontSize: 13.sp,
                color: isDark ? Colors.grey[400] : Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.h),
            Row(
              children: [0.0, 1.0, 1.5, 2.0, 3.0, 4.0].map((hours) {
                final isSelected = _otHours == hours;
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _otHours = hours;
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 2.w),
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.purple
                            : (isDark ? AppColors.darkSurfaceContainer : Colors.grey.shade100),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        hours == 0 ? '0h' : '+${hours.toStringAsFixed(hours.truncateToDouble() == hours ? 0 : 1)}h',
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected
                              ? Colors.white
                              : (isDark ? Colors.grey[300] : Colors.grey[800]),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            if (_otHours > 0) ...[
              SizedBox(height: 10.h),
              Row(
                children: [
                  _buildMultiplierChip(1.5, S.current.otNormalDay, isDark),
                  SizedBox(width: 8.w),
                  _buildMultiplierChip(2.0, S.current.otWeekend, isDark),
                  SizedBox(width: 8.w),
                  _buildMultiplierChip(3.0, S.current.otHoliday, isDark),
                ],
              ),
            ],
            SizedBox(height: 16.h),

            // Advance & Bonus row
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        S.current.advanceSalary,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: isDark ? Colors.grey[400] : Colors.grey[700],
                        ),
                      ),
                      SizedBox(height: 8.h),
                      TextField(
                        controller: _advanceController,
                        keyboardType: TextInputType.number,
                        onChanged: (_) => setState(() {}),
                        decoration: InputDecoration(
                          hintText: '0',
                          suffixText: MoneyUtil.currencySymbol,
                          filled: true,
                          fillColor: isDark ? AppColors.darkSurfaceContainer : Colors.grey.shade100,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        S.current.bonusMoney,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: isDark ? Colors.grey[400] : Colors.grey[700],
                        ),
                      ),
                      SizedBox(height: 8.h),
                      TextField(
                        controller: _bonusController,
                        keyboardType: TextInputType.number,
                        onChanged: (_) => setState(() {}),
                        decoration: InputDecoration(
                          hintText: '0',
                          suffixText: MoneyUtil.currencySymbol,
                          filled: true,
                          fillColor: isDark ? AppColors.darkSurfaceContainer : Colors.grey.shade100,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 14.h),

            // Smart Auto-Calculation Summary Card for the Day
            Builder(
              builder: (context) {
                final dailyRate = widget.salaryState?.dailyRate ?? 0.0;
                final hourlyRate = widget.salaryState?.hourlyRate ?? 0.0;

                double workDayRatio = 0.0;
                if (_status == 'full') {
                  workDayRatio = 1.0;
                } else if (_status == 'half') {
                  workDayRatio = 0.5;
                } else if (_status == 'leave_paid') {
                  workDayRatio = 1.0;
                }

                final dailyEarned = dailyRate * workDayRatio;
                final otEarned = _otHours * hourlyRate * _otMultiplier;
                final advance = double.tryParse(_advanceController.text.replaceAll(',', '').replaceAll('.', '')) ?? 0.0;
                final bonus = double.tryParse(_bonusController.text.replaceAll(',', '').replaceAll('.', '')) ?? 0.0;
                final dayTotal = dailyEarned + otEarned + bonus - advance;

                return Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF0FDF4),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: isDark ? const Color(0xFF1E3A5F) : const Color(0xFFBBF7D0),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.monetization_on_outlined, size: 16.sp, color: const Color(0xFF10B981)),
                              SizedBox(width: 6.w),
                              Text(
                                S.current.estimatedDailyIncome,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : const Color(0xFF065F46),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            MoneyUtil.formatMoney(dayTotal),
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                              color: dayTotal >= 0 ? const Color(0xFF10B981) : Colors.red,
                            ),
                          ),
                        ],
                      ),
                      if (dailyRate > 0) ...[
                        SizedBox(height: 6.h),
                        Text(
                          '• ${S.current.dailyWage} ($workDayRatio công): +${MoneyUtil.formatMoney(dailyEarned)}',
                          style: TextStyle(fontSize: 11.sp, color: isDark ? Colors.grey[300] : Colors.grey[700]),
                        ),
                      ],
                      if (_otHours > 0) ...[
                        SizedBox(height: 2.h),
                        Text(
                          '• ${S.current.dailyOtPay} (${_otHours}h x$_otMultiplier): +${MoneyUtil.formatMoney(otEarned)}',
                          style: TextStyle(fontSize: 11.sp, color: const Color(0xFF2563EB)),
                        ),
                      ],
                      if (advance > 0) ...[
                        SizedBox(height: 2.h),
                        Text(
                          '• ${S.current.advanceSalary}: -${MoneyUtil.formatMoney(advance)}',
                          style: TextStyle(fontSize: 11.sp, color: Colors.orange),
                        ),
                      ],
                      if (bonus > 0) ...[
                        SizedBox(height: 2.h),
                        Text(
                          '• ${S.current.bonusMoney}: +${MoneyUtil.formatMoney(bonus)}',
                          style: TextStyle(fontSize: 11.sp, color: const Color(0xFF10B981)),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
            SizedBox(height: 14.h),

            // Note
            TextField(
              controller: _noteController,
              decoration: InputDecoration(
                hintText: S.current.noteToday,
                filled: true,
                fillColor: isDark ? AppColors.darkSurfaceContainer : Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 20.h),

            // Buttons
            Row(
              children: [
                if (widget.attendance != null && widget.onDelete != null) ...[
                  IconButton(
                    onPressed: () {
                      widget.onDelete!();
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.delete_outline, color: AppColors.downRed, size: 24.sp),
                  ),
                  SizedBox(width: 8.w),
                ],
                Expanded(
                  child: SizedBox(
                    height: 48.h,
                    child: ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        S.current.saveAttendance,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status, String label, Color color, bool isDark) {
    final isSelected = _status == status;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: color.withAlpha(200),
      backgroundColor: isDark ? AppColors.darkSurfaceContainer : Colors.grey.shade100,
      labelStyle: TextStyle(
        fontSize: 12.sp,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        color: isSelected ? Colors.white : (isDark ? Colors.grey[300] : Colors.grey[800]),
      ),
      onSelected: (val) {
        if (val) {
          setState(() {
            _status = status;
          });
        }
      },
    );
  }

  Widget _buildMultiplierChip(double mult, String label, bool isDark) {
    final isSelected = _otMultiplier == mult;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _otMultiplier = mult;
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 6.h),
          decoration: BoxDecoration(
            color: isSelected
                ? Colors.purple.shade700
                : (isDark ? AppColors.darkSurfaceContainer : Colors.grey.shade100),
            borderRadius: BorderRadius.circular(8.r),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? Colors.white : (isDark ? Colors.grey[400] : Colors.grey[700]),
            ),
          ),
        ),
      ),
    );
  }
}
