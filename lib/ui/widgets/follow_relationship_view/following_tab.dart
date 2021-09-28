import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/ui/views/follow_relationship/follow_relationship_cubit.dart';
import 'package:intheloopapp/ui/widgets/common/user_tile.dart';

class FollowingTab extends StatelessWidget {
  const FollowingTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FollowRelationshipCubit, FollowRelationshipState>(
      builder: (context, state) {
        return Center(
          child: RefreshIndicator(
            onRefresh: () =>
                context.read<FollowRelationshipCubit>().initFollowing(),
            child: state.following.isEmpty
                // TODO : Replace with follow recommendations
                ? Text("No Following")
                : ListView.builder(
                    itemCount: state.following.length,
                    itemBuilder: (BuildContext context, int index) {
                      return UserTile(user: state.following[index]);
                    },
                  ),
          ),
        );
      },
    );
  }
}
