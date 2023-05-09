import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/loop_feed_list_bloc/loop_feed_list_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/ui/views/loop_feed/loop_feed_view.dart';
import 'package:intheloopapp/ui/widgets/profile_view/notification_icon_button.dart';

class LoopFeedsListView extends StatefulWidget {
  const LoopFeedsListView({super.key});

  @override
  State<LoopFeedsListView> createState() => _LoopFeedsListViewState();
}

class _LoopFeedsListViewState extends State<LoopFeedsListView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    final feedBloc = context.read<LoopFeedListBloc>();
    _tabController = TabController(
      vsync: this,
      length: feedBloc.feedParamsList.length,
      initialIndex: feedBloc.initialIndex,
    );

    _tabController.addListener(_handleTabChange);
  }

  @override
  void dispose() {
    _tabController
      ..removeListener(_handleTabChange)
      ..dispose();
    super.dispose();
  }

  void _handleTabChange() {
    context.read<LoopFeedListBloc>().add(
          ChangeFeed(
            index: _tabController.index,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<LoopFeedListBloc, LoopFeedListState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          floatingActionButton: FloatingActionButton(
            heroTag: 'pushCreateLoopButton',
            child: const Icon(Icons.edit_outlined),
            onPressed: () => context.read<NavigationBloc>().add(
                  const PushCreateLoop(),
                ),
          ),
          body: NestedScrollView(
            // physics: const ClampingScrollPhysics(),
            floatHeaderSlivers: true,
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  floating: true,
                  forceElevated: innerBoxIsScrolled,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'Loops',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      NotificationIconButton(),
                    ],
                  ),
                ),
                SliverOverlapAbsorber(
                  // This widget takes the overlapping behavior of the
                  // SliverAppBar,
                  // and redirects it to the SliverOverlapInjector below
                  // If it is
                  // missing, then it is possible for the nested "inner"
                  // scroll view
                  // below to end up under the SliverAppBar even when
                  // the inner
                  // scroll view thinks it has not been scrolled.
                  // This is not necessary if the "headerSliverBuilder"
                  // only builds
                  // widgets that do not overlap the next sliver.
                  handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                    context,
                  ),
                  sliver: SliverPersistentHeader(
                    floating: true,
                    pinned: true,
                    delegate: _SliverAppBarDelegate(
                      TabBar(
                        controller: _tabController,
                        tabs: state.feedParamsList
                            .map((e) => Tab(text: e.tabTitle))
                            .toList(),
                      ),
                    ),
                  ),
                ),
              ];
            },
            body: TabBarView(
              controller: _tabController,
              children: state.feedParamsList
                  .map(
                    (feedParam) => LoopFeedView(
                      sourceFunction: feedParam.sourceFunction,
                      sourceStream: feedParam.sourceStream,
                      feedKey: feedParam.feedKey,
                      scrollController: feedParam.scrollController,
                    ),
                  )
                  .toList(),
            ),
          ),
        );
      },
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return ColoredBox(
      color: Theme.of(context).colorScheme.background,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
