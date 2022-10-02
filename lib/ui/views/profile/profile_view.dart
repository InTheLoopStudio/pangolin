import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/authentication_bloc/authentication_bloc.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/ui/themes.dart';
import 'package:intheloopapp/ui/views/common/loading/loading_view.dart';
import 'package:intheloopapp/ui/views/profile/profile_cubit.dart';
import 'package:intheloopapp/ui/views/send_badge/send_badge_view.dart';
import 'package:intheloopapp/ui/widgets/profile_view/all_loops_list.dart';
import 'package:intheloopapp/ui/widgets/profile_view/badges_list.dart';
import 'package:intheloopapp/ui/widgets/profile_view/follow_button.dart';
import 'package:intheloopapp/ui/widgets/profile_view/follower_count.dart';
import 'package:intheloopapp/ui/widgets/profile_view/following_count.dart';
import 'package:intheloopapp/ui/widgets/profile_view/share_profile_button.dart';
import 'package:intheloopapp/ui/widgets/profile_view/social_media_icons.dart';

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
    return Container(
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
          ..loadFollower(visitedUser.id)
          ..loadFollowing(visitedUser.id)
          ..loadIsFollowing(currentUser.id, visitedUser.id),
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            final showBadgeButton = currentUser.id == visitedUser.id &&
                currentUser.accountType == AccountType.Venue;
            return BlocListener<AuthenticationBloc, AuthenticationState>(
              listener: (context, authState) {
                if (authState is Authenticated) {
                  if (authState.currentUser.id == visitedUser.id) {
                    context
                        .read<ProfileCubit>()
                        .refetchVisitedUser(newUserData: authState.currentUser);
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
                    ..refetchVisitedUser()
                    // ignore: unawaited_futures
                    ..loadIsFollowing(currentUser.id, visitedUser.id)
                    // ignore: unawaited_futures
                    ..loadFollowing(visitedUser.id)
                    // ignore: unawaited_futures
                    ..loadFollower(visitedUser.id);
                },
                child: DefaultTabController(
                  length: 2,
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
                                  visitedUser.username,
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
                                              'assets/default_avatar.png')
                                          as ImageProvider
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
                              tabs: [
                                Tab(
                                  text: 'Badges (${visitedUser.badgesCount})',
                                ),
                                Tab(
                                  text: 'Loops (${visitedUser.loopsCount})',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ];
                    },
                    body: TabBarView(
                      children: [
                        SingleChildScrollView(
                          controller: _scrollController,
                          physics: const NeverScrollableScrollPhysics(),
                          child: Column(
                            children: [
                              if (showBadgeButton)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  child: OutlinedButton(
                                    onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute<SendBadgeView>(
                                        builder: (context) =>
                                            const SendBadgeView(),
                                      ),
                                    ),
                                    child: const Text('Send Badge'),
                                  ),
                                )
                              else
                                const SizedBox.shrink(),
                              const SizedBox(
                                height: 20,
                              ),
                              BadgesList(scrollController: _scrollController),
                            ],
                          ),
                        ),
                        AllLoopsList(scrollController: _scrollController),
                      ],
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
      backgroundColor: Theme.of(context).backgroundColor,
      body:
          BlocSelector<AuthenticationBloc, AuthenticationState, Authenticated>(
        selector: (state) {
          return state as Authenticated;
        },
        builder: (context, state) {
          final currentUser = state.currentUser;
          return currentUser.id != visitedUserId
              ? FutureBuilder(
                  future: databaseRepository.getUser(visitedUserId),
                  builder: (
                    BuildContext context,
                    AsyncSnapshot<UserModel> snapshot,
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
