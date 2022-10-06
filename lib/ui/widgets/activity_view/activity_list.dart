import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/activity_bloc/activity_bloc.dart';
import 'package:intheloopapp/ui/views/common/easter_egg_placeholder.dart';
import 'package:intheloopapp/ui/views/common/loading/list_loading_view.dart';
import 'package:intheloopapp/ui/widgets/activity_view/activity_tile.dart';

class ActivityList extends StatefulWidget {
  const ActivityList({Key? key}) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActivityBloc, ActivityState>(
      builder: (context, state) {
        if (state is ActivityInitial) {
          return const ListLoadingView();
        }
        if (state is ActivityFailure) {
          return const Center(child: Text('failed to fetch activities'));
        }
        if (state is ActivitySuccess || state is ActivityEnd) {
          return Center(
            child: RefreshIndicator(
              onRefresh: () async =>
                  context.read<ActivityBloc>().add(InitListenerEvent()),
              child: CustomScrollView(
                physics: const ClampingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                controller: _scrollController,
                slivers: state.activities.isEmpty
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
                              return index >= state.activities.length
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
                                      activity: state.activities[index],);
                            },
                            childCount: state is ActivityEnd
                                ? state.activities.length
                                : state.activities.length + 1,
                          ),
                        ),
                      ],
              ),
            ),
          );
        }
        return const ListLoadingView();
      },
    );
  }
}
