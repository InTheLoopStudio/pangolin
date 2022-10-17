import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/stream_repository.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/ui/views/messaging/channel_view.dart';
import 'package:intheloopapp/ui/widgets/common/user_avatar.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart' hide UserAvatar;

class UserTile extends StatelessWidget {
  const UserTile({Key? key, required this.user}) : super(key: key);

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    final streamRepository = RepositoryProvider.of<StreamRepository>(context);

    return ListTile(
      leading: UserAvatar(
        backgroundImageUrl: user.profilePicture,
        radius: 20,
      ),
      title: Text(user.username),
      onTap: () async {
        final channel = await streamRepository.createSimpleChat(user.id);
        if (channel.state == null) {
          await channel.watch();
        }

        if (!context.mounted) return;
        await Navigator.push(
          context,
          MaterialPageRoute<StreamChannel>(
            builder: (context) => StreamChannel(
              channel: channel,
              child: const ChannelView(),
            ),
          ),
        );
      },
    );
  }
}
