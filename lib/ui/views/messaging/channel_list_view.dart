import 'package:cancelable_retry/cancelable_retry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/stream_repository.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/onboarding_bloc/onboarding_bloc.dart';
import 'package:intheloopapp/ui/views/common/loading/loading_view.dart';
import 'package:intheloopapp/ui/views/error/error_view.dart';
import 'package:intheloopapp/ui/views/messaging/channel_preview.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart'
    hide ChannelName, ChannelPreview;

class ChannelListView extends StatelessWidget {
  const ChannelListView({super.key});

  @override
  Widget build(BuildContext context) {
    final navigationBloc = context.read<NavigationBloc>();

    return BlocSelector<OnboardingBloc, OnboardingState, UserModel?>(
      selector: (state) => (state is Onboarded) ? state.currentUser : null,
      builder: (context, currentUser) {
        if (currentUser == null) {
          return const ErrorView();
        }

        final future = CancelableRetry(
          () => context.read<StreamRepository>().connectUser(currentUser.id),
          retryIf: (bool result) => !result,
        );

        return FutureBuilder<bool>(
          future: future.run(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const LoadingView();
            }

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
                navigationBloc.add(PushStreamChannel(channel));
              },
            );
          },
        );
      },
    );
  }
}
