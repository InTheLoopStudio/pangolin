import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intheloopapp/data/auth_repository.dart';

part 'confirm_email_event.dart';
part 'confirm_email_state.dart';

class ConfirmEmailBloc extends Bloc<ConfirmEmailEvent, ConfirmEmailState> {
  ConfirmEmailBloc({required this.authRepository})
      : super(EmailNotConfirmed()) {
    on<ConfirmEmail>((event, emit) async {
      try {
        final isSignedIn = await authRepository.isSignedIn();
        if (!isSignedIn) {
          emit(EmailNotConfirmed());
        }

        final user = await authRepository.getAuthUser();
        final emailConfirmed = user?.emailVerified ?? false;

        if (!emailConfirmed) {
          emit(EmailNotConfirmed());
        }

        emit(EmailConfirmed());
      } catch (_) {
        emit(EmailNotConfirmed());
      }
    });
  }

  final AuthRepository authRepository;
}
