import 'package:flutter/material.dart';
import 'package:intheloopapp/ui/themes.dart';
import 'package:intheloopapp/ui/views/messaging/booking_request_view.dart';
import 'package:intheloopapp/ui/views/messaging/channel_list_view.dart';

class MessagingChannelListView extends StatelessWidget {
  const MessagingChannelListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Row(
          children: [
            Text(
              'Messaging',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: const ChannelListView(),
    );
  }
}
