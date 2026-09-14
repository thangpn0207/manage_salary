import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/enums.dart';
import '../../core/util/money_util.dart';
import '../../data/local/salary_database.dart';
import '../../data/repositories/salary_repository.dart';
import '../../models/activity_data.dart';
import '../activity/activity_bloc.dart';
import '../activity/activity_event.dart';
import 'salary_event.dart';
import 'salary_state.dart';

class SalaryBloc extends Bloc<SalaryEvent, SalaryState> {
  final SalaryRepository _repository;
  final ActivityBloc _activityBloc;

  SalaryBloc({
    required SalaryRepository repository,
    required ActivityBloc activityBloc,
  })  : _repository = repository,
        _activityBloc = activityBloc,
        super(SalaryState.initial()) {
    on<LoadSalaryData>(_onLoadSalaryData);
    on<ChangeMonth>(_onChangeMonth);
    on<UpdateAttendanceEvent>(_onUpdateAttendance);
    on<QuickCheckInToday>(_onQuickCheckInToday);
    on<UpdateProfileEvent>(_onUpdateProfile);
    on<FinalizeSalaryToIncome>(_onFinalizeSalaryToIncome);

    // Initial load for current month
    final now = DateTime.now();
    add(LoadSalaryData(month: DateTime(now.year, now.month, 1)));
  }

  Future<void> _onLoadSalaryData(
    LoadSalaryData event,
    Emitter<SalaryState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, selectedMonth: event.month));
    try {
      final profile = await _repository.getSalaryProfile();
      final attendances = await _repository.getAttendancesForMonth(
        event.month.year,
        event.month.month,
      );
      _emitCalculatedState(emit, profile, attendances, event.month);
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Lỗi tải dữ liệu chấm công: $e',
      ));
    }
  }

  Future<void> _onChangeMonth(
    ChangeMonth event,
    Emitter<SalaryState> emit,
  ) async {
    add(LoadSalaryData(month: event.month));
  }

  Future<void> _onQuickCheckInToday(
    QuickCheckInToday event,
    Emitter<SalaryState> emit,
  ) async {
    final now = DateTime.now();
    try {
      await _repository.setAttendance(
        date: now,
        status: event.status,
      );
      add(LoadSalaryData(month: state.selectedMonth));
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Lỗi chấm công: $e'));
    }
  }

  Future<void> _onUpdateAttendance(
    UpdateAttendanceEvent event,
    Emitter<SalaryState> emit,
  ) async {
    try {
      await _repository.setAttendance(
        date: event.date,
        status: event.status,
        otHours: event.otHours,
        otMultiplier: event.otMultiplier,
        advanceAmount: event.advanceAmount,
        bonusAmount: event.bonusAmount,
        note: event.note,
      );
      add(LoadSalaryData(month: state.selectedMonth));
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Lỗi cập nhật chấm công: $e'));
    }
  }

  Future<void> _onUpdateProfile(
    UpdateProfileEvent event,
    Emitter<SalaryState> emit,
  ) async {
    if (state.profile == null) return;
    try {
      await _repository.updateSalaryProfile(
        id: state.profile!.id,
        salaryType: event.salaryType,
        baseAmount: event.baseAmount,
        standardWorkingDays: event.standardWorkingDays,
        standardHoursPerDay: event.standardHoursPerDay,
        enableInsurance: event.enableInsurance,
        insuranceRate: event.insuranceRate,
      );
      add(LoadSalaryData(month: state.selectedMonth));
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Lỗi cập nhật cấu hình lương: $e'));
    }
  }

  Future<void> _onFinalizeSalaryToIncome(
    FinalizeSalaryToIncome event,
    Emitter<SalaryState> emit,
  ) async {
    if (event.finalAmount <= 0) {
      emit(state.copyWith(errorMessage: 'Số tiền lương phải lớn hơn 0'));
      return;
    }

    try {
      final monthStr = '${state.selectedMonth.month}/${state.selectedMonth.year}';
      final title = event.note.isNotEmpty ? event.note : 'Lương tháng $monthStr';

      _activityBloc.add(
        AddActivity(
          ActivityData(
            nature: ActivityNature.income,
            title: title,
            amount: event.finalAmount,
            date: DateTime.now(),
            type: ActivityType.salary,
            currencyCode: MoneyUtil.currentCurrencyCode,
          ),
        ),
      );

      emit(state.copyWith(
        successMessage: 'Đã chuyển thành công ${event.finalAmount.toStringAsFixed(0)} vào Sổ thu chi!',
      ));
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Lỗi chốt lương: $e'));
    }
  }

  void _emitCalculatedState(
    Emitter<SalaryState> emit,
    SalaryProfile profile,
    List<Attendance> attendances,
    DateTime month,
  ) {
    double totalWorkDays = 0.0;
    double totalOtHours = 0.0;
    double totalOtMoney = 0.0;
    double totalAdvance = 0.0;
    double totalBonus = 0.0;

    // Rates calculation
    double dailyRate = 0.0;
    double hourlyRate = 0.0;

    final stdDays = profile.standardWorkingDays > 0 ? profile.standardWorkingDays : 26.0;
    final stdHours = profile.standardHoursPerDay > 0 ? profile.standardHoursPerDay : 8.0;

    if (profile.salaryType == 'monthly') {
      dailyRate = profile.baseAmount / stdDays;
      hourlyRate = dailyRate / stdHours;
    } else if (profile.salaryType == 'hourly') {
      hourlyRate = profile.baseAmount;
      dailyRate = hourlyRate * stdHours;
    } else {
      // 'daily'
      dailyRate = profile.baseAmount;
      hourlyRate = dailyRate / stdHours;
    }

    for (final att in attendances) {
      // Work day counting
      if (att.status == 'full') {
        totalWorkDays += 1.0;
      } else if (att.status == 'half') {
        totalWorkDays += 0.5;
      } else if (att.status == 'leave_paid') {
        totalWorkDays += 1.0;
      }
      // 'leave_unpaid' adds 0

      // Overtime
      if (att.otHours > 0) {
        totalOtHours += att.otHours;
        final multiplier = att.otMultiplier > 0 ? att.otMultiplier : 1.5;
        totalOtMoney += att.otHours * hourlyRate * multiplier;
      }

      totalAdvance += att.advanceAmount;
      totalBonus += att.bonusAmount;
    }

    final baseEarned = totalWorkDays * dailyRate;

    // Insurance deduction
    double insuranceDeduction = 0.0;
    if (profile.enableInsurance) {
      final rate = profile.insuranceRate > 0 ? profile.insuranceRate : 10.5;
      insuranceDeduction = profile.baseAmount * (rate / 100.0);
    }

    final estimatedSalary = max(
      0.0,
      baseEarned + totalOtMoney + totalBonus - totalAdvance - insuranceDeduction,
    );

    emit(state.copyWith(
      isLoading: false,
      selectedMonth: month,
      profile: profile,
      attendances: attendances,
      totalWorkDays: totalWorkDays,
      totalOtHours: totalOtHours,
      totalOtMoney: totalOtMoney,
      totalAdvance: totalAdvance,
      totalBonus: totalBonus,
      insuranceDeduction: insuranceDeduction,
      estimatedSalary: estimatedSalary,
      dailyRate: dailyRate,
      hourlyRate: hourlyRate,
      otHourlyRate: hourlyRate * 1.5,
      clearMessage: true,
    ));
  }
}
