import 'package:equatable/equatable.dart';

class MemberModel extends Equatable {
  final int? id;
  final int tripId;
  final String name;
  final String? email;
  final DateTime createdAt;

  const MemberModel({
    this.id,
    required this.tripId,
    required this.name,
    this.email,
    required this.createdAt,
  });

  MemberModel copyWith({
    int? id,
    int? tripId,
    String? name,
    String? email,
    DateTime? createdAt,
  }) {
    return MemberModel(
      id: id ?? this.id,
      tripId: tripId ?? this.tripId,
      name: name ?? this.name,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        tripId,
        name,
        email,
        createdAt,
      ];
}
