import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/authentication_bloc/authentication_bloc.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/ui/views/common/loading/loading_view.dart';
import 'package:intheloopapp/ui/views/profile/profile_cubit.dart';
import 'package:intheloopapp/ui/widgets/profile_view/all_loops_list.dart';
import 'package:intheloopapp/ui/widgets/profile_view/badges_list.dart';
import 'package:intheloopapp/ui/widgets/profile_view/follow_button.dart';
import 'package:intheloopapp/ui/widgets/profile_view/follower_count.dart';
import 'package:intheloopapp/ui/widgets/profile_view/following_count.dart';
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
      BuildContext context, double shrinkOffset, bool overlapsContent) {
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
    UserModel _currentUser,
    UserModel _visitedUser,
    DatabaseRepository databaseRepository,
  ) =>
      BlocProvider(
        create: (context) => ProfileCubit(
          databaseRepository: databaseRepository,
          currentUser: _currentUser,
          visitedUser: _visitedUser,
        )
          ..initLoops()
          ..initBadges()
          ..loadFollower(_visitedUser.id)
          ..loadFollowing(_visitedUser.id)
          ..loadIsFollowing(_currentUser.id, _visitedUser.id),
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            return BlocListener<AuthenticationBloc, AuthenticationState>(
              listener: (context, authState) {
                if (authState is Authenticated) {
                  if (authState.currentUser.id == _visitedUser.id) {
                    context
                        .read<ProfileCubit>()
                        .refetchVisitedUser(newUserData: authState.currentUser);
                  }
                }
              },
              child: RefreshIndicator(
                displacement: 20.0,
                onRefresh: () async {
                  context.read<ProfileCubit>()
                    ..initLoops()
                    ..refetchVisitedUser()
                    ..loadIsFollowing(_currentUser.id, _visitedUser.id)
                    ..loadFollowing(_visitedUser.id)
                    ..loadFollower(_visitedUser.id);
                },
                child: DefaultTabController(
                  length: 2,
                  child: NestedScrollView(
                    controller: _scrollController,
                    headerSliverBuilder: ((context, innerBoxIsScrolled) {
                      return <Widget>[
                        SliverAppBar(
                          expandedHeight: 250.0,
                          floating: false,
                          pinned: true,
                          flexibleSpace: FlexibleSpaceBar(
                            titlePadding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                              vertical: 12.0,
                            ),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  _visitedUser.username,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 32.0,
                                  ),
                                ),
                              ],
                            ),
                            background: Image.network(
                              _visitedUser.profilePicture,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                FollowerCount(),
                                FollowingCount(),
                                FollowButton(),
                              ],
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: SocialMediaIcons(),
                          ),
                        ),
                        SliverPersistentHeader(
                          pinned: true,
                          delegate: _SliverAppBarDelegate(
                            TabBar(
                              tabs: [
                                Tab(
                                  text: 'Badges (${_visitedUser.badgesCount})',
                                ),
                                Tab(
                                  text: 'Loops (${_visitedUser.loopsCount})',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ];
                    }),
                    body: TabBarView(children: [
                      SingleChildScrollView(
                        controller: _scrollController,
                        physics: NeverScrollableScrollPhysics(),
                        child: Column(
                          children: [
                            SizedBox(height: 10),
                            OutlinedButton(
                              onPressed: () => {},
                              child: Text('Send Badge'),
                            ),
                            SizedBox(height: 10),
                            BadgesList(scrollController: _scrollController),
                          ],
                        ),
                      ),
                      AllLoopsList(scrollController: _scrollController),
                    ]),
                  ),
                ),
              ),
            );
          },
        ),
      );

  @override
  Widget build(BuildContext context) {
    final DatabaseRepository databaseRepository =
        RepositoryProvider.of<DatabaseRepository>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body:
          BlocSelector<AuthenticationBloc, AuthenticationState, Authenticated>(
        selector: (state) {
          return state as Authenticated;
        },
        builder: (context, state) {
          UserModel currentUser = state.currentUser;
          return currentUser.id != visitedUserId
              ? FutureBuilder(
                  future: databaseRepository.getUser(visitedUserId),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                      return LoadingView();
                    }

                    UserModel visitedUser = snapshot.data!;
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
