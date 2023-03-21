import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/ui/views/audio_feeds/audio_feed/audio_feed_view.dart';
import 'package:intheloopapp/ui/views/audio_feeds/audio_feeds_list/audio_feeds_list_cubit.dart';
import 'package:intheloopapp/ui/widgets/feeds_list_view/control_buttons.dart';

class AudioFeedsListView extends StatelessWidget {
  const AudioFeedsListView({super.key});

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
      create: (context) => AudioFeedsListCubit(),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Stack(
          children: [
            BlocBuilder<AudioFeedsListCubit, AudioFeedsListState>(
              builder: (context, state) {
                return PageView(
                  controller: state.pageController,
                  onPageChanged: (index) =>
                      context.read<AudioFeedsListCubit>().feedChanged(index),
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
