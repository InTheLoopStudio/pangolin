import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/ui/widgets/common/user_avatar.dart';

class UserTile extends StatelessWidget {
  const UserTile({required this.user, Key? key}) : super(key: key);

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    final navigationBloc = BlocProvider.of<NavigationBloc>(context);

    return ListTile(
      leading: UserAvatar(
        backgroundImageUrl: user.profilePicture,
        radius: 20,
      ),
      title: Text(user.username.toString()),
      onTap: () => navigationBloc.add(PushProfile(user.id)),
    );
  }
}
