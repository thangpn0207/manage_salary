import 'package:equatable/equatable.dart';

class ActionShareModel extends Equatable {
  final int? id;
  final int actionId;
  final int memberId;
  final double amountOwed;
  final DateTime createdAt;

  const ActionShareModel({
    this.id,
    required this.actionId,
    required this.memberId,
    required this.amountOwed,
    required this.createdAt,
  });

  ActionShareModel copyWith({
    int? id,
    int? actionId,
    int? memberId,
    double? amountOwed,
    DateTime? createdAt,
  }) {
    return ActionShareModel(
      id: id ?? this.id,
      actionId: actionId ?? this.actionId,
      memberId: memberId ?? this.memberId,
      amountOwed: amountOwed ?? this.amountOwed,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        actionId,
        memberId,
        amountOwed,
        createdAt,
      ];
}
