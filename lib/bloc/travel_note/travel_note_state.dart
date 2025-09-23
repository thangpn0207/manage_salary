import 'package:equatable/equatable.dart';

import '../../models/travel_note/action_model.dart';
import '../../models/travel_note/action_share.dart';
import '../../models/travel_note/deposit.dart';
import '../../models/travel_note/member.dart';
import '../../models/travel_note/travel_note.dart';
import '../../models/travel_note/trip.dart';

class TravelNoteState extends Equatable {
  final List<TripModel> trips;
  final TripModel? selectedTrip;
  final List<MemberModel> members;
  final List<ActionModel> actions;
  final List<ActionShareModel> actionShares;
  final List<DepositModel> deposits;
  final List<TravelNoteModel> travelNotes;
  final Map<String, dynamic>? summary;
  final bool isLoading;
  final String? error;

  const TravelNoteState({
    this.error,
    this.isLoading = false,
    this.trips = const [],
    this.selectedTrip,
    this.members = const [],
    this.actions = const [],
    this.actionShares = const [],
    this.deposits = const [],
    this.travelNotes = const [],
    this.summary,
  });

  TravelNoteState copyWith(
      {List<TripModel>? trips,
      TripModel? selectedTrip,
      List<MemberModel>? members,
      List<ActionModel>? actions,
      List<ActionShareModel>? actionShares,
      List<DepositModel>? deposits,
      List<TravelNoteModel>? travelNotes,
      Map<String, dynamic>? summary,
      bool? isLoading,
      String? error}) {
    return TravelNoteState(
      error: error ?? this.error,
      isLoading: isLoading ?? this.isLoading,
      trips: trips ?? this.trips,
      selectedTrip: selectedTrip ?? this.selectedTrip,
      members: members ?? this.members,
      actions: actions ?? this.actions,
      actionShares: actionShares ?? this.actionShares,
      deposits: deposits ?? this.deposits,
      travelNotes: travelNotes ?? this.travelNotes,
      summary: summary ?? this.summary,
    );
  }

  @override
  List<Object?> get props => [
        trips,
        selectedTrip,
        members,
        actions,
        actionShares,
        deposits,
        travelNotes,
        summary,
        isLoading,
        error
      ];
}
