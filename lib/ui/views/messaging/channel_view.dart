import 'package:flutter/material.dart';
import 'package:intheloopapp/ui/views/messaging/channel_header.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart'
    hide ChannelHeader;

class ChannelView extends StatelessWidget {
  const ChannelView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ChannelHeader(),
      body: Column(
        children: const [
          Expanded(
            child: StreamMessageListView(),
          ),
          StreamMessageInput(),
        ],
      ),
    );
  }
}
