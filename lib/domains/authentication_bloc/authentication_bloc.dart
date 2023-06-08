import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:intheloopapp/app_logger.dart';
import 'package:intheloopapp/data/auth_repository.dart';
import 'package:intheloopapp/domains/models/option.dart';

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
          logger.setUserIdentifier(user!.uid);
          emit(Authenticated(user));
        } else {
          emit(Unauthenticated());
        }
      } catch (_) {
        emit(Unauthenticated());
      }
    });
    on<LoggedIn>((event, emit) async {
      try {
        return switch (event.user) {
          None() => emit(Unauthenticated()),
          Some(:final value) => emit(Authenticated(value)),
        };
      } catch (e, s) {
        logger.error(
          'error logging in',
          error: e,
          stackTrace: s,
        );
        emit(Unauthenticated());
      }
    });
    on<LoggedOut>((event, emit) {
      emit(Unauthenticated());
      _authRepository.logout();
    });
  }

  final AuthRepository _authRepository;
  late final StreamSubscription<User?> _userSubscription;

  void _onUserChanged(User? user) {
    print(user);

    if (user != null && state is! Authenticated) {
      add(LoggedIn(user: Option.fromNullable(user)));
    }
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
