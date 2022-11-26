import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:intheloopapp/data/auth_repository.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({
    required AuthRepository authRepository,
  })  : _authRepository = authRepository,
        super(Uninitialized()) {
    _userSubscription = authRepository.userId.listen(_onUserChanged);

    on<AppStarted>((event, emit) async {
      try {
        final isSignedIn = await _authRepository.isSignedIn();
        if (isSignedIn) {
          final uid = await _authRepository.getAuthUserId();
          emit(Authenticated(uid));
        } else {
          emit(Unauthenticated());
        }
      } catch (_) {
        emit(Unauthenticated());
      }
    });
    on<LoggedIn>((event, emit) async {
      final uid = await _authRepository.getAuthUserId();
      emit(Authenticated(uid));
    });
    on<LoggedOut>((event, emit) {
      emit(Unauthenticated());
      _authRepository.logout();
    });
  }

  final AuthRepository _authRepository;
  late final StreamSubscription<String> _userSubscription;

  void _onUserChanged(String userId) {
    if (userId.isNotEmpty && state is! Authenticated) {
      add(LoggedIn(userId: userId));
    }
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
