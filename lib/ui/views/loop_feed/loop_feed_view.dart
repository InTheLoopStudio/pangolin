import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/models/loop.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/domains/onboarding_bloc/onboarding_bloc.dart';
import 'package:intheloopapp/ui/views/common/easter_egg_placeholder.dart';
import 'package:intheloopapp/ui/views/common/loading/list_loading_view.dart';
import 'package:intheloopapp/ui/views/loop_feed/loop_feed_cubit.dart';
import 'package:intheloopapp/ui/widgets/common/loop_container/loop_container.dart';

class LoopFeedView extends StatefulWidget {
  LoopFeedView({
    required this.sourceFunction,
    required this.sourceStream,
    required this.feedKey,
    ScrollController? scrollController,
    super.key,
  }) {
    this.scrollController = scrollController ?? ScrollController();
  }

  final Future<List<Loop>> Function(
    String currentUserId, {
    int limit,
    String? lastLoopId,
    bool ignoreCache,
  }) sourceFunction;
  final Stream<Loop> Function(
    String currentUserId, {
    int limit,
    bool ignoreCache,
  }) sourceStream;
  final String feedKey;

  late final ScrollController scrollController;

  @override
  State<LoopFeedView> createState() => _LoopFeedViewState();
}

class _LoopFeedViewState extends State<LoopFeedView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocSelector<OnboardingBloc, OnboardingState, UserModel?>(
      selector: (state) => (state is Onboarded) ? state.currentUser : null,
      builder: (context, currentUser) {
        if (currentUser == null) {
          return const Center(
            child: Text('An error has occured :/'),
          );
        }

        return BlocProvider(
          create: (context) => LoopFeedCubit(
            currentUserId: currentUser.id,
            sourceFunction: widget.sourceFunction,
            sourceStream: widget.sourceStream,
          )..initLoops(),
          child: Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            body: BlocBuilder<LoopFeedCubit, LoopFeedState>(
              builder: (context, state) {
                switch (state.status) {
                  case LoopFeedStatus.initial:
                    return const ListLoadingView();
                  case LoopFeedStatus.success:
                    if (state.loops.isEmpty) {
                      return const Center(
                        child: EasterEggPlaceholder(
                          text: 'No Loops',
                          color: Colors.white,
                        ),
                      );
                    }

                    return RefreshIndicator(
                      displacement: 20,
                      onRefresh: () async {
                        await context.read<LoopFeedCubit>().initLoops();
                      },
                      child: CustomScrollView(
                        controller: widget.scrollController,
                        physics: const ClampingScrollPhysics(),
                        key: PageStorageKey<String>(widget.feedKey),
                        slivers: [
                          SliverOverlapInjector(
                            // This is the flip side of the 
                            // SliverOverlapAbsorber
                            handle:
                                NestedScrollView.sliverOverlapAbsorberHandleFor(
                              context,
                            ),
                          ),
                          SliverPadding(
                            padding: const EdgeInsets.all(8),
                            sliver: SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                                  return LoopContainer(
                                    loop: state.loops[index],
                                  );
                                },
                                childCount: state.loops.length,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );

                  case LoopFeedStatus.failure:
                    return const Center(
                      child: EasterEggPlaceholder(
                        text: 'Error Fetching Loops :(',
                        color: Colors.white,
                      ),
                    );
                }
              },
            ),
          ),
        );
      },
    );
  }
}
