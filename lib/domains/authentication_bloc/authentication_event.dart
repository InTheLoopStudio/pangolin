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
  final User? user;

  @override
  String toString() => 'LoggedIn { user: ${user ?? ''} }';

  @override
  List<Object?> get props => [user];
}

class LoggedOut extends AuthenticationEvent {
  @override
  String toString() => 'LoggedOut';

  @override
  List<Object> get props => [];
}
