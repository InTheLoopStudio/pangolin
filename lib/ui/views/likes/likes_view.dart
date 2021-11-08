import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/models/loop.dart';
import 'package:intheloopapp/ui/views/likes/likes_cubit.dart';
import 'package:intheloopapp/ui/widgets/common/user_tile.dart';

class LikesView extends StatelessWidget {
  const LikesView({
    Key? key,
    required this.loop,
  }) : super(key: key);

  final Loop loop;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider(
      create: (context) => LikesCubit(
        databaseRepository: context.read<DatabaseRepository>(),
        loop: loop,
      )..initLikes(),
      child: Scaffold(
        backgroundColor: theme.backgroundColor,
        appBar: AppBar(
          title: Text(loop.title),
        ),
        body: BlocBuilder<LikesCubit, LikesState>(
          builder: (context, state) {
            return Center(
              child: RefreshIndicator(
                onRefresh: () => context.read<LikesCubit>().initLikes(),
                child: ListView.builder(
                  itemCount: state.likes.length,
                  itemBuilder: (BuildContext context, int index) {
                    return UserTile(user: state.likes[index]);
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
