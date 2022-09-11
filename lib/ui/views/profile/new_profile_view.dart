import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/authentication_bloc/authentication_bloc.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/ui/views/common/loading/loading_view.dart';
import 'package:intheloopapp/ui/views/profile/profile_cubit.dart';
import 'package:intheloopapp/ui/widgets/profile_view/follower_count.dart';
import 'package:intheloopapp/ui/widgets/profile_view/following_count.dart';

class NewProfileView extends StatelessWidget {
  const NewProfileView({Key? key, required this.visitedUserId})
      : super(key: key);

  final String visitedUserId;

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
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: 250.0,
                    floating: false,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      titlePadding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 12.0,
                      ),
                      title: Text(
                        _visitedUser.username,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32.0,
                        ),
                      ),
                      background: Image.network(
                        _visitedUser.profilePicture,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        const SizedBox(height: 20.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            FollowingCount(),
                            FollowerCount(),
                            ElevatedButton(
                              onPressed: () {},
                              child: Text('Edit'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 50.0),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text(
                            "All Loops",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                        for (int i = 0; i < 20; i++)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                              vertical: 10.0,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              height: 100,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
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
