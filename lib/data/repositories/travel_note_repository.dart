import 'package:drift/drift.dart';

import '../../models/travel_note/action_model.dart';
import '../../models/travel_note/action_share.dart';
import '../../models/travel_note/deposit.dart';
import '../../models/travel_note/member.dart';
import '../../models/travel_note/travel_note.dart';
import '../../models/travel_note/trip.dart';
import '../local/travel_note_database.dart';

class TravelNoteRepository {
  final TravelNoteDatabase _database;

  TravelNoteRepository(this._database);

  // Trip operations
  Future<List<TripModel>> getAllTrips() async {
    final trips = await _database.select(_database.trips).get();
    return trips.map(_tripFromData).toList();
  }

  Stream<List<TripModel>> watchAllTrips() {
    return _database.select(_database.trips).watch().map(
          (trips) => trips.map(_tripFromData).toList(),
        );
  }

  Future<TripModel?> getTripById(int id) async {
    final trip = await (_database.select(_database.trips)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return trip != null ? _tripFromData(trip) : null;
  }

  Future<int> createTrip(TripModel trip) {
    return _database.into(_database.trips).insert(TripsCompanion(
          title: Value(trip.title),
          description: Value(trip.description),
          startDate: Value(trip.startDate),
          endDate: Value(trip.endDate),
          createdAt: Value(trip.createdAt),
          updatedAt: Value(trip.updatedAt),
        ));
  }

  Future<bool> updateTrip(TripModel trip) {
    return _database.update(_database.trips).replace(TripsCompanion(
          id: Value(trip.id!),
          title: Value(trip.title),
          description: Value(trip.description),
          startDate: Value(trip.startDate),
          endDate: Value(trip.endDate),
          createdAt: Value(trip.createdAt),
          updatedAt: Value(trip.updatedAt),
        ));
  }

  Future<int> deleteTrip(int id) {
    return (_database.delete(_database.trips)..where((t) => t.id.equals(id)))
        .go();
  }

  // Member operations
  Future<List<MemberModel>> getMembersByTripId(int tripId) async {
    final members = await (_database.select(_database.members)
          ..where((m) => m.tripId.equals(tripId)))
        .get();
    return members.map(_memberFromData).toList();
  }

  Stream<List<MemberModel>> watchMembersByTripId(int tripId) {
    return (_database.select(_database.members)
          ..where((m) => m.tripId.equals(tripId)))
        .watch()
        .map((members) => members.map(_memberFromData).toList());
  }

  Future<int> createMember(MemberModel member) {
    return _database.into(_database.members).insert(MembersCompanion(
          tripId: Value(member.tripId),
          name: Value(member.name),
          email: Value(member.email),
          createdAt: Value(member.createdAt),
        ));
  }

  Future<bool> updateMember(MemberModel member) {
    return _database.update(_database.members).replace(MembersCompanion(
          id: Value(member.id!),
          tripId: Value(member.tripId),
          name: Value(member.name),
          email: Value(member.email),
          createdAt: Value(member.createdAt),
        ));
  }

  Future<int> deleteMember(int id) {
    return (_database.delete(_database.members)..where((m) => m.id.equals(id)))
        .go();
  }

  // Action operations
  Future<List<ActionModel>> getActionsByTripId(int tripId) async {
    final actions = await (_database.select(_database.actions)
          ..where((a) => a.tripId.equals(tripId)))
        .get();
    return actions.map(_actionFromData).toList();
  }

  Stream<List<ActionModel>> watchActionsByTripId(int tripId) {
    return (_database.select(_database.actions)
          ..where((a) => a.tripId.equals(tripId)))
        .watch()
        .map((actions) => actions.map(_actionFromData).toList());
  }

  Future<int> createAction(ActionModel action) {
    return _database.into(_database.actions).insert(ActionsCompanion(
          tripId: Value(action.tripId),
          title: Value(action.title),
          description: Value(action.description),
          isGroupBudget: Value(action.isGroupBudget),
          payerId: Value(action.payerId),
          amount: Value(action.amount),
          splitType: Value(action.splitType),
          createdAt: Value(action.createdAt),
          updatedAt: Value(action.updatedAt),
        ));
  }

  Future<bool> updateAction(ActionModel action) {
    return _database.update(_database.actions).replace(ActionsCompanion(
          id: Value(action.id!),
          tripId: Value(action.tripId),
          title: Value(action.title),
          description: Value(action.description),
          payerId: Value(action.payerId),
          amount: Value(action.amount),
          splitType: Value(action.splitType),
          createdAt: Value(action.createdAt),
          updatedAt: Value(action.updatedAt),
        ));
  }

  Future<int> deleteAction(int id) {
    return (_database.delete(_database.actions)..where((a) => a.id.equals(id)))
        .go();
  }

  // ActionShare operations
  Future<List<ActionShareModel>> getActionSharesByActionId(int actionId) async {
    final shares = await (_database.select(_database.actionShares)
          ..where((s) => s.actionId.equals(actionId)))
        .get();
    return shares.map(_actionShareFromData).toList();
  }

  Future<int> createActionShare(ActionShareModel share) {
    return _database.into(_database.actionShares).insert(ActionSharesCompanion(
          actionId: Value(share.actionId),
          memberId: Value(share.memberId),
          amountOwed: Value(share.amountOwed),
          createdAt: Value(share.createdAt),
        ));
  }

  Future<int> deleteActionSharesByActionId(int actionId) {
    return (_database.delete(_database.actionShares)
          ..where((s) => s.actionId.equals(actionId)))
        .go();
  }

  // Deposit operations
  Future<List<DepositModel>> getDepositsByTripId(int tripId) async {
    final deposits = await (_database.select(_database.deposits)
          ..where((d) => d.tripId.equals(tripId)))
        .get();
    return deposits.map(_depositFromData).toList();
  }

  Stream<List<DepositModel>> watchDepositsByTripId(int tripId) {
    return (_database.select(_database.deposits)
          ..where((d) => d.tripId.equals(tripId)))
        .watch()
        .map((deposits) => deposits.map(_depositFromData).toList());
  }

  Future<int> createDeposit(DepositModel deposit) {
    return _database.into(_database.deposits).insert(DepositsCompanion(
          tripId: Value(deposit.tripId),
          memberId: Value(deposit.memberId),
          amount: Value(deposit.amount),
          createdAt: Value(deposit.createdAt),
        ));
  }

  Future<bool> updateDeposit(DepositModel deposit) {
    return _database.update(_database.deposits).replace(DepositsCompanion(
          id: Value(deposit.id!),
          tripId: Value(deposit.tripId),
          memberId: Value(deposit.memberId),
          amount: Value(deposit.amount),
          createdAt: Value(deposit.createdAt),
        ));
  }

  Future<int> deleteDeposit(int id) {
    return (_database.delete(_database.deposits)..where((d) => d.id.equals(id)))
        .go();
  }

  // TravelNote operations
  Future<List<TravelNoteModel>> getTravelNotesByTripId(int tripId) async {
    final notes = await (_database.select(_database.travelNotes)
          ..where((n) => n.tripId.equals(tripId)))
        .get();
    return notes.map(_travelNoteFromData).toList();
  }

  Stream<List<TravelNoteModel>> watchTravelNotesByTripId(int tripId) {
    return (_database.select(_database.travelNotes)
          ..where((n) => n.tripId.equals(tripId)))
        .watch()
        .map((notes) => notes.map(_travelNoteFromData).toList());
  }

  Future<int> createTravelNote(TravelNoteModel note) {
    return _database.into(_database.travelNotes).insert(TravelNotesCompanion(
          tripId: Value(note.tripId),
          title: Value(note.title),
          content: Value(note.content),
          ownerId: Value(note.ownerId),
          createdAt: Value(note.createdAt),
          updatedAt: Value(note.updatedAt),
        ));
  }

  Future<bool> updateTravelNote(TravelNoteModel note) {
    return _database.update(_database.travelNotes).replace(TravelNotesCompanion(
          id: Value(note.id!),
          tripId: Value(note.tripId),
          title: Value(note.title),
          content: Value(note.content),
          ownerId: Value(note.ownerId),
          createdAt: Value(note.createdAt),
          updatedAt: Value(note.updatedAt),
        ));
  }

  Future<int> deleteTravelNote(int id) {
    return (_database.delete(_database.travelNotes)
          ..where((n) => n.id.equals(id)))
        .go();
  }

  // Transaction operations
  Future<void> createActionWithShares(
      ActionModel action, List<ActionShareModel> shares) async {
    await _database.transaction(() async {
      final actionId = await createAction(action);
      for (final share in shares) {
        await createActionShare(share.copyWith(actionId: actionId));
      }
    });
  }

  Future<void> updateActionWithShares(
      ActionModel action, List<ActionShareModel> shares) async {
    await _database.transaction(() async {
      await updateAction(action);
      await deleteActionSharesByActionId(action.id!);
      for (final share in shares) {
        await createActionShare(share.copyWith(actionId: action.id));
      }
    });
  }

  // Helper methods
  TripModel _tripFromData(Trip data) {
    return TripModel(
      id: data.id,
      title: data.title,
      description: data.description,
      startDate: data.startDate,
      endDate: data.endDate,
      createdAt: data.createdAt,
      updatedAt: data.updatedAt,
    );
  }

  MemberModel _memberFromData(Member data) {
    return MemberModel(
      id: data.id,
      tripId: data.tripId,
      name: data.name,
      email: data.email,
      createdAt: data.createdAt,
    );
  }

  ActionModel _actionFromData(Action data) {
    return ActionModel(
      id: data.id,
      tripId: data.tripId,
      title: data.title,
      description: data.description,
      isGroupBudget: data.isGroupBudget,
      payerId: data.payerId,
      amount: data.amount,
      splitType: data.splitType,
      createdAt: data.createdAt,
      updatedAt: data.updatedAt,
    );
  }

  ActionShareModel _actionShareFromData(ActionShare data) {
    return ActionShareModel(
      id: data.id,
      actionId: data.actionId,
      memberId: data.memberId,
      amountOwed: data.amountOwed,
      createdAt: data.createdAt,
    );
  }

  DepositModel _depositFromData(Deposit data) {
    return DepositModel(
      id: data.id,
      tripId: data.tripId,
      memberId: data.memberId,
      amount: data.amount,
      createdAt: data.createdAt,
    );
  }

  TravelNoteModel _travelNoteFromData(TravelNote data) {
    return TravelNoteModel(
      id: data.id,
      tripId: data.tripId,
      title: data.title,
      content: data.content,
      ownerId: data.ownerId,
      createdAt: data.createdAt,
      updatedAt: data.updatedAt,
    );
  }
}
