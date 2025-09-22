import 'package:equatable/equatable.dart';

import '../../models/travel_note/action_model.dart';
import '../../models/travel_note/deposit.dart';
import '../../models/travel_note/member.dart';
import '../../models/travel_note/travel_note.dart';
import '../../models/travel_note/trip.dart';

abstract class TravelNoteEvent extends Equatable {
  const TravelNoteEvent();

  @override
  List<Object?> get props => [];
}

class LoadTravelNotes extends TravelNoteEvent {
  final int tripId;

  const LoadTravelNotes(this.tripId);

  @override
  List<Object?> get props => [tripId];
}

class CreateTravelNote extends TravelNoteEvent {
  final TravelNoteModel note;

  const CreateTravelNote(this.note);

  @override
  List<Object?> get props => [note];
}

class UpdateTravelNote extends TravelNoteEvent {
  final TravelNoteModel note;

  const UpdateTravelNote(this.note);

  @override
  List<Object?> get props => [note];
}

class DeleteTravelNote extends TravelNoteEvent {
  final int noteId;

  const DeleteTravelNote(this.noteId);

  @override
  List<Object?> get props => [noteId];
}

class LoadTrips extends TravelNoteEvent {}

class CreateTrip extends TravelNoteEvent {
  final TripModel trip;

  const CreateTrip(this.trip);

  @override
  List<Object?> get props => [trip];
}

class UpdateTrip extends TravelNoteEvent {
  final TripModel trip;

  const UpdateTrip(this.trip);

  @override
  List<Object?> get props => [trip];
}

class DeleteTrip extends TravelNoteEvent {
  final int tripId;

  const DeleteTrip(this.tripId);

  @override
  List<Object?> get props => [tripId];
}

class SelectTrip extends TravelNoteEvent {
  final int tripId;

  const SelectTrip(this.tripId);

  @override
  List<Object?> get props => [tripId];
}

class LoadMembers extends TravelNoteEvent {
  final int tripId;

  const LoadMembers(this.tripId);

  @override
  List<Object?> get props => [tripId];
}

class CreateMember extends TravelNoteEvent {
  final MemberModel member;

  const CreateMember(this.member);

  @override
  List<Object?> get props => [member];
}

class UpdateMember extends TravelNoteEvent {
  final MemberModel member;

  const UpdateMember(this.member);

  @override
  List<Object?> get props => [member];
}

class DeleteMember extends TravelNoteEvent {
  final int memberId;

  const DeleteMember(this.memberId);

  @override
  List<Object?> get props => [memberId];
}

class LoadActions extends TravelNoteEvent {
  final int tripId;

  const LoadActions(this.tripId);

  @override
  List<Object?> get props => [tripId];
}

class AddAction extends TravelNoteEvent {
  final ActionModel action;
  final Map<int, double>? customShares;

  const AddAction(this.action, {this.customShares});

  @override
  List<Object?> get props => [action, customShares];
}

class RemoveAction extends TravelNoteEvent {
  final int actionId;

  const RemoveAction(this.actionId);

  @override
  List<Object?> get props => [actionId];
}

class UpdateAction extends TravelNoteEvent {
  final ActionModel action;
  final Map<int, double>? customShares;

  const UpdateAction(this.action, {this.customShares});

  @override
  List<Object?> get props => [action, customShares];
}

class LoadDeposits extends TravelNoteEvent {
  final int tripId;

  const LoadDeposits(this.tripId);

  @override
  List<Object?> get props => [tripId];
}

class AddDeposit extends TravelNoteEvent {
  final DepositModel deposit;

  const AddDeposit(this.deposit);

  @override
  List<Object?> get props => [deposit];
}

class UpdateDeposit extends TravelNoteEvent {
  final DepositModel deposit;

  const UpdateDeposit(this.deposit);

  @override
  List<Object?> get props => [deposit];
}

class DeleteDeposit extends TravelNoteEvent {
  final int depositId;

  const DeleteDeposit(this.depositId);

  @override
  List<Object?> get props => [depositId];
}

class LoadSummary extends TravelNoteEvent {
  final int tripId;

  const LoadSummary(this.tripId);

  @override
  List<Object?> get props => [tripId];
}

class UpdateStateTrips extends TravelNoteEvent {
  final List<TripModel> trips;

  const UpdateStateTrips({required this.trips});
}

class UpdateStateMember extends TravelNoteEvent {
  final List<MemberModel> members;

  const UpdateStateMember({required this.members});
}

class UpdateStateAction extends TravelNoteEvent {
  final List<ActionModel> actions;

  const UpdateStateAction({required this.actions});
}

class UpdateStateDeposits extends TravelNoteEvent {
  final List<DepositModel> deposits;

  const UpdateStateDeposits({required this.deposits});
}

class UpdateStateTravelNotes extends TravelNoteEvent {
  final List<TravelNoteModel> travelNotes;

  const UpdateStateTravelNotes({required this.travelNotes});
}
