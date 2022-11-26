import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/domains/onboarding_bloc/onboarding_bloc.dart';
import 'package:intheloopapp/ui/themes.dart';
import 'package:intheloopapp/ui/views/common/loading/loading_view.dart';
import 'package:intheloopapp/ui/views/profile/profile_cubit.dart';
import 'package:intheloopapp/ui/widgets/profile_view/all_loops_list.dart';
import 'package:intheloopapp/ui/widgets/profile_view/badges_list.dart';
import 'package:intheloopapp/ui/widgets/profile_view/follow_button.dart';
import 'package:intheloopapp/ui/widgets/profile_view/follower_count.dart';
import 'package:intheloopapp/ui/widgets/profile_view/following_count.dart';
import 'package:intheloopapp/ui/widgets/profile_view/share_profile_button.dart';
import 'package:intheloopapp/ui/widgets/profile_view/social_media_icons.dart';
import 'package:intheloopapp/ui/widgets/profile_view/venue_dashboard.dart';

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
      color: Colors.black,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key, required this.visitedUserId}) : super(key: key);

  final String visitedUserId;

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  String get visitedUserId => widget.visitedUserId;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  List<Widget> _profileTabBar(
    bool showVenueDashboard,
    int badgesCount,
    int loopsCount,
  ) {
    final tabs = [
      Tab(
        text: 'Badges ($badgesCount)',
      ),
      Tab(
        text: 'Loops ($loopsCount)',
      ),
    ];

    if (showVenueDashboard) {
      tabs.insert(
        0,
        const Tab(
          text: 'Venue',
        ),
      );
    }

    return tabs;
  }

  Widget _badgesTab() => SingleChildScrollView(
        controller: _scrollController,
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 15),
            BadgesList(scrollController: _scrollController),
          ],
        ),
      );

  Widget _loopsTab() => SingleChildScrollView(
        controller: _scrollController,
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            AllLoopsList(scrollController: _scrollController),
          ],
        ),
      );

  List<Widget> _profileTabs(bool showVenueDashboard) {
    final tabs = [
      _badgesTab(),
      _loopsTab(),
    ];

    if (showVenueDashboard) {
      tabs.insert(
        0,
        VenueDashboard(
          scrollController: _scrollController,
        ),
      );
    }

    return tabs;
  }

  Widget _profilePage(
    UserModel currentUser,
    UserModel visitedUser,
    DatabaseRepository databaseRepository,
  ) =>
      BlocProvider(
        create: (context) => ProfileCubit(
          databaseRepository: databaseRepository,
          currentUser: currentUser,
          visitedUser: visitedUser,
        )
          ..initLoops()
          ..initBadges()
          ..initUserCreatedBadges()
          ..loadFollower(visitedUser.id)
          ..loadFollowing(visitedUser.id)
          ..loadIsFollowing(currentUser.id, visitedUser.id),
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            final showVenueDashboard = currentUser.id == visitedUser.id &&
                currentUser.accountType == AccountType.venue;
            final tabs = _profileTabBar(
              showVenueDashboard,
              visitedUser.badgesCount,
              visitedUser.loopsCount,
            );
            return BlocListener<OnboardingBloc, OnboardingState>(
              listener: (context, userState) {
                if (userState is Onboarded) {
                  if (userState.currentUser.id == visitedUser.id) {
                    context
                        .read<ProfileCubit>()
                        .refetchVisitedUser(newUserData: userState.currentUser);
                  }
                }
              },
              child: RefreshIndicator(
                displacement: 20,
                onRefresh: () async {
                  context.read<ProfileCubit>()
                    // ignore: unawaited_futures
                    ..initLoops()
                    // ignore: unawaited_futures
                    ..initBadges()
                    // ignore: unawaited_futures
                    ..initUserCreatedBadges()
                    // ignore: unawaited_futures
                    ..refetchVisitedUser()
                    // ignore: unawaited_futures
                    ..loadIsFollowing(currentUser.id, visitedUser.id)
                    // ignore: unawaited_futures
                    ..loadFollowing(visitedUser.id)
                    // ignore: unawaited_futures
                    ..loadFollower(visitedUser.id);
                },
                child: DefaultTabController(
                  length: tabs.length,
                  child: NestedScrollView(
                    controller: _scrollController,
                    headerSliverBuilder: (context, innerBoxIsScrolled) {
                      return <Widget>[
                        SliverAppBar(
                          expandedHeight: 250,
                          pinned: true,
                          flexibleSpace: FlexibleSpaceBar(
                            titlePadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            title: Row(
                              children: [
                                Text(
                                  visitedUser.artistName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 32,
                                  ),
                                ),
                              ],
                            ),
                            background: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: (visitedUser.profilePicture.isEmpty)
                                      ? const AssetImage(
                                          'assets/default_avatar.png',
                                        ) as ImageProvider
                                      : CachedNetworkImageProvider(
                                          visitedUser.profilePicture,
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: const [
                                FollowerCount(),
                                FollowingCount(),
                                ShareProfileButton(),
                                FollowButton(),
                              ],
                            ),
                          ),
                        ),
                        const SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 8),
                            child: SocialMediaIcons(),
                          ),
                        ),
                        SliverPersistentHeader(
                          pinned: true,
                          delegate: _SliverAppBarDelegate(
                            TabBar(
                              indicatorColor: tappedAccent,
                              tabs: tabs,
                            ),
                          ),
                        ),
                      ];
                    },
                    body: TabBarView(
                      children: _profileTabs(showVenueDashboard),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      );

  @override
  Widget build(BuildContext context) {
    final databaseRepository =
        RepositoryProvider.of<DatabaseRepository>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body:
          BlocSelector<OnboardingBloc, OnboardingState, Onboarded>(
        selector: (state) {
          return state as Onboarded;
        },
        builder: (context, state) {
          final currentUser = state.currentUser;
          return currentUser.id != visitedUserId
              ? FutureBuilder(
                  future: databaseRepository.getUserById(visitedUserId),
                  builder: (
                    BuildContext context,
                    AsyncSnapshot<UserModel?> snapshot,
                  ) {
                    if (!snapshot.hasData) {
                      return const LoadingView();
                    }

                    final visitedUser = snapshot.data!;
                    return _profilePage(
                      currentUser,
                      visitedUser,
                      databaseRepository,
                    );
                  },
                )
              : _profilePage(
                  currentUser,
                  currentUser,
                  databaseRepository,
                );
        },
      ),
    );
  }
}
