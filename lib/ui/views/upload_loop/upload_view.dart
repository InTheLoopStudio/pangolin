import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/auth_repository.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/data/storage_repository.dart';
import 'package:intheloopapp/domains/authentication_bloc/authentication_bloc.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/ui/views/common/loading/loading_view.dart';
import 'package:intheloopapp/ui/views/upload_loop/upload_loop_cubit.dart';
import 'package:intheloopapp/ui/views/upload_loop/upload_loop_form_view.dart';
import 'package:intheloopapp/ui/views/upload_loop/upload_loop_splash_view.dart';

class UploadView extends StatelessWidget {
  UploadView({Key? key}) : super(key: key);

  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    final authRepo = RepositoryProvider.of<AuthRepository>(context);
    final theme = Theme.of(context);
    return StreamBuilder<UserModel>(
      stream: authRepo.user,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const LoadingView();
        }

        final currentUser = snapshot.data!;

        return BlocProvider(
          create: (_) => UploadLoopCubit(
            databaseRepository: context.read<DatabaseRepository>(),
            authenticationBloc: context.read<AuthenticationBloc>(),
            currentUser: currentUser,
            navigationBloc: context.read<NavigationBloc>(),
            storageRepository: context.read<StorageRepository>(),
            scaffoldKey: _scaffoldKey,
          )..listenToAudioLockChange(),
          child: Scaffold(
            backgroundColor: theme.backgroundColor,
            body: ScaffoldMessenger(
              key: _scaffoldKey,
              child: BlocBuilder<UploadLoopCubit, UploadLoopState>(
                builder: (context, state) {
                  return state.pickedAudio == null
                      ? const UploadLoopSplashView()
                      : const UploadLoopFormView();
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
