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

  @override
  Widget build(BuildContext context) {
    AuthRepository authRepo = RepositoryProvider.of<AuthRepository>(context);
    return Scaffold(
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
        child: Icon(FontAwesomeIcons.commentAlt),
      ),
      body: StreamBuilder<UserModel>(
        stream: authRepo.user,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return LoadingView();
          }

          UserModel currentUser = snapshot.data!;

          return ChannelsBloc(
            child: ChannelListView(
              filter: Filter.in_(
                'members',
                [currentUser.id],
              ),
              sort: const [SortOption('last_message_at')],
              pagination: const PaginationParams(
                limit: 20,
              ),
              channelPreviewBuilder: (_, channel) =>
                  ChannelPreview(channel: channel),
              channelWidget: ChannelView(),
            ),
          );
        },
      ),
    );
  }
}
