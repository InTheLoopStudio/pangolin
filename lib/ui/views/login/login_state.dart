part of 'login_cubit.dart';

class LoginState extends Equatable {
  const LoginState({
    this.status = FormzSubmissionStatus.initial,
  });

  final FormzSubmissionStatus status;

  @override
  List<Object> get props => [status];

  LoginState copyWith({
    FormzSubmissionStatus? status,
  }) {
    return LoginState(
      status: status ?? this.status,
    );
  }
}
