import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/ui/views/onboarding/onboarding_cubit.dart';
import 'package:intheloopapp/ui/widgets/common/user_avatar.dart';

class FollowRecommendation extends StatelessWidget {
  const FollowRecommendation(
      {Key? key, required this.userId, required this.isFollowing})
      : super(key: key);

  final String userId;
  final bool isFollowing;

  Widget _followButton({void Function()? onFollow}) {
    if (isFollowing) {
      return ElevatedButton.icon(
        onPressed: () {},
        icon: Icon(FontAwesomeIcons.check),
        label: Text(''),
      );
    } else {
      return ElevatedButton.icon(
        onPressed: onFollow,
        icon: Icon(FontAwesomeIcons.userPlus),
        label: Text(''),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    DatabaseRepository databaseRepository =
        RepositoryProvider.of<DatabaseRepository>(context);

    return FutureBuilder<UserModel>(
      future: databaseRepository.getUser(userId),
      builder: (context, followUserSnapshot) {
        if (!followUserSnapshot.hasData) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  leading: CircularProgressIndicator(),
                  trailing: ElevatedButton.icon(
                    onPressed: null,
                    icon: Icon(FontAwesomeIcons.userPlus),
                    label: Text(''),
                  ),
                  title: Text(''),
                ),
              ),
            ],
          );
        }

        UserModel followUser = followUserSnapshot.data!;

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                leading: UserAvatar(
                  radius: 20,
                  backgroundImageUrl: followUser.profilePicture,
                ),
                trailing: _followButton(
                  onFollow: () => context
                      .read<OnboardingCubit>()
                      .followRecommendation(userId),
                ),
                title: Text(followUser.username),
              ),
            ),
          ],
        );
      },
    );
  }
}
