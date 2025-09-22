import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../core/util/balance_calculator.dart';
import '../../data/repositories/travel_note_repository.dart';
import '../../models/travel_note/action_model.dart';
import '../../models/travel_note/action_share.dart';
import 'travel_note_event.dart';
import 'travel_note_state.dart';

class TravelNoteBloc extends Bloc<TravelNoteEvent, TravelNoteState> {
  final TravelNoteRepository _repository;
  StreamSubscription? _tripsSubscription;
  StreamSubscription? _membersSubscription;
  StreamSubscription? _actionsSubscription;
  StreamSubscription? _depositsSubscription;
  StreamSubscription? _travelNotesSubscription;

  TravelNoteBloc(this._repository) : super(TravelNoteState()) {
    on<LoadTrips>(_onLoadTrips);
    on<CreateTrip>(_onCreateTrip);
    on<UpdateTrip>(_onUpdateTrip);
    on<DeleteTrip>(_onDeleteTrip);
    on<SelectTrip>(_onSelectTrip);

    on<LoadMembers>(_onLoadMembers);
    on<CreateMember>(_onCreateMember);
    on<UpdateMember>(_onUpdateMember);
    on<DeleteMember>(_onDeleteMember);

    on<LoadActions>(_onLoadActions);
    on<AddAction>(_onAddAction);
    on<RemoveAction>(_onRemoveAction);
    on<UpdateAction>(_onUpdateAction);

    on<LoadDeposits>(_onLoadDeposits);
    on<AddDeposit>(_onAddDeposit);
    on<UpdateDeposit>(_onUpdateDeposit);
    on<DeleteDeposit>(_onDeleteDeposit);

    on<LoadTravelNotes>(_onLoadTravelNotes);
    on<CreateTravelNote>(_onCreateTravelNote);
    on<UpdateTravelNote>(_onUpdateTravelNote);
    on<DeleteTravelNote>(_onDeleteTravelNote);

    on<LoadSummary>(_onLoadSummary);

    on<UpdateStateTrips>(_onUpdateStateTrips);
    on<UpdateStateMember>(_onUpdateStateMember);
    on<UpdateStateAction>(_onUpdateStateActions);
    on<UpdateStateDeposits>(_onUpdateStateDeposits);
    on<UpdateStateTravelNotes>(_onUpdateStateTravelNotes);
  }

  @override
  Future<void> close() async {
    await _tripsSubscription?.cancel();
    await _membersSubscription?.cancel();
    await _actionsSubscription?.cancel();
    await _depositsSubscription?.cancel();
    await _travelNotesSubscription?.cancel();
    return super.close();
  }

