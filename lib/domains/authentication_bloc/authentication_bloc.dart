import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:intheloopapp/data/auth_repository.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/models/user_model.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({
    required AuthRepository authRepository,
    required DatabaseRepository databaseRepository,
  })  : _authRepository = authRepository,
        _databaseRepository = databaseRepository,
        super(Uninitialized()) {
    _userSubscription = authRepository.user.listen(_onUserChanged);
  }

  final AuthRepository _authRepository;
  final DatabaseRepository _databaseRepository;
  late final StreamSubscription<UserModel> _userSubscription;

  void _onUserChanged(UserModel user) {
    if (user.isNotEmpty && !(state is Authenticated)) {
      add(LoggedIn(user: user));
    }
  }

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AppStarted) {
      yield* _mapAppStartedToState();
    } else if (event is LoggedIn) {
      yield* _mapLoggedInToState();
    } else if (event is LoggedOut) {
      yield* _mapLoggedOutToState();
    } else if (event is UpdateAuthenticatedUser) {
      yield* _mapUpdateAuthenticatedUserToState(event.user);
    }
  }

  Stream<AuthenticationState> _mapAppStartedToState() async* {
    try {
      final isSignedIn = await _authRepository.isSignedIn();
      if (isSignedIn) {
        final uid = await _authRepository.getAuthUserId();
        final user = await _databaseRepository.getUser(uid);
        yield Authenticated(user);
      } else {
        yield Unauthenticated();
      }
    } catch (_) {
      yield Unauthenticated();
    }
  }

  Stream<AuthenticationState> _mapLoggedInToState() async* {
    final uid = await _authRepository.getAuthUserId();
    yield Authenticated(await _databaseRepository.getUser(uid));
  }

  Stream<AuthenticationState> _mapLoggedOutToState() async* {
    yield Unauthenticated();
    _authRepository.logout();
  }

  Stream<AuthenticationState> _mapUpdateAuthenticatedUserToState(
      UserModel user) async* {
    await _authRepository.updateUserData(userData: user);
    yield Authenticated(user);
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
