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
  const LoggedIn({this.user});
  final UserModel? user;

  @override
  String toString() => 'LoggedIn { user: ${user?.email ?? ''} }';

  @override
  List<Object?> get props => [user];
}

class UpdateAuthenticatedUser extends AuthenticationEvent {
  const UpdateAuthenticatedUser(this.user);
  final UserModel user;

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
