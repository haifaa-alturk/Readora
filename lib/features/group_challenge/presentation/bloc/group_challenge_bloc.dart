import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/group_challenge_entity.dart';
import '../../domain/repositories/group_challenge_repository_interface.dart';
import 'group_challenge_event.dart';
import 'group_challenge_state.dart';

class GroupChallengeBloc
    extends Bloc<GroupChallengeEvent, GroupChallengeState> {
  final GroupChallengeRepositoryInterface repository;

  GroupChallengeBloc({required this.repository})
      : super(const GroupChallengeInitial()) {
    on<LoadGroupChallengeEvent>(_onLoadGroupChallenge);
    on<RefreshGroupChallengeEvent>(_onRefreshGroupChallenge);
    on<JoinChallengeEvent>(_onJoinChallenge);
    on<RecordBookCompletionEvent>(_onRecordBookCompletion);
  }

  Future<void> _load(Emitter<GroupChallengeState> emit) async {
    emit(const GroupChallengeLoading());

    final result = await repository.getActiveChallenge();
    result.fold(
      (error) => emit(GroupChallengeError(message: error)),
      (challenge) {
        final active = challenge;
        if (active == null) {
          emit(const GroupChallengeEmpty());
          return;
        }
        _handleActiveResult(active, emit);
      },
    );
  }

  Future<void> _handleActiveResult(
    GroupChallengeEntity challenge,
    Emitter<GroupChallengeState> emit,
  ) async {
    if (challenge.status == 'active') {
      emit(GroupChallengeActive(challenge: challenge));
    } else if (challenge.status == 'ended') {
      final winnersResult =
          await repository.getWinners(challengeId: challenge.id);
      winnersResult.fold(
        (error) => emit(GroupChallengeError(message: error)),
        (winners) => emit(GroupChallengeWinnersAvailable(
          winners: winners,
          endedChallenge: challenge,
        )),
      );
    }
  }

  Future<void> _onLoadGroupChallenge(
    LoadGroupChallengeEvent event,
    Emitter<GroupChallengeState> emit,
  ) async {
    await _load(emit);
  }

  Future<void> _onRefreshGroupChallenge(
    RefreshGroupChallengeEvent event,
    Emitter<GroupChallengeState> emit,
  ) async {
    await _load(emit);
  }

  Future<void> _onJoinChallenge(
    JoinChallengeEvent event,
    Emitter<GroupChallengeState> emit,
  ) async {
    final result =
        await repository.joinChallenge(challengeId: event.challengeId);
    result.fold(
      (error) => emit(GroupChallengeError(message: error)),
      (challenge) => emit(GroupChallengeActive(challenge: challenge)),
    );
  }

  Future<void> _onRecordBookCompletion(RecordBookCompletionEvent event, Emitter<GroupChallengeState> emit) async {
    final current = state;
    if (current is! GroupChallengeActive || !current.challenge.isJoined) {
      return;
    }
    final result = await repository.incrementBookProgress(challengeId: current.challenge.id);
    result.fold(
      (error) => emit(GroupChallengeError(message: error)),
      (updatedChallenge) => emit(GroupChallengeActive(challenge: updatedChallenge)),
    );
  }
}
