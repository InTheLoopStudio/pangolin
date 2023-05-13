import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/activity_bloc/activity_bloc.dart';
import 'package:intheloopapp/domains/models/activity.dart';
import 'package:intheloopapp/ui/views/common/easter_egg_placeholder.dart';
import 'package:intheloopapp/ui/views/common/loading/list_loading_view.dart';
import 'package:intheloopapp/ui/widgets/activity_view/activity_tile.dart';
import 'package:skeletons/skeletons.dart';

class ActivityList extends StatefulWidget {
  const ActivityList({super.key});

  @override
  State<ActivityList> createState() => _ActivityListState();
}

class _ActivityListState extends State<ActivityList> {
  final ScrollController _scrollController = ScrollController();
  late ActivityBloc _activityBloc;

  Timer? _debounce;

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;

    return currentScroll >= (maxScroll * 0.9);
  }

  void _onScroll() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 200), () {
      if (_isBottom) _activityBloc.add(FetchActivitiesEvent());
    });
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _activityBloc = context.read<ActivityBloc>();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  Widget _activityListBuilder(BuildContext context, List<Activity> activities) {
    context.read<ActivityBloc>().add(const MarkAllAsReadEvent());
    return CustomScrollView(
      physics: const ClampingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      controller: _scrollController,
      slivers: activities.isEmpty
          ? <Widget>[
              SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: 150),
                  const EasterEggPlaceholder(
                    text: 'No New Activities',
                  ),
                ]),
              ),
            ]
          : <Widget>[
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return index >= activities.length
                        ? const Center(
                            child: SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 1.5,
                              ),
                            ),
                          )
                        : ActivityTile(
                            activity: activities[index],
                          );
                  },
                  childCount: activities.length + 1,
                ),
              ),
            ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActivityBloc, ActivityState>(
      builder: (context, state) {
        return RefreshIndicator(
          onRefresh: () async =>
          context.read<ActivityBloc>().add(InitListenerEvent()),
          child: switch (state) {
            ActivityInitial() => SkeletonListView(),
            ActivityFailure() =>
              const Center(child: Text('failed to fetch activities')),
            ActivitySuccess(:final activities) ||
            ActivityEnd(:final activities) =>
              _activityListBuilder(context, activities),
          },
        );
      },
    );
  }
}
