import 'package:equatable/equatable.dart';

class TravelNoteModel extends Equatable {
  final int? id;
  final int tripId;
  final String title;
  final String content;
  final int ownerId;
  final DateTime createdAt;
  final DateTime updatedAt;

  const TravelNoteModel({
    this.id,
    required this.tripId,
    required this.title,
    required this.content,
    required this.ownerId,
    required this.createdAt,
    required this.updatedAt,
  });

  TravelNoteModel copyWith({
    int? id,
    int? tripId,
    String? title,
    String? content,
    int? ownerId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TravelNoteModel(
      id: id ?? this.id,
      tripId: tripId ?? this.tripId,
      title: title ?? this.title,
      content: content ?? this.content,
      ownerId: ownerId ?? this.ownerId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        tripId,
        title,
        content,
        ownerId,
        createdAt,
        updatedAt,
      ];
}
