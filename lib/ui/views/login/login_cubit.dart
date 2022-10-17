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
      state.copyWith(status: FormzStatus.submissionInProgress),
    );
    try {
      await authRepository.signInWithApple();
      emit(
        state.copyWith(status: FormzStatus.submissionSuccess),
      );
    } on Exception {
      // print(e);
      emit(
        state.copyWith(status: FormzStatus.submissionFailure),
      );
    // ignore: avoid_catching_errors
    } on NoSuchMethodError {
      emit(
        state.copyWith(status: FormzStatus.pure),
      );
    }
  }

  Future<void> signInWithGoogle() async {
    emit(
      state.copyWith(status: FormzStatus.submissionInProgress),
    );
    try {
      await authRepository.signInWithGoogle();
      emit(
        state.copyWith(status: FormzStatus.submissionSuccess),
      );
    } on Exception {
      // print(e);
      emit(
        state.copyWith(status: FormzStatus.submissionFailure),
      );
    // ignore: avoid_catching_errors
    } on NoSuchMethodError {
      emit(
        state.copyWith(status: FormzStatus.pure),
      );
    }
  }
}
