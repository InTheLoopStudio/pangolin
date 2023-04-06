import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/ui/views/follow_relationship/follow_relationship_view.dart';
import 'package:intheloopapp/ui/views/profile/profile_cubit.dart';
import 'package:intl/intl.dart';

class FollowerCount extends StatelessWidget {
  const FollowerCount({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<FollowRelationshipView>(
                settings: RouteSettings(name: '/followers/${state.visitedUser.username}'),
                builder: (context) => FollowRelationshipView(
                  visitedUserId: state.visitedUser.id,
                  initialIndex: 0,
                ),
              ),
            );
          },
          child: Text(
            '${NumberFormat.compactCurrency(
              decimalDigits: 0,
              symbol: '',
            ).format(state.followerCount)} Followers',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      },
    );
  }
}
