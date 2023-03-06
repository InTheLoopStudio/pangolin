import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/ui/views/onboarding/onboarding_flow_cubit.dart';
import 'package:intheloopapp/ui/widgets/common/user_avatar.dart';

class FollowRecommendation extends StatelessWidget {
  const FollowRecommendation({
    required this.userId, required this.isFollowing, Key? key,
  }) : super(key: key);

  final String userId;
  final bool isFollowing;

  Widget _followButton({void Function()? onFollow}) {
    if (isFollowing) {
      return ElevatedButton.icon(
        onPressed: () {},
        icon: const Icon(FontAwesomeIcons.check),
        label: const Text(''),
      );
    } else {
      return ElevatedButton.icon(
        onPressed: onFollow,
        icon: const Icon(FontAwesomeIcons.userPlus),
        label: const Text(''),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final databaseRepository =
        RepositoryProvider.of<DatabaseRepository>(context);

    return FutureBuilder<UserModel?>(
      future: databaseRepository.getUserById(userId),
      builder: (context, followUserSnapshot) {
        if (!followUserSnapshot.hasData) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: const CircularProgressIndicator(),
                  trailing: ElevatedButton.icon(
                    onPressed: null,
                    icon: const Icon(FontAwesomeIcons.userPlus),
                    label: const Text(''),
                  ),
                  title: const Text(''),
                ),
              ),
            ],
          );
        }

        final followUser = followUserSnapshot.data!;

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: UserAvatar(
                  radius: 20,
                  backgroundImageUrl: followUser.profilePicture,
                ),
                trailing: _followButton(
                  onFollow: () => context
                      .read<OnboardingFlowCubit>()
                      .followRecommendation(userId),
                ),
                title: Text(followUser.username.toString()),
              ),
            ),
          ],
        );
      },
    );
  }
}
