import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
// ignore: implementation_imports
import 'package:stream_chat_flutter/src/extension.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// It shows the current [Channel] name using a [Text] widget.
///
/// The widget uses a [StreamBuilder] to render the channel information
/// image as soon as it updates.
class ChannelName extends StatelessWidget {
  /// Instantiate a new ChannelName
  const ChannelName({
    Key? key,
    this.textStyle,
    this.textOverflow = TextOverflow.ellipsis,
  }) : super(key: key);

  /// The style of the text displayed
  final TextStyle? textStyle;

  /// How visual overflow should be handled.
  final TextOverflow textOverflow;

  @override
  Widget build(BuildContext context) {
    final client = StreamChat.of(context);
    final channel = StreamChannel.of(context).channel;
    final databaseRepository =
        RepositoryProvider.of<DatabaseRepository>(context);

    return BetterStreamBuilder<Map<String, Object?>>(
      stream: channel.extraDataStream,
      initialData: channel.extraData,
      builder: (context, data) => _buildName(
        databaseRepository,
        data,
        channel.state?.members ?? [],
        client,
      ),
    );
  }

  Widget _buildName(
    DatabaseRepository databaseRepository,
    Map<String, dynamic> extraData,
    List<Member> members,
    StreamChatState client,
  ) =>
      FutureBuilder<List<UserModel>>(
        future: Future.wait(
          members.map((member) async {
            final user =
                await databaseRepository.getUserById(member.userId ?? '');
            return user ?? UserModel.empty();
          }),
        ),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox.shrink();
          }

          final userMembers = snapshot.data!;

          return LayoutBuilder(
            builder: (context, constraints) {
              var title = context.translations.noTitleText;
              if (extraData['name'] != null) {
                title = extraData['name'] as String;
              } else {
                final otherMembers = userMembers
                    .where((member) => member.id != client.currentUser!.id);
                if (otherMembers.length == 1) {
                  title = otherMembers.first.username;
                } else if (otherMembers.isNotEmpty == true) {
                  final maxWidth = constraints.maxWidth;
                  final maxChars = maxWidth / (textStyle?.fontSize ?? 1);
                  var currentChars = 0;
                  final currentMembers = <UserModel>[];
                  for (final element in otherMembers) {
                    final newLength = currentChars + (element.username.length);
                    if (newLength < maxChars) {
                      currentChars = newLength;
                      currentMembers.add(element);
                    }
                  }

                  final exceedingMembers =
                      otherMembers.length - currentMembers.length;
                  title = '${currentMembers.map((e) => e.username).join(', ')} '
                      '${exceedingMembers > 0 ? '+ $exceedingMembers' : ''}';
                }
              }

              return Text(
                title,
                style: textStyle,
                overflow: textOverflow,
              );
            },
          );
        },
      );
}
