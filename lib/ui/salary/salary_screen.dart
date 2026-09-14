import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../bloc/salary/salary_bloc.dart';
import '../../bloc/salary/salary_event.dart';
import '../../bloc/salary/salary_state.dart';
import '../../core/constants/colors.dart';
import '../../core/dependency/injection.dart';
import '../../core/locale/generated/l10n.dart';
import '../../core/services/ad_manager.dart';
import '../../core/services/report_export_service.dart';
import '../../core/services/review_service.dart';
import '../../core/util/money_util.dart';
import '../../data/local/salary_database.dart';
import '../components/banner_ad_widget.dart';
import 'widgets/day_attendance_sheet.dart';
import 'widgets/salary_settings_sheet.dart';

class SalaryScreen extends StatefulWidget {
  const SalaryScreen({super.key});

  @override
  State<SalaryScreen> createState() => _SalaryScreenState();
}

class _SalaryScreenState extends State<SalaryScreen> {
  late SalaryBloc _salaryBloc;

  @override
  void initState() {
    super.initState();
    _salaryBloc = getIt<SalaryBloc>();
    // Pre-load Interstitial ad
    AdManager.instance.loadInterstitialAd();
  }

  void _openSettings(SalaryProfile? profile) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SalarySettingsSheet(
        currentProfile: profile,
        onSave: ({
          required salaryType,
          required baseAmount,
          required standardWorkingDays,
          required standardHoursPerDay,
          required enableInsurance,
          required insuranceRate,
        }) {
          _salaryBloc.add(
            UpdateProfileEvent(
              salaryType: salaryType,
              baseAmount: baseAmount,
              standardWorkingDays: standardWorkingDays,
              standardHoursPerDay: standardHoursPerDay,
              enableInsurance: enableInsurance,
              insuranceRate: insuranceRate,
            ),
          );
        },
      ),
    );
  }

  void _openDayAttendance(DateTime date, Attendance? attendance) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DayAttendanceSheet(
        date: date,
        attendance: attendance,
        onSave: ({
          required date,
          required status,
          required otHours,
          required otMultiplier,
          required advanceAmount,
          required bonusAmount,
          note,
        }) {
          _salaryBloc.add(
            UpdateAttendanceEvent(
              date: date,
              status: status,
              otHours: otHours,
              otMultiplier: otMultiplier,
              advanceAmount: advanceAmount,
              bonusAmount: bonusAmount,
              note: note,
            ),
          );
        },
        onDelete: () {
          _salaryBloc.add(
            UpdateAttendanceEvent(
              date: date,
              status: 'leave_unpaid',
              otHours: 0,
              advanceAmount: 0,
              bonusAmount: 0,
            ),
          );
        },
      ),
    );
  }

  void _confirmFinalize(BuildContext context, SalaryState state) {
    final monthStr = '${state.selectedMonth.month}/${state.selectedMonth.year}';
    final amountFormatted = MoneyUtil.formatMoney(state.estimatedSalary);

    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: Text(S.current.finalizeSalary),
        content: Text(
          S.current.confirmFinalizeSalary(monthStr, amountFormatted),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: Text(S.current.cancelButton),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(dialogCtx);
              _salaryBloc.add(
                FinalizeSalaryToIncome(
                  finalAmount: state.estimatedSalary,
                  note: 'Lương tháng $monthStr',
                ),
              );
              // Trigger interstitial ad on high-value action
              AdManager.instance.showInterstitialAd(force: true);
              // Request In-App Review at this happy milestone
              ReviewService.requestReview();
            },
            child: Text(S.current.finalizeSalary),
          ),
        ],
      ),
    );
  }

  void _showExportSheet(BuildContext context, SalaryState state) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                S.current.exportReport,
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 6.h),
              Text(
                DateFormat('MM/yyyy').format(state.selectedMonth),
                style: TextStyle(fontSize: 13.sp, color: Colors.grey),
              ),
              SizedBox(height: 16.h),
              ListTile(
                leading: Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.picture_as_pdf, color: Colors.red),
                ),
                title: Text(S.current.exportPdf),
                subtitle: Text(S.current.exportPdfDesc),
                trailing: const Icon(Icons.chevron_right),
                onTap: () async {
                  Navigator.pop(ctx);
                  await ReportExportService.exportToPdf(state);
                },
              ),
              const Divider(),
              ListTile(
                leading: Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.table_chart, color: Colors.green),
                ),
                title: Text(S.current.exportExcel),
                subtitle: Text(S.current.exportExcelDesc),
                trailing: const Icon(Icons.chevron_right),
                onTap: () async {
                  Navigator.pop(ctx);
                  await ReportExportService.exportToCsv(state);
                },
              ),
              SizedBox(height: 12.h),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider.value(
      value: _salaryBloc,
      child: BlocConsumer<SalaryBloc, SalaryState>(
        listener: (context, state) {
          if (state.successMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.successMessage!),
                backgroundColor: AppColors.upGreen,
              ),
            );
          }
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: AppColors.downRed,
              ),
            );
          }
        },
        builder: (context, state) {
          final profile = state.profile;
          final currentMonth = state.selectedMonth;

          return Scaffold(
            appBar: AppBar(
              title: Text(
                S.current.salaryAndAttendance,
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: const Icon(Icons.file_download_outlined),
                  tooltip: S.current.exportReport,
                  onPressed: () => _showExportSheet(context, state),
                ),
                IconButton(
                  icon: const Icon(Icons.settings_outlined),
                  tooltip: S.current.salaryProfile,
                  onPressed: () => _openSettings(profile),
                ),
              ],
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Month Navigator
                  _buildMonthNavigator(currentMonth, isDark),
                  SizedBox(height: 12.h),

                  // Hero Salary Card
                  _buildSalaryHeroCard(context, state, isDark),
                  SizedBox(height: 16.h),

                  // Quick Check-in Today Bar
                  _buildQuickCheckInBar(isDark),
                  SizedBox(height: 16.h),

                  // Calendar Grid
                  _buildCalendarGrid(context, state, isDark),
                  SizedBox(height: 16.h),
                  
                  const BannerAdWidget(),
                  SizedBox(height: 100.h),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMonthNavigator(DateTime month, bool isDark) {
    final locale = Localizations.localeOf(context).languageCode == 'vi' ? 'vi_VN' : 'en_US';
    final monthFormat = DateFormat('MMMM yyyy', locale).format(month);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () {
              final prev = DateTime(month.year, month.month - 1, 1);
              _salaryBloc.add(ChangeMonth(month: prev));
            },
          ),
          Text(
            monthFormat.toUpperCase(),
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.secondary,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () {
              final next = DateTime(month.year, month.month + 1, 1);
              _salaryBloc.add(ChangeMonth(month: next));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSalaryHeroCard(BuildContext context, SalaryState state, bool isDark) {
    final stdDays = state.profile?.standardWorkingDays ?? 26.0;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF13547A), const Color(0xFF0F4560)]
              : [AppColors.secondary, const Color(0xFF1E6B99)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondary.withAlpha(50),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                S.current.estimatedSalary.toUpperCase(),
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                  letterSpacing: 0.5,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: Colors.white12,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  state.profile?.salaryType == 'hourly'
                      ? S.current.salaryHourly
                      : (state.profile?.salaryType == 'daily'
                          ? S.current.salaryDaily
                          : S.current.salaryMonthly),
                  style: TextStyle(fontSize: 11.sp, color: Colors.white70),
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Text(
            MoneyUtil.formatMoney(state.estimatedSalary),
            style: TextStyle(
              fontSize: 28.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 14.h),
          const Divider(color: Colors.white24, height: 1),
          SizedBox(height: 12.h),

          // 4 stats grid
          Row(
            children: [
              _buildStatItem('Công làm', '${state.totalWorkDays.toStringAsFixed(1)}/${stdDays.toStringAsFixed(0)}'),
              _buildStatItem('Giờ OT', '${state.totalOtHours.toStringAsFixed(1)}h (+${MoneyUtil.formatMoney(state.totalOtMoney)})'),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              _buildStatItem('Đã ứng', '-${MoneyUtil.formatMoney(state.totalAdvance)}'),
              _buildStatItem('Trừ BHXH', '-${MoneyUtil.formatMoney(state.insuranceDeduction)}'),
            ],
          ),
          SizedBox(height: 16.h),

          // Finalize button
          SizedBox(
            width: double.infinity,
            height: 42.h,
            child: ElevatedButton.icon(
              onPressed: state.estimatedSalary > 0
                  ? () => _confirmFinalize(context, state)
                  : null,
              icon: const Icon(Icons.account_balance_wallet_outlined, size: 18),
              label: Text(
                S.current.finalizeSalary,
                style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.secondary,
                disabledBackgroundColor: Colors.white24,
                disabledForegroundColor: Colors.white38,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 11.sp, color: Colors.white60),
          ),
          SizedBox(height: 2.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickCheckInBar(bool isDark) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.current.quickCheckIn,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.secondary,
            ),
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              _buildQuickButton(
                label: S.current.checkInFull,
                color: AppColors.upGreen,
                onTap: () => _salaryBloc.add(const QuickCheckInToday(status: 'full')),
              ),
              SizedBox(width: 8.w),
              _buildQuickButton(
                label: S.current.checkInHalf,
                color: Colors.orange,
                onTap: () => _salaryBloc.add(const QuickCheckInToday(status: 'half')),
              ),
              SizedBox(width: 8.w),
              _buildQuickButton(
                label: S.current.leavePaid,
                color: Colors.blue,
                onTap: () => _salaryBloc.add(const QuickCheckInToday(status: 'leave_paid')),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickButton({
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10.r),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          decoration: BoxDecoration(
            color: color.withAlpha(25),
            border: Border.all(color: color.withAlpha(120)),
            borderRadius: BorderRadius.circular(10.r),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCalendarGrid(BuildContext context, SalaryState state, bool isDark) {
    final month = state.selectedMonth;
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final firstWeekday = DateTime(month.year, month.month, 1).weekday; // 1 = Monday, 7 = Sunday

    // Map attendances by day
    final attMap = <int, Attendance>{};
    for (final att in state.attendances) {
      attMap[att.date.day] = att;
    }

    final isVi = Localizations.localeOf(context).languageCode == 'vi';
    final weekdays = isVi ? ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'] : ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Weekday headers
          Row(
            children: weekdays.map((w) {
              return Expanded(
                child: Center(
                  child: Text(
                    w,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 10.h),

          // Days Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: (firstWeekday - 1) + daysInMonth,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              crossAxisSpacing: 4.w,
              mainAxisSpacing: 4.h,
              childAspectRatio: 0.9,
            ),
            itemBuilder: (context, index) {
              if (index < firstWeekday - 1) {
                return const SizedBox.shrink();
              }
              final dayNumber = index - (firstWeekday - 1) + 1;
              final date = DateTime(month.year, month.month, dayNumber);
              final att = attMap[dayNumber];
              final isToday = DateTime.now().year == date.year &&
                  DateTime.now().month == date.month &&
                  DateTime.now().day == date.day;

              return _buildDayCell(date, dayNumber, att, isToday, isDark);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDayCell(
    DateTime date,
    int dayNumber,
    Attendance? att,
    bool isToday,
    bool isDark,
  ) {
    Color? statusColor;
    String? statusBadge;

    if (att != null) {
      switch (att.status) {
        case 'full':
          statusColor = AppColors.upGreen;
          break;
        case 'half':
          statusColor = Colors.orange;
          statusBadge = '½';
          break;
        case 'leave_paid':
          statusColor = Colors.blue;
          statusBadge = 'P';
          break;
        case 'leave_unpaid':
          statusColor = AppColors.downRed;
          statusBadge = 'K';
          break;
      }
    }

    return InkWell(
      onTap: () => _openDayAttendance(date, att),
      borderRadius: BorderRadius.circular(10.r),
      child: Container(
        decoration: BoxDecoration(
          color: statusColor != null
              ? statusColor.withAlpha(isDark ? 50 : 35)
              : (isDark ? AppColors.darkSurfaceContainer : Colors.grey.shade50),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: isToday
                ? AppColors.primary
                : (statusColor != null ? statusColor.withAlpha(120) : Colors.transparent),
            width: isToday ? 2 : 1,
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Text(
                '$dayNumber',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: isToday ? FontWeight.bold : FontWeight.w500,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ),
            if (statusBadge != null)
              Positioned(
                top: 2,
                left: 3,
                child: Text(
                  statusBadge,
                  style: TextStyle(
                    fontSize: 9.sp,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
              ),
            if (att != null && att.otHours > 0)
              Positioned(
                top: 2,
                right: 3,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 2.w),
                  decoration: BoxDecoration(
                    color: Colors.purple,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    '+${att.otHours.toStringAsFixed(0)}',
                    style: TextStyle(fontSize: 8.sp, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            if (att != null && att.advanceAmount > 0)
              Positioned(
                bottom: 2,
                right: 3,
                child: Icon(
                  Icons.attach_money,
                  size: 11.sp,
                  color: Colors.orange.shade800,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
