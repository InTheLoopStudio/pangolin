import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/onboarding_bloc/onboarding_bloc.dart';
import 'package:intheloopapp/ui/views/messaging/channel_preview.dart';
import 'package:intheloopapp/ui/views/messaging/channel_view.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart'
    hide ChannelName, ChannelPreview;

class ChannelListView extends StatelessWidget {
  const ChannelListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocSelector<OnboardingBloc, OnboardingState, Onboarded>(
      selector: (state) => state as Onboarded,
      builder: (context, userState) {
        final currentUser = userState.currentUser;

        return StreamChannelListView(
          controller: StreamChannelListController(
            client: StreamChat.of(context).client,
            filter: Filter.in_(
              'members',
              [currentUser.id],
            ),
            channelStateSort: const [SortOption('last_message_at')],
            limit: 20,
          ),
          itemBuilder: (
            BuildContext context,
            List<Channel> channels,
            int index,
            StreamChannelListTile defaultChannelTile,
          ) {
            final channel = channels[index];

            return ChannelPreview(channel: channel);
          },
          onChannelTap: (channel) {
            Navigator.of(context).push(
              MaterialPageRoute<StreamChannel>(
                builder: (context) {
                  return StreamChannel(
                    channel: channel,
                    child: const ChannelView(),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
