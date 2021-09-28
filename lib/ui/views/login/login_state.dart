part of 'login_cubit.dart';

class LoginState extends Equatable {
  const LoginState({
    this.status = FormzStatus.pure,
  });

  final FormzStatus status;

  @override
  List<Object> get props => [status];

  LoginState copyWith({
    FormzStatus? status,
  }) {
    return LoginState(
      status: status ?? this.status,
    );
  }
}
