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
  final UserModel? user;

  LoggedIn({this.user});

  @override
  String toString() => 'LoggedIn { user: ${user?.email ?? ''} }';

  @override
  List<Object?> get props => [user];
}

class UpdateAuthenticatedUser extends AuthenticationEvent {
  final UserModel user;

  UpdateAuthenticatedUser(this.user);

  @override
  String toString() => 'UpdateAuthenticatedUser { user: ${user.email} }';

  @override
  List<Object> get props => [user];
}

class LoggedOut extends AuthenticationEvent {
  @override
  String toString() => 'LoggedOut';

  @override
  List<Object> get props => [];
}