  Future<void> _onLoadTrips(
      LoadTrips event, Emitter<TravelNoteState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      await _tripsSubscription?.cancel();
      _tripsSubscription = _repository.watchAllTrips().listen(
        (trips) {
          add(UpdateStateTrips(
            trips: trips,
          ));
        },
        onError: (error) {},
      );
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  void _onUpdateStateTrips(
      UpdateStateTrips event, Emitter<TravelNoteState> emit) async {
    emit(state.copyWith(trips: event.trips));
  }

  void _onUpdateStateMember(
      UpdateStateMember event, Emitter<TravelNoteState> emit) async {
    emit(state.copyWith(members: event.members));
  }

  void _onUpdateStateActions(
      UpdateStateAction event, Emitter<TravelNoteState> emit) async {
    emit(state.copyWith(actions: event.actions));
  }

  void _onUpdateStateDeposits(
      UpdateStateDeposits event, Emitter<TravelNoteState> emit) async {
    emit(state.copyWith(deposits: event.deposits));
  }

  void _onUpdateStateTravelNotes(
      UpdateStateTravelNotes event, Emitter<TravelNoteState> emit) async {
    emit(state.copyWith(travelNotes: event.travelNotes));
  }

  Future<void> _onCreateTrip(
      CreateTrip event, Emitter<TravelNoteState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      await _repository.createTrip(event.trip);
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _onUpdateTrip(
      UpdateTrip event, Emitter<TravelNoteState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      await _repository.updateTrip(event.trip);
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _onDeleteTrip(
      DeleteTrip event, Emitter<TravelNoteState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      await _repository.deleteTrip(event.tripId);
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    } finally {
      emit(state.copyWith(isLoading: true));
    }
  }

  Future<void> _onSelectTrip(
      SelectTrip event, Emitter<TravelNoteState> emit) async {
    try {
      final trip = await _repository.getTripById(event.tripId);
      emit(state.copyWith(selectedTrip: trip));
      // Load related data
      add(LoadMembers(event.tripId));
      add(LoadActions(event.tripId));
      add(LoadDeposits(event.tripId));
      add(LoadTravelNotes(event.tripId));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onLoadMembers(
      LoadMembers event, Emitter<TravelNoteState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      await _membersSubscription?.cancel();

      _membersSubscription =
          _repository.watchMembersByTripId(event.tripId).listen((members) {
        add(UpdateStateMember(members: members));
      });
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _onCreateMember(
      CreateMember event, Emitter<TravelNoteState> emit) async {
    try {
      emit(state.copyWith(isLoading: true));
      await _repository.createMember(event.member);
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _onUpdateMember(
      UpdateMember event, Emitter<TravelNoteState> emit) async {
    try {
      emit(state.copyWith(isLoading: true));
      await _repository.updateMember(event.member);
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _onDeleteMember(
      DeleteMember event, Emitter<TravelNoteState> emit) async {
    try {
      emit(state.copyWith(isLoading: true));
      await _repository.deleteMember(event.memberId);
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _onLoadActions(
      LoadActions event, Emitter<TravelNoteState> emit) async {
    try {
      emit(state.copyWith(isLoading: true));
      await _actionsSubscription?.cancel();

      _actionsSubscription =
          _repository.watchActionsByTripId(event.tripId).listen(
        (actions) {
          add(UpdateStateAction(actions: actions));
        },
      );
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _onAddAction(
      AddAction event, Emitter<TravelNoteState> emit) async {
    try {
      emit(state.copyWith(isLoading: true));

      final currentState = state;
      List<ActionShareModel> shares = [];

      if (event.action.splitType == SplitType.equal) {
        final shareAmount = event.action.amount / currentState.members.length;
        shares = currentState.members
            .map((member) => ActionShareModel(
                  actionId: 0, // Will be set in repository
                  memberId: member.id!,
                  amountOwed: shareAmount,
                  createdAt: DateTime.now(),
                ))
            .toList();
      } else if (event.customShares != null) {
        shares = event.customShares!.entries
            .map((entry) => ActionShareModel(
                  actionId: 0, // Will be set in repository
                  memberId: entry.key,
                  amountOwed: entry.value,
                  createdAt: DateTime.now(),
                ))
            .toList();
      }

      await _repository.createActionWithShares(event.action, shares);
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _onRemoveAction(
      RemoveAction event, Emitter<TravelNoteState> emit) async {
    try {
      emit(state.copyWith(isLoading: true));
      await _repository.deleteAction(event.actionId);
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _onUpdateAction(
      UpdateAction event, Emitter<TravelNoteState> emit) async {
    try {
      emit(state.copyWith(isLoading: true));

      final currentState = state;
      List<ActionShareModel> shares = [];

      if (event.action.splitType == SplitType.equal) {
        final shareAmount = event.action.amount / currentState.members.length;
        shares = currentState.members
            .map((member) => ActionShareModel(
                  actionId: event.action.id!,
                  memberId: member.id!,
                  amountOwed: shareAmount,
                  createdAt: DateTime.now(),
                ))
            .toList();
      } else if (event.customShares != null) {
        shares = event.customShares!.entries
            .map((entry) => ActionShareModel(
                  actionId: event.action.id!,
                  memberId: entry.key,
                  amountOwed: entry.value,
                  createdAt: DateTime.now(),
                ))
            .toList();
      }

      await _repository.updateActionWithShares(event.action, shares);
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _onLoadDeposits(
      LoadDeposits event, Emitter<TravelNoteState> emit) async {
    try {
      emit(state.copyWith(isLoading: true));
      await _depositsSubscription?.cancel();

      _depositsSubscription =
          _repository.watchDepositsByTripId(event.tripId).listen((deposits) {
        add(UpdateStateDeposits(deposits: deposits));
      });
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _onAddDeposit(
      AddDeposit event, Emitter<TravelNoteState> emit) async {
    try {
      emit(state.copyWith(isLoading: true));

      await _repository.createDeposit(event.deposit);
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _onUpdateDeposit(
      UpdateDeposit event, Emitter<TravelNoteState> emit) async {
    try {
      emit(state.copyWith(isLoading: true));

      await _repository.updateDeposit(event.deposit);
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _onDeleteDeposit(
      DeleteDeposit event, Emitter<TravelNoteState> emit) async {
    try {
      emit(state.copyWith(isLoading: true));

      await _repository.deleteDeposit(event.depositId);
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _onLoadTravelNotes(
      LoadTravelNotes event, Emitter<TravelNoteState> emit) async {
    try {
      emit(state.copyWith(isLoading: true));
      await _travelNotesSubscription?.cancel();

      _travelNotesSubscription =
          _repository.watchTravelNotesByTripId(event.tripId).listen(
        (notes) {
          add(UpdateStateTravelNotes(travelNotes: notes));
        },
      );
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _onCreateTravelNote(
      CreateTravelNote event, Emitter<TravelNoteState> emit) async {
    try {
      emit(state.copyWith(isLoading: true));

      await _repository.createTravelNote(event.note);
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _onUpdateTravelNote(
      UpdateTravelNote event, Emitter<TravelNoteState> emit) async {
    try {
      emit(state.copyWith(isLoading: true));

      await _repository.updateTravelNote(event.note);
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _onDeleteTravelNote(
      DeleteTravelNote event, Emitter<TravelNoteState> emit) async {
    try {
      emit(state.copyWith(isLoading: true));

      await _repository.deleteTravelNote(event.noteId);
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _onLoadSummary(
      LoadSummary event, Emitter<TravelNoteState> emit) async {
    try {
      emit(state.copyWith(isLoading: true));

      final currentState = state;
      final summary = await BalanceCalculator.calculateSummary(
        members: currentState.members,
        actions: currentState.actions,
        deposits: currentState.deposits,
        repository: _repository,
      );

      if (!emit.isDone) {
        emit(currentState.copyWith(summary: summary));
      }
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }
}
