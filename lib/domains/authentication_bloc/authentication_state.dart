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

  const Authenticated(this.currentUser) : super();
  final UserModel currentUser;

  @override
  String toString() => 'Authenticated { email: ${currentUser.email} }';

  @override
  List<Object> get props => [currentUser];
}

class Unauthenticated extends AuthenticationState {
  @override
  String toString() => 'Unauthenticated';

  @override
  List<Object> get props => [];
}
