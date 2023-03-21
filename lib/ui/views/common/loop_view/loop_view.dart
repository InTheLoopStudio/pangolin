import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/controllers/audio_controller.dart';
import 'package:intheloopapp/domains/models/loop.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/domains/onboarding_bloc/onboarding_bloc.dart';
import 'package:intheloopapp/ui/views/common/loading/loop_loading_view.dart';
import 'package:intheloopapp/ui/views/common/loop_view/loop_view_cubit.dart';
import 'package:intheloopapp/ui/widgets/loop_view/loop_stack.dart';

class LoopView extends StatelessWidget {
  const LoopView({
    required this.loop,
    super.key,
    this.feedId = 'unknown',
    this.showComments = false,
    this.autoPlay = false,
    this.pageController,
  });

  final Loop loop;
  final String feedId;
  final bool showComments;
  final bool autoPlay;
  final PageController? pageController;

  @override
  Widget build(BuildContext context) {
    final databaseRepository =
        RepositoryProvider.of<DatabaseRepository>(context);
    return BlocSelector<OnboardingBloc, OnboardingState, Onboarded>(
      selector: (state) => state as Onboarded,
      builder: (context, userState) {
        final currentUser = userState.currentUser;

        return FutureBuilder<List<Object?>>(
          future: Future.wait([
            databaseRepository.getUserById(loop.userId),
            AudioController.fromUrl(loop.audioPath),
          ]),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const LoopLoadingView();
            }

            final user = snapshot.data![0] as UserModel?;
            final audioController = snapshot.data![1] as AudioController?;

            if (user == null || audioController == null) {
              return const LoopLoadingView();
            }

            return BlocProvider(
              create: (context) => LoopViewCubit(
                databaseRepository: databaseRepository,
                currentUser: currentUser,
                loop: loop,
                feedId: feedId,
                user: user,
                pageController: pageController,
                showComments: showComments,
                autoPlay: autoPlay,
                audioController: audioController,
              )
                ..initAudio()
                ..initIsFollowing()
                ..initLoopLikes()
                ..initLoopComments()
                ..checkIsVerified(),
              child: const LoopStack(),
            );
          },
        );
      },
    );
  }
}
