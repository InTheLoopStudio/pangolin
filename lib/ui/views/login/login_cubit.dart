import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:intheloopapp/data/auth_repository.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this.authRepository) : super(const LoginState());
  final AuthRepository authRepository;

  Future<void> signInWithApple() async {
    emit(
      state.copyWith(status: FormzSubmissionStatus.inProgress),
    );
    try {
      await authRepository.signInWithApple();
      emit(
        state.copyWith(status: FormzSubmissionStatus.success),
      );
    } on Exception {
      // print(e);
      emit(
        state.copyWith(status: FormzSubmissionStatus.failure),
      );
      // ignore: avoid_catching_errors
    } on NoSuchMethodError {
      emit(
        state.copyWith(status: FormzSubmissionStatus.initial),
      );
    }
  }

  Future<void> signInWithGoogle() async {
    emit(
      state.copyWith(status: FormzSubmissionStatus.inProgress),
    );
    try {
      await authRepository.signInWithGoogle();
      emit(
        state.copyWith(status: FormzSubmissionStatus.success),
      );
    } on Exception {
      // print(e);
      emit(
        state.copyWith(status: FormzSubmissionStatus.failure),
      );
      // ignore: avoid_catching_errors
    } on NoSuchMethodError {
      emit(
        state.copyWith(status: FormzSubmissionStatus.initial),
      );
    }
  }
}
