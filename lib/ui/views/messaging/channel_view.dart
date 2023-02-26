import 'package:flutter/material.dart';
import 'package:intheloopapp/ui/views/messaging/channel_header.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class ChannelView extends StatelessWidget {
  const ChannelView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: ChannelHeader(),
      body: Column(
        children: [
          Expanded(
            child: StreamMessageListView(),
          ),
          StreamMessageInput(),
        ],
      ),
    );
  }
}
