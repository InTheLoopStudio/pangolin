part of 'login_cubit.dart';

class LoginState extends Equatable {
  const LoginState({
    this.status = FormzSubmissionStatus.initial,
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
  });

  final FormzSubmissionStatus status;
  final String email;
  final String password;
  final String confirmPassword;

  @override
  List<Object> get props => [
        status,
        email,
        password,
        confirmPassword,
      ];

  LoginState copyWith({
    FormzSubmissionStatus? status,
    String? email,
    String? password,
    String? confirmPassword,
  }) {
    return LoginState(
      status: status ?? this.status,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
    );
  }
}
