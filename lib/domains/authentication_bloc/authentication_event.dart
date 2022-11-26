part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();
}

class AppStarted extends AuthenticationEvent {
  @override
  String toString() => 'AppStarted';

  @override
  List<Object> get props => [];
}

class LoggedIn extends AuthenticationEvent {
  const LoggedIn({this.userId});
  final String? userId;

  @override
  String toString() => 'LoggedIn { user: ${userId ?? ''} }';

  @override
  List<Object?> get props => [userId];
}

class UpdateAuthenticatedUser extends AuthenticationEvent {
  const UpdateAuthenticatedUser(this.userId);
  final String userId;

  @override
  String toString() => 'UpdateAuthenticatedUser { user: $userId }';

  @override
  List<Object> get props => [userId];
}

class LoggedOut extends AuthenticationEvent {
  @override
  String toString() => 'LoggedOut';

  @override
  List<Object> get props => [];
}
