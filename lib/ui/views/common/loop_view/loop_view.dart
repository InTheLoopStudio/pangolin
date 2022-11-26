import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/models/loop.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/domains/onboarding_bloc/onboarding_bloc.dart';
import 'package:intheloopapp/ui/views/common/loading/loop_loading_view.dart';
import 'package:intheloopapp/ui/views/common/loop_view/loop_view_cubit.dart';
import 'package:intheloopapp/ui/widgets/loop_view/loop_stack.dart';

class LoopView extends StatelessWidget {
  const LoopView({
    Key? key,
    required this.loop,
    this.feedId = 'unknown',
    this.showComments = false,
    this.autoPlay = true,
    this.pageController,
  }) : super(key: key);

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

        return FutureBuilder<UserModel?>(
          future: databaseRepository.getUserById(loop.userId),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const LoopLoadingView();
            }

            final user = snapshot.data!;

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
              )
                ..initAudio()
                ..initIsFollowing()
                ..initLoopLikes()
                ..initLoopComments(),
              child: const LoopStack(),
            );
          },
        );
      },
    );
  }
}
