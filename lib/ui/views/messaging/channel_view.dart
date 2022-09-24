import 'package:flutter/material.dart';
import 'package:intheloopapp/ui/views/messaging/channel_header.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart'
    hide ChannelHeader;

class ChannelView extends StatelessWidget {
  ChannelView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
