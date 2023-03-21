import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/models/loop.dart';
import 'package:intheloopapp/domains/onboarding_bloc/onboarding_bloc.dart';
import 'package:intheloopapp/ui/views/audio_feeds/audio_feed/audio_feed_cubit.dart';
import 'package:intheloopapp/ui/views/common/easter_egg_placeholder.dart';
import 'package:intheloopapp/ui/views/common/loading/loop_loading_view.dart';
import 'package:intheloopapp/ui/views/common/loop_view/loop_view.dart';

class AudioFeedView extends StatefulWidget {
  const AudioFeedView({
    required this.feedId,
    required this.sourceFunction,
    required this.sourceStream,
    super.key,
  });
  final String feedId;
  final Future<List<Loop>> Function(
    String currentUserId, {
    int limit,
    String? lastLoopId,
  }) sourceFunction;
  final Stream<Loop> Function(
    String currentUserId, {
    int limit,
  }) sourceStream;

  @override
  AudioFeedViewState createState() => AudioFeedViewState();
}

class AudioFeedViewState extends State<AudioFeedView>
    with AutomaticKeepAliveClientMixin {
  final int refetchLimit = 5;
  final PageController _pageController = PageController();
  String get _feedId => widget.feedId;

  Future<List<Loop>> Function(
    String currentUserId, {
    int limit,
    String? lastLoopId,
  }) get _sourceFunction => widget.sourceFunction;

  Stream<Loop> Function(
    String currentUserId, {
    int limit,
  }) get _sourceStream => widget.sourceStream;

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocSelector<OnboardingBloc, OnboardingState, Onboarded>(
      selector: (state) => state as Onboarded,
      builder: (context, userState) {

        final currentUser = userState.currentUser;
        return BlocProvider(
          create: (context) => AudioFeedCubit(
            currentUserId: currentUser.id,
            sourceFunction: _sourceFunction,
            sourceStream: _sourceStream,
          )..initLoops(),
          child: BlocBuilder<AudioFeedCubit, AudioFeedState>(
            builder: (context, state) {
              switch (state.status) {
                case AudioFeedStatus.initial:
                  return const LoopLoadingView();
                case AudioFeedStatus.success:
                  return state.loops.isNotEmpty
                      ? PageView.builder(
                          scrollDirection: Axis.vertical,
                          controller: _pageController,
                          itemCount: state.loops.length,
                          onPageChanged: (index) {
                            // Fetch more loops when near the end
                            if (index >= state.loops.length - refetchLimit) {
                              context.read<AudioFeedCubit>().fetchMoreLoops();
                            }
                          },
                          itemBuilder: (context, index) {
                            index = index % (state.loops.length);
                            return LoopView(
                              loop: state.loops[index],
                              feedId: _feedId,
                              pageController: _pageController,
                            );
                          },
                        )
                      : const DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: <Color>[
                                Color(0xff343434),
                                Color(0xff6200EE),
                              ],
                            ),
                          ),
                          child: EasterEggPlaceholder(
                            text: 'No New Loops',
                            color: Colors.white,
                          ),
                        );
                case AudioFeedStatus.failure:
                  return const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: <Color>[
                          Color(0xff343434),
                          Color(0xff6200EE),
                        ],
                      ),
                    ),
                    child: EasterEggPlaceholder(
                      text: 'Error Fetching Loops :(',
                      color: Colors.white,
                    ),
                  );
              }
            },
          ),
        );
      },
    );
  }
}
