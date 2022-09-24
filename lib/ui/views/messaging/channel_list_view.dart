import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intheloopapp/data/auth_repository.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/ui/views/common/loading/loading_view.dart';
import 'package:intheloopapp/ui/views/messaging/channel_preview.dart';
import 'package:intheloopapp/ui/views/messaging/channel_view.dart';
import 'package:intheloopapp/ui/views/messaging/new_chat/new_chat_view.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart'
    hide ChannelName, ChannelPreview;

class MessagingChannelListView extends StatelessWidget {
  const MessagingChannelListView({Key? key}) : super(key: key);

  Widget _channelTileBuilder(
    BuildContext context,
    List<Channel> channels,
    int index,
    StreamChannelListTile defaultChannelTile,
  ) {
    final channel = channels[index];

    return ChannelPreview(channel: channel);
  }

  @override
  Widget build(BuildContext context) {
    AuthRepository authRepo = RepositoryProvider.of<AuthRepository>(context);
    return Scaffold(
    backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Center(child: Text('Messaging')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewChatView(),
          ),
        ),
        child: Icon(FontAwesomeIcons.message),
      ),
      body: StreamBuilder<UserModel>(
        stream: authRepo.user,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return LoadingView();
          }

          UserModel currentUser = snapshot.data!;

          return StreamChannelListView(
            controller: StreamChannelListController(
              client: StreamChat.of(context).client,
              filter: Filter.in_(
                'members',
                [currentUser.id],
              ),
              sort: const [SortOption('last_message_at')],
              limit: 20,
            ),
            itemBuilder: _channelTileBuilder,
            onChannelTap: (channel) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return StreamChannel(
                      channel: channel,
                      child: ChannelView(),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
