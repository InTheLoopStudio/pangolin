import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/ui/views/home/audio_feed/audio_feed_view.dart';
import 'package:intheloopapp/ui/views/home/feeds_list/feeds_list_cubit.dart';
import 'package:intheloopapp/ui/widgets/feeds_list_view/control_buttons.dart';

class FeedsListView extends StatelessWidget {
  const FeedsListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final databaseRepository =
        RepositoryProvider.of<DatabaseRepository>(context);

    // TODO(loading): Initialize feeds in initial loading screen
    final followingFeed = AudioFeedView(
      feedId: 'Following',
      sourceFunction: databaseRepository.getFollowingLoops,
      sourceStream: databaseRepository.followingLoopsObserver,
    );
    final forYourFeed = AudioFeedView(
      feedId: 'For-You',
      sourceFunction: databaseRepository.getAllLoops,
      sourceStream: databaseRepository.allLoopsObserver,
    );

    return BlocProvider(
      create: (context) => FeedsListCubit(),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Stack(
          children: [
            BlocBuilder<FeedsListCubit, FeedsListState>(
              builder: (context, state) {
                return PageView(
                  controller: state.pageController,
                  onPageChanged: (index) =>
                      context.read<FeedsListCubit>().feedChanged(index),
                  children: [
                    followingFeed,
                    forYourFeed,
                  ],
                );
              },
            ),
            const ControlButtons(),
          ],
        ),
      ),
    );
  }
}
