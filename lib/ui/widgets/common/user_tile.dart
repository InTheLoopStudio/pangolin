import 'package:flutter/material.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/ui/views/profile/profile_view.dart';
import 'package:intheloopapp/ui/widgets/common/user_avatar.dart';

class UserTile extends StatelessWidget {
  const UserTile({
    required this.user,
    super.key,
  });

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: UserAvatar(
        radius: 25,
        backgroundImageUrl: user.profilePicture,
      ),
      title: Text(user.artistName),
      subtitle: Text(user.bio),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute<ProfileView>(
            builder: (context) => ProfileView(
              visitedUserId: user.id,
            ),
          ),
        );
      },
    );
  }
}
