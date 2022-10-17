import 'package:flutter/material.dart';
import 'package:intheloopapp/ui/views/messaging/channel_view.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class ChannelPreview extends StatelessWidget {
  const ChannelPreview({Key? key, required this.channel}) : super(key: key);

  final Channel channel;

  @override
  Widget build(BuildContext context) {
    final lastMessage = channel.state?.messages.reversed
        .firstWhere((message) => !message.isDeleted);

    final subtitle = lastMessage == null ? 'nothing yet' : lastMessage.text!;
    // final opacity = (channel.state?.unreadCount ?? 0) > 0 ? 1.0 : 0.5;

    return ListTile(
      tileColor: Theme.of(context).colorScheme.background,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute<StreamChannel>(
            builder: (_) => StreamChannel(
              channel: channel,
              child: const ChannelView(),
            ),
          ),
        );
      },
      leading: StreamChannelAvatar(channel: channel),
      title: StreamChannelName(
        channel: channel,
      ),
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
