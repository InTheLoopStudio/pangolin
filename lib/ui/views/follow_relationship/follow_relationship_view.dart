import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/ui/themes.dart';
import 'package:intheloopapp/ui/views/common/loading/loading_view.dart';
import 'package:intheloopapp/ui/views/follow_relationship/follow_relationship_cubit.dart';
import 'package:intheloopapp/ui/widgets/follow_relationship_view/follower_tab.dart';
import 'package:intheloopapp/ui/widgets/follow_relationship_view/following_tab.dart';

class FollowRelationshipView extends StatelessWidget {
  const FollowRelationshipView({
    Key? key,
    required this.visitedUserId,
    this.initialIndex,
  }) : super(key: key);

  final String visitedUserId;
  final int? initialIndex;

  @override
  Widget build(BuildContext context) {
    final databaseRepository =
        RepositoryProvider.of<DatabaseRepository>(context);

    final theme = Theme.of(context);

    return FutureBuilder<UserModel>(
      future: databaseRepository.getUserById(visitedUserId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const LoadingView();
        }

        final user = snapshot.data!;

        return BlocProvider(
          create: (context) => FollowRelationshipCubit(
            databaseRepository: databaseRepository,
            visitedUserId: visitedUserId,
          )
            ..initFollowers()
            ..initFollowing(),
          child: DefaultTabController(
            initialIndex: initialIndex ?? 0,
            length: 2,
            child: Scaffold(
              backgroundColor: theme.colorScheme.background,
              appBar: AppBar(
                backgroundColor: theme.colorScheme.background,
                bottom: const TabBar(
                  indicatorColor: tappedAccent,
                  labelColor: tappedAccent,
                  tabs: [
                    Tab(
                      child: Text('Followers'),
                    ),
                    Tab(
                      child: Text('Following'),
                    ),
                  ],
                ),
                title: Text(user.username),
              ),
              body: const TabBarView(
                children: [
                  FollowerTab(),
                  FollowingTab(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
