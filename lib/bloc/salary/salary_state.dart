import 'package:equatable/equatable.dart';
import '../../data/local/salary_database.dart';

class SalaryState extends Equatable {
  final bool isLoading;
  final DateTime selectedMonth;
  final SalaryProfile? profile;
  final List<Attendance> attendances;
  final double totalWorkDays;
  final double totalOtHours;
  final double totalOtMoney;
  final double totalAdvance;
  final double totalBonus;
  final double insuranceDeduction;
  final double estimatedSalary;
  final double dailyRate;
  final double hourlyRate;
  final double otHourlyRate;
  final String? errorMessage;
  final String? successMessage;

  const SalaryState({
    required this.isLoading,
    required this.selectedMonth,
    this.profile,
    this.attendances = const [],
    this.totalWorkDays = 0.0,
    this.totalOtHours = 0.0,
    this.totalOtMoney = 0.0,
    this.totalAdvance = 0.0,
    this.totalBonus = 0.0,
    this.insuranceDeduction = 0.0,
    this.estimatedSalary = 0.0,
    this.dailyRate = 0.0,
    this.hourlyRate = 0.0,
    this.otHourlyRate = 0.0,
    this.errorMessage,
    this.successMessage,
  });

  factory SalaryState.initial() {
    final now = DateTime.now();
    return SalaryState(
      isLoading: true,
      selectedMonth: DateTime(now.year, now.month, 1),
    );
  }

  SalaryState copyWith({
    bool? isLoading,
    DateTime? selectedMonth,
    SalaryProfile? profile,
    List<Attendance>? attendances,
    double? totalWorkDays,
    double? totalOtHours,
    double? totalOtMoney,
    double? totalAdvance,
    double? totalBonus,
    double? insuranceDeduction,
    double? estimatedSalary,
    double? dailyRate,
    double? hourlyRate,
    double? otHourlyRate,
    String? errorMessage,
    String? successMessage,
    bool clearMessage = false,
  }) {
    return SalaryState(
      isLoading: isLoading ?? this.isLoading,
      selectedMonth: selectedMonth ?? this.selectedMonth,
      profile: profile ?? this.profile,
      attendances: attendances ?? this.attendances,
      totalWorkDays: totalWorkDays ?? this.totalWorkDays,
      totalOtHours: totalOtHours ?? this.totalOtHours,
      totalOtMoney: totalOtMoney ?? this.totalOtMoney,
      totalAdvance: totalAdvance ?? this.totalAdvance,
      totalBonus: totalBonus ?? this.totalBonus,
      insuranceDeduction: insuranceDeduction ?? this.insuranceDeduction,
      estimatedSalary: estimatedSalary ?? this.estimatedSalary,
      dailyRate: dailyRate ?? this.dailyRate,
      hourlyRate: hourlyRate ?? this.hourlyRate,
      otHourlyRate: otHourlyRate ?? this.otHourlyRate,
      errorMessage: clearMessage ? null : (errorMessage ?? this.errorMessage),
      successMessage: clearMessage ? null : (successMessage ?? this.successMessage),
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        selectedMonth,
        profile,
        attendances,
        totalWorkDays,
        totalOtHours,
        totalOtMoney,
        totalAdvance,
        totalBonus,
        insuranceDeduction,
        estimatedSalary,
        dailyRate,
        hourlyRate,
        otHourlyRate,
        errorMessage,
        successMessage,
      ];
}
