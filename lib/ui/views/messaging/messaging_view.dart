import 'package:flutter/material.dart';
import 'package:intheloopapp/ui/views/common/tapped_app_bar.dart';
import 'package:intheloopapp/ui/views/messaging/channel_list_view.dart';

class MessagingChannelListView extends StatelessWidget {
  const MessagingChannelListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      extendBodyBehindAppBar: true,
      appBar: const TappedAppBar(title: 'Messaging'),
      body: const ChannelListView(),
    );
  }
}
