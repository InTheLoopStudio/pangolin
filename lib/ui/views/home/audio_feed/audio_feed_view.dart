import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/auth_repository.dart';
import 'package:intheloopapp/domains/models/loop.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/ui/views/common/easter_egg_placeholder.dart';
import 'package:intheloopapp/ui/views/common/loading/loop_loading_view.dart';
import 'package:intheloopapp/ui/views/common/loop_view/loop_view.dart';
import 'package:intheloopapp/ui/views/home/audio_feed/audio_feed_cubit.dart';

class AudioFeedView extends StatefulWidget {
  const AudioFeedView({
    Key? key,
    required this.feedId,
    required this.sourceFunction,
    required this.sourceStream,
  }) : super(key: key);
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
  _AudioFeedViewState createState() => _AudioFeedViewState();
}

class _AudioFeedViewState extends State<AudioFeedView>
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
    final authRepo = RepositoryProvider.of<AuthRepository>(context);
    return StreamBuilder<UserModel>(
      stream: authRepo.user,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const LoopLoadingView();

        final currentUser = snapshot.data!;
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
                      : Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: <Color>[
                                Color(0xff343434),
                                Color(0xff6200EE),
                              ],
                            ),
                          ),
                          child: const EasterEggPlaceholder(
                            text: 'No New Loops',
                            color: Colors.white,
                          ),
                        );
                case AudioFeedStatus.failure:
                  return Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: <Color>[
                          Color(0xff343434),
                          Color(0xff6200EE),
                        ],
                      ),
                    ),
                    child: const EasterEggPlaceholder(
                      text: 'Error Fetching Loops :(',
                      color: Colors.white,
                    ),
                  );
                default:
                  return const LoopLoadingView();
              }
            },
          ),
        );
      },
    );
  }
}
