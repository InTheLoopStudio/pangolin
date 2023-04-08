import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/ui/views/loop_feed/loop_feed_view.dart';
import 'package:intheloopapp/ui/widgets/profile_view/notification_icon_button.dart';

class LoopFeedsListView extends StatelessWidget {
  const LoopFeedsListView({super.key});

  @override
  Widget build(BuildContext context) {
    final databaseRepository =
        RepositoryProvider.of<DatabaseRepository>(context);

    final followingFeed = LoopFeedView(
      sourceFunction: databaseRepository.getFollowingLoops,
      sourceStream: databaseRepository.followingLoopsObserver,
      feedKey: 'following-feed',
    );
    final forYourFeed = LoopFeedView(
      sourceFunction: databaseRepository.getAllLoops,
      sourceStream: databaseRepository.allLoopsObserver,
      feedKey: 'for-you-feed',
    );

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.edit_outlined),
        onPressed: () => context.read<NavigationBloc>().add(
              const PushCreateLoop(),
            ),
      ),
      body: DefaultTabController(
        length: 2,
        initialIndex: 1,
        child: NestedScrollView(
          physics: const ClampingScrollPhysics(),
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              const SliverAppBar(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
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
                pinned: true,
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
                  pinned: true,
                  delegate: _SliverAppBarDelegate(
                    const TabBar(
                      tabs: [
                        Tab(text: 'Following'),
                        Tab(text: 'For You'),
                      ],
                    ),
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              followingFeed,
              forYourFeed,
            ],
          ),
        ),
      ),
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
