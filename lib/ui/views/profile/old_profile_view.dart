import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/domains/onboarding_bloc/onboarding_bloc.dart';
import 'package:intheloopapp/ui/views/common/loading/loading_view.dart';
import 'package:intheloopapp/ui/views/profile/profile_cubit.dart';
import 'package:intheloopapp/ui/widgets/profile_view/all_loops_list.dart';
import 'package:intheloopapp/ui/widgets/profile_view/badges_list.dart';
import 'package:intheloopapp/ui/widgets/profile_view/profile_header.dart';

@Deprecated('deprecated in favor of `ProfileView.dart')
class OldProfileView extends StatefulWidget {
  @Deprecated('deprecated in favor of `ProfileView()`')
  const OldProfileView({
    required this.visitedUserId,
    Key? key,
  }) : super(key: key);
  final String visitedUserId;

  @override
  ProfileViewState createState() => ProfileViewState();
}

@Deprecated('deprecateed in favor of `ProfileView.dart`')
class ProfileViewState extends State<OldProfileView> {
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
            return BlocListener<OnboardingBloc, OnboardingState>(
              listener: (context, userState) {
                if (userState is Onboarded) {
                  if (userState.currentUser.id == _visitedUserId) {
                    context
                        .read<ProfileCubit>()
                        .refetchVisitedUser(newUserData: userState.currentUser);
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
          BlocSelector<OnboardingBloc, OnboardingState, Onboarded>(
        selector: (state) => state as Onboarded,
        builder: (context, userState) {
          final currentUser = userState.currentUser;

          return currentUser.id != _visitedUserId
              ? FutureBuilder(
                  future: databaseRepository.getUserById(_visitedUserId),
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
