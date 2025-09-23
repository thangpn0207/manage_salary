import 'package:equatable/equatable.dart';

enum SplitType { equal, custom }

class ActionModel extends Equatable {
  final int? id;
  final int tripId;
  final String title;
  final String? description;
  final bool isGroupBudget;
  final int payerId;
  final double amount;
  final SplitType splitType;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ActionModel({
    required this.isGroupBudget,
    this.id,
    required this.tripId,
    required this.title,
    this.description,
    required this.payerId,
    required this.amount,
    required this.splitType,
    required this.createdAt,
    required this.updatedAt,
  });

  ActionModel copyWith({
    int? id,
    int? tripId,
    String? title,
    String? description,
    int? payerId,
    bool? isGroupBudget,
    double? amount,
    SplitType? splitType,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ActionModel(
      id: id ?? this.id,
      tripId: tripId ?? this.tripId,
      title: title ?? this.title,
      description: description ?? this.description,
      payerId: payerId ?? this.payerId,
      amount: amount ?? this.amount,
      splitType: splitType ?? this.splitType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isGroupBudget: isGroupBudget ?? this.isGroupBudget,
    );
  }

  @override
  List<Object?> get props => [
        id,
        tripId,
        title,
        description,
        payerId,
        amount,
        splitType,
        createdAt,
        updatedAt,
        isGroupBudget
      ];
}
