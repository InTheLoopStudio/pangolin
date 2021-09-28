import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/ui/views/follow_relationship/follow_relationship_cubit.dart';
import 'package:intheloopapp/ui/widgets/common/user_tile.dart';

class FollowerTab extends StatelessWidget {
  const FollowerTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FollowRelationshipCubit, FollowRelationshipState>(
      builder: (context, state) {
        return Center(
          child: RefreshIndicator(
            onRefresh: () =>
                context.read<FollowRelationshipCubit>().initFollowers(),
            child: state.followers.isEmpty
                // TODO : Put in something with an action - perhaps a call to upload more loops?
                ? Text('No Followers')
                : ListView.builder(
                    itemCount: state.followers.length,
                    itemBuilder: (BuildContext context, int index) {
                      return UserTile(user: state.followers[index]);
                    },
                  ),
          ),
        );
      },
    );
  }
}
