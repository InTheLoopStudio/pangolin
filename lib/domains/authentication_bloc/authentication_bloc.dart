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

    on<AppStarted>((event, emit) async {
      try {
        final isSignedIn = await _authRepository.isSignedIn();
        if (isSignedIn) {
          final uid = await _authRepository.getAuthUserId();
          final user = await _databaseRepository.getUser(uid);
          emit(Authenticated(user));
        } else {
          emit(Unauthenticated());
        }
      } catch (_) {
        emit(Unauthenticated());
      }
    });
    on<LoggedIn>((event, emit) async {
      final uid = await _authRepository.getAuthUserId();
      emit(Authenticated(await _databaseRepository.getUser(uid)));
    });
    on<LoggedOut>((event, emit) {
      emit(Unauthenticated());
      _authRepository.logout();
    });
    on<UpdateAuthenticatedUser>((event, emit) async {
      final user = event.user;
      await _authRepository.updateUserData(userData: user);
      emit(Authenticated(user));
    });
  }

  final AuthRepository _authRepository;
  final DatabaseRepository _databaseRepository;
  late final StreamSubscription<UserModel> _userSubscription;

  void _onUserChanged(UserModel user) {
    if (user.isNotEmpty && state is! Authenticated) {
      add(LoggedIn(user: user));
    }
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
