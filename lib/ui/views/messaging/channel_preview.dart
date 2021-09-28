import 'package:flutter/material.dart';
import 'package:intheloopapp/ui/views/messaging/channel_name.dart';
import 'package:intheloopapp/ui/views/messaging/channel_view.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart' hide ChannelName;

class ChannelPreview extends StatelessWidget {
  const ChannelPreview({Key? key, required this.channel}) : super(key: key);

  final Channel channel;

  @override
  Widget build(BuildContext context) {
    final lastMessage = channel.state?.messages.reversed
        .firstWhere((message) => !message.isDeleted);

    final subtitle = lastMessage == null ? 'nothing yet' : lastMessage.text!;
    final opacity = (channel.state?.unreadCount ?? 0) > 0 ? 1.0 : 0.5;

    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => StreamChannel(
              channel: channel,
              child: ChannelView(),
            ),
          ),
        );
      },
      leading: ChannelAvatar(channel: channel),
      title: ChannelName(),
      subtitle: Text(subtitle),
      trailing: channel.state!.unreadCount > 0
          ? CircleAvatar(
              radius: 10,
              child: Text(channel.state!.unreadCount.toString()),
            )
          : const SizedBox(),
    );
  }
}
