import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/colors.dart';
import '../../../core/locale/generated/l10n.dart';
import '../../../core/util/money_util.dart';
import '../../../data/local/salary_database.dart';

class SalarySettingsSheet extends StatefulWidget {
  final SalaryProfile? currentProfile;
  final Function({
    required String salaryType,
    required double baseAmount,
    required double standardWorkingDays,
    required double standardHoursPerDay,
    required bool enableInsurance,
    required double insuranceRate,
  }) onSave;

  const SalarySettingsSheet({
    super.key,
    this.currentProfile,
    required this.onSave,
  });

  @override
  State<SalarySettingsSheet> createState() => _SalarySettingsSheetState();
}

class _SalarySettingsSheetState extends State<SalarySettingsSheet> {
  late String _selectedType;
  late TextEditingController _amountController;
  late TextEditingController _daysController;
  late TextEditingController _hoursController;
  late bool _enableInsurance;
  late TextEditingController _insuranceRateController;

  @override
  void initState() {
    super.initState();
    final p = widget.currentProfile;
    _selectedType = p?.salaryType ?? 'monthly';
    _amountController = TextEditingController(
      text: p != null ? p.baseAmount.toStringAsFixed(0) : '15000000',
    );
    _daysController = TextEditingController(
      text: p != null ? p.standardWorkingDays.toStringAsFixed(0) : '26',
    );
    _hoursController = TextEditingController(
      text: p != null ? p.standardHoursPerDay.toStringAsFixed(0) : '8',
    );
    _enableInsurance = p?.enableInsurance ?? false;
    _insuranceRateController = TextEditingController(
      text: p != null ? p.insuranceRate.toStringAsFixed(1) : '10.5',
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    _daysController.dispose();
    _hoursController.dispose();
    _insuranceRateController.dispose();
    super.dispose();
  }

  void _submit() {
    final baseAmount = double.tryParse(_amountController.text.replaceAll(',', '').replaceAll('.', '')) ?? 0.0;
    final stdDays = double.tryParse(_daysController.text) ?? 26.0;
    final stdHours = double.tryParse(_hoursController.text) ?? 8.0;
    final insuranceRate = double.tryParse(_insuranceRateController.text) ?? 10.5;

    widget.onSave(
      salaryType: _selectedType,
      baseAmount: baseAmount,
      standardWorkingDays: stdDays,
      standardHoursPerDay: stdHours,
      enableInsurance: _enableInsurance,
      insuranceRate: insuranceRate,
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
              S.current.salaryProfile,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : AppColors.secondary,
              ),
            ),
            SizedBox(height: 16.h),

            // Salary Type Selector
            Text(
              S.current.salaryType,
              style: TextStyle(
                fontSize: 13.sp,
                color: isDark ? Colors.grey[400] : Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                _buildTypeChip('monthly', S.current.salaryMonthly, isDark),
                SizedBox(width: 8.w),
                _buildTypeChip('hourly', S.current.salaryHourly, isDark),
                SizedBox(width: 8.w),
                _buildTypeChip('daily', S.current.salaryDaily, isDark),
              ],
            ),
            SizedBox(height: 16.h),

            // Base Amount Input
            Text(
              _selectedType == 'monthly'
                  ? S.current.baseSalaryAmount
                  : (_selectedType == 'hourly' ? S.current.salaryHourly : S.current.salaryDaily),
              style: TextStyle(
                fontSize: 13.sp,
                color: isDark ? Colors.grey[400] : Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.h),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'VD: 15.000.000',
                suffixText: MoneyUtil.currencySymbol,
                filled: true,
                fillColor: isDark ? AppColors.darkSurfaceContainer : Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 16.h),

            // Standard Working Days / Hours
            if (_selectedType == 'monthly') ...[
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S.current.standardWorkingDays,
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: isDark ? Colors.grey[400] : Colors.grey[700],
                          ),
                        ),
                        SizedBox(height: 8.h),
                        TextField(
                          controller: _daysController,
                          keyboardType: TextInputType.number,
                          onChanged: (_) => setState(() {}),
                          decoration: InputDecoration(
                            hintText: '26',
                            suffixText: S.current.daysSuffix,
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
                          S.current.standardHoursPerDay,
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: isDark ? Colors.grey[400] : Colors.grey[700],
                          ),
                        ),
                        SizedBox(height: 8.h),
                        TextField(
                          controller: _hoursController,
                          keyboardType: TextInputType.number,
                          onChanged: (_) => setState(() {}),
                          decoration: InputDecoration(
                            hintText: '8',
                            suffixText: S.current.hoursSuffix,
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
              SizedBox(height: 16.h),
            ],

            // Live auto-calculation preview
            Builder(
              builder: (context) {
                final baseAmt = double.tryParse(_amountController.text.replaceAll(',', '').replaceAll('.', '')) ?? 0.0;
                final days = double.tryParse(_daysController.text) ?? 26.0;
                final hours = double.tryParse(_hoursController.text) ?? 8.0;

                double daily = 0.0;
                double hourly = 0.0;
                if (_selectedType == 'monthly') {
                  daily = days > 0 ? baseAmt / days : 0.0;
                  hourly = hours > 0 ? daily / hours : 0.0;
                } else if (_selectedType == 'hourly') {
                  hourly = baseAmt;
                  daily = hourly * hours;
                } else {
                  daily = baseAmt;
                  hourly = hours > 0 ? daily / hours : 0.0;
                }

                final ot15Rate = hourly * 1.5;
                final ot20Rate = hourly * 2.0;

                return Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(bottom: 16.h),
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
                        children: [
                          Icon(Icons.auto_awesome, size: 15.sp, color: const Color(0xFF10B981)),
                          SizedBox(width: 6.w),
                          Text(
                            S.current.autoCalculationPreview,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : const Color(0xFF065F46),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '• ${S.current.autoDailyRate}:',
                            style: TextStyle(fontSize: 12.sp, color: isDark ? Colors.grey[300] : Colors.grey[700]),
                          ),
                          Text(
                            '${MoneyUtil.formatMoney(daily)}/${S.current.daysSuffix}',
                            style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: const Color(0xFF10B981)),
                          ),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '• ${S.current.autoHourlyRate}:',
                            style: TextStyle(fontSize: 12.sp, color: isDark ? Colors.grey[300] : Colors.grey[700]),
                          ),
                          Text(
                            '${MoneyUtil.formatMoney(hourly)}/h',
                            style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87),
                          ),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '• ${S.current.otHourlyRateDesc} (1.5x):',
                            style: TextStyle(fontSize: 12.sp, color: isDark ? Colors.grey[300] : Colors.grey[700]),
                          ),
                          Text(
                            '${MoneyUtil.formatMoney(ot15Rate)}/h',
                            style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: const Color(0xFF2563EB)),
                          ),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '• ${S.current.otHourlyRateDesc} (2.0x):',
                            style: TextStyle(fontSize: 12.sp, color: isDark ? Colors.grey[300] : Colors.grey[700]),
                          ),
                          Text(
                            '${MoneyUtil.formatMoney(ot20Rate)}/h',
                            style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: const Color(0xFF7C3AED)),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),

            // Auto deduct insurance switch
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurfaceContainer : Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: isDark ? Colors.transparent : Colors.grey.shade200,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S.current.enableInsurance,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        Text(
                          S.current.autoDeductRules,
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: _enableInsurance,
                    activeTrackColor: AppColors.primary,
                    onChanged: (val) {
                      setState(() {
                        _enableInsurance = val;
                      });
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),

            // Save Button
            SizedBox(
              width: double.infinity,
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
                  S.current.saveChanges,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeChip(String type, String label, bool isDark) {
    final isSelected = _selectedType == type;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedType = type;
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary
                : (isDark ? AppColors.darkSurfaceContainer : Colors.grey.shade100),
            borderRadius: BorderRadius.circular(10.r),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected
                  ? Colors.white
                  : (isDark ? Colors.grey[300] : Colors.grey[800]),
            ),
          ),
        ),
      ),
    );
  }
}
