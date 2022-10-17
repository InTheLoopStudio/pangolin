import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/authentication_bloc/authentication_bloc.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/ui/views/common/loading/loading_view.dart';
import 'package:intheloopapp/ui/views/profile/profile_cubit.dart';
import 'package:intheloopapp/ui/widgets/profile_view/all_loops_list.dart';
import 'package:intheloopapp/ui/widgets/profile_view/badges_list.dart';
import 'package:intheloopapp/ui/widgets/profile_view/profile_header.dart';

@Deprecated('deprecated in favor of `ProfileView.dart')
class OldProfileView extends StatefulWidget {
  const OldProfileView({
    Key? key,
    required this.visitedUserId,
  }) : super(key: key);
  final String visitedUserId;

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

@Deprecated('deprecateed in favor of `ProfileView.dart`')
class _ProfileViewState extends State<OldProfileView> {
  final _scrollController = ScrollController();
  String get _visitedUserId => widget.visitedUserId;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
          ..loadFollower(visitedUser.id)
          ..loadFollowing(visitedUser.id)
          ..loadIsFollowing(currentUser.id, visitedUser.id),
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            return BlocListener<AuthenticationBloc, AuthenticationState>(
              listener: (context, authState) {
                if (authState is Authenticated) {
                  if (authState.currentUser.id == _visitedUserId) {
                    context
                        .read<ProfileCubit>()
                        .refetchVisitedUser(newUserData: authState.currentUser);
                  }
                }
              },
              child: DefaultTabController(
                length: 2,
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
                  child: Scrollbar(
                    child: ListView(
                      controller: _scrollController,
                      physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics(),
                      ),
                      children: [
                        const ProfileHeader(),
                        const TabBar(
                          tabs: [
                            Tab(text: 'Badges'),
                            Tab(text: 'Loops'),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height,
                          child: TabBarView(
                            children: [
                              BadgesList(
                                scrollController: _scrollController,
                              ),
                              SingleChildScrollView(
                                physics: const NeverScrollableScrollPhysics(),
                                child: AllLoopsList(
                                  scrollController: _scrollController,
                                ),
                              ),
                            ],
                          ),
                        )
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
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      body:
          BlocSelector<AuthenticationBloc, AuthenticationState, Authenticated>(
        selector: (state) => state as Authenticated,
        builder: (context, state) {
          final currentUser = state.currentUser;

          return currentUser.id != _visitedUserId
              ? FutureBuilder(
                  future: databaseRepository.getUser(_visitedUserId),
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
