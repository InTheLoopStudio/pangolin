import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/models/loop.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/domains/onboarding_bloc/onboarding_bloc.dart';
import 'package:intheloopapp/ui/views/common/tapped_app_bar.dart';
import 'package:intheloopapp/ui/views/error/error_view.dart';
import 'package:intheloopapp/ui/views/loop_feed/loop_feed_cubit.dart';
import 'package:intheloopapp/ui/views/loop_feed/loop_list.dart';

class LoopFeedView extends StatefulWidget {
  LoopFeedView({
    required this.sourceFunction,
    required this.sourceStream,
    required this.feedKey,
    required this.nested,
    required this.header,
    ScrollController? scrollController,
    super.key,
  }) {
    this.scrollController = scrollController ?? ScrollController();
  }

  final bool nested;
  final bool header;
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
          return const ErrorView();
        }

        return BlocProvider(
          create: (context) => LoopFeedCubit(
            currentUserId: currentUser.id,
            sourceFunction: widget.sourceFunction,
            sourceStream: widget.sourceStream,
          )..initLoops(),
          child: Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            appBar: widget.header
                ? const TappedAppBar(
                    title: 'Loops',
                  )
                : null,
            body: LoopList(
              nested: false,
              feedKey: widget.feedKey,
              scrollController: widget.scrollController,
            ),
          ),
        );
      },
    );
  }
}
