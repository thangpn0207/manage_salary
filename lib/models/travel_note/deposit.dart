import 'package:equatable/equatable.dart';

class DepositModel extends Equatable {
  final int? id;
  final int tripId;
  final int memberId;
  final double amount;
  final DateTime createdAt;

  const DepositModel({
    this.id,
    required this.tripId,
    required this.memberId,
    required this.amount,
    required this.createdAt,
  });

  DepositModel copyWith({
    int? id,
    int? tripId,
    int? memberId,
    double? amount,
    DateTime? createdAt,
  }) {
    return DepositModel(
      id: id ?? this.id,
      tripId: tripId ?? this.tripId,
      memberId: memberId ?? this.memberId,
      amount: amount ?? this.amount,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        tripId,
        memberId,
        amount,
        createdAt,
      ];
}
