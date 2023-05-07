import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:intheloopapp/data/auth_repository.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({
    required this.authRepository,
    required this.navigationBloc,
  }) : super(const LoginState());
  final AuthRepository authRepository;
  final NavigationBloc navigationBloc;

  void resetStatus() => emit(
        state.copyWith(
          status: FormzSubmissionStatus.initial,
        ),
      );

  void updateEmail(String? input) => emit(
        state.copyWith(
          email: input,
        ),
      );
  void updatePassword(String? input) => emit(
        state.copyWith(
          password: input,
        ),
      );
  void updateConfirmPassword(String input) => emit(
        state.copyWith(
          confirmPassword: input,
        ),
      );

  Future<void> signInWithCredentials() async {
    try {
      final uid = await authRepository.signInWithCredentials(
        state.email,
        state.password,
      );

      if (uid == null) {
        throw Exception('Failed to sign in');
      }
      emit(
        state.copyWith(status: FormzSubmissionStatus.success),
      );
    } catch (e) {
      // print(e);
      emit(
        state.copyWith(status: FormzSubmissionStatus.failure),
      );
      rethrow;
    }
  }

  Future<void> signUpWithCredentials() async {
    if (state.password != state.confirmPassword) {
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.failure,
        ),
      );
      throw Exception('Passwords do not match');
    }
    try {
      final uid = await authRepository.signUpWithCredentials(
        state.email,
        state.password,
      );

      if (uid == null) {
        emit(
          state.copyWith(status: FormzSubmissionStatus.failure),
        );
        throw Exception('Failed to create user');
      }
    } catch (e) {
      // print(e);
      emit(
        state.copyWith(status: FormzSubmissionStatus.failure),
      );
      rethrow;
    }
    emit(
      state.copyWith(status: FormzSubmissionStatus.success),
    );
    navigationBloc.add(const Pop());
  }

  Future<void> signInWithApple() async {
    emit(
      state.copyWith(status: FormzSubmissionStatus.inProgress),
    );
    try {
      await authRepository.signInWithApple();
      emit(
        state.copyWith(status: FormzSubmissionStatus.success),
      );
    } catch (e) {
      // print(e);
      emit(
        state.copyWith(status: FormzSubmissionStatus.failure),
      );
      rethrow;
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
    } catch (e) {
      emit(
        state.copyWith(status: FormzSubmissionStatus.failure),
      );
      rethrow;
    }
  }

  Future<void> sendResetPasswordLink() async {
    await authRepository.recoverPassword(email: state.email);
  }
}
