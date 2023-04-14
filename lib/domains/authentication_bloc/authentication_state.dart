part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationState extends Equatable {
  const AuthenticationState();
}

class Uninitialized extends AuthenticationState {
  @override
  String toString() => 'Uninitialized';

  @override
  List<Object> get props => [];
}

class Authenticated extends AuthenticationState {
  const Authenticated(this.currentAuthUser) : super();
  final User currentAuthUser;

  @override
  String toString() => 'Authenticated { id: $currentAuthUser }';

  @override
  List<Object> get props => [currentAuthUser];
}

class Unauthenticated extends AuthenticationState {
  @override
  String toString() => 'Unauthenticated';

  @override
  List<Object> get props => [];
}
