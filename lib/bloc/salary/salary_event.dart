import 'package:equatable/equatable.dart';

abstract class SalaryEvent extends Equatable {
  const SalaryEvent();

  @override
  List<Object?> get props => [];
}

class LoadSalaryData extends SalaryEvent {
  final DateTime month;
  const LoadSalaryData({required this.month});

  @override
  List<Object?> get props => [month];
}

class ChangeMonth extends SalaryEvent {
  final DateTime month;
  const ChangeMonth({required this.month});

  @override
  List<Object?> get props => [month];
}

class UpdateAttendanceEvent extends SalaryEvent {
  final DateTime date;
  final String status;
  final double otHours;
  final double otMultiplier;
  final double advanceAmount;
  final double bonusAmount;
  final String? note;

  const UpdateAttendanceEvent({
    required this.date,
    required this.status,
    this.otHours = 0.0,
    this.otMultiplier = 1.5,
    this.advanceAmount = 0.0,
    this.bonusAmount = 0.0,
    this.note,
  });

  @override
  List<Object?> get props => [date, status, otHours, otMultiplier, advanceAmount, bonusAmount, note];
}

class QuickCheckInToday extends SalaryEvent {
  final String status; // 'full', 'half', 'leave_paid', 'leave_unpaid'
  const QuickCheckInToday({required this.status});

  @override
  List<Object?> get props => [status];
}

class UpdateProfileEvent extends SalaryEvent {
  final String salaryType;
  final double baseAmount;
  final double standardWorkingDays;
  final double standardHoursPerDay;
  final bool enableInsurance;
  final double insuranceRate;

  const UpdateProfileEvent({
    required this.salaryType,
    required this.baseAmount,
    required this.standardWorkingDays,
    required this.standardHoursPerDay,
    required this.enableInsurance,
    required this.insuranceRate,
  });

  @override
  List<Object?> get props => [
        salaryType,
        baseAmount,
        standardWorkingDays,
        standardHoursPerDay,
        enableInsurance,
        insuranceRate,
      ];
}

class FinalizeSalaryToIncome extends SalaryEvent {
  final double finalAmount;
  final String note;

  const FinalizeSalaryToIncome({
    required this.finalAmount,
    this.note = '',
  });

  @override
  List<Object?> get props => [finalAmount, note];
}
