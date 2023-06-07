import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/stream_repository.dart';
import 'package:intheloopapp/domains/models/option.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/ui/widgets/common/user_avatar.dart';

class UserTile extends StatelessWidget {
  const UserTile({required this.user, super.key});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    final streamRepository = RepositoryProvider.of<StreamRepository>(context);
    final navigationBloc = BlocProvider.of<NavigationBloc>(context);

    return ListTile(
      leading: UserAvatar(
        pushUser: Some(user),
        imageUrl: user.profilePicture,
        radius: 20,
      ),
      title: Text(user.username.toString()),
      onTap: () async {
        final channel = await streamRepository.createSimpleChat(user.id);
        if (channel.state == null) {
          await channel.watch();
        }

        navigationBloc.add(PushStreamChannel(channel));
      },
    );
  }
}
