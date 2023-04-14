import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    _userSubscription = authRepository.user.listen(_onUserChanged);

    on<AppStarted>((event, emit) async {
      try {
        final isSignedIn = await _authRepository.isSignedIn();
        if (isSignedIn) {
          final user = await _authRepository.getAuthUser();
          emit(Authenticated(user!));
        } else {
          emit(Unauthenticated());
        }
      } catch (_) {
        emit(Unauthenticated());
      }
    });
    on<LoggedIn>((event, emit) async {
      final user = await _authRepository.getAuthUser();
      emit(Authenticated(user!));
    });
    on<LoggedOut>((event, emit) {
      emit(Unauthenticated());
      _authRepository.logout();
    });
  }

  final AuthRepository _authRepository;
  late final StreamSubscription<User?> _userSubscription;

  void _onUserChanged(User? user) {
    if (user != null && state is! Authenticated) {
      add(LoggedIn(user: user));
    }
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
